`timescale 1ns/100ps
module fr_ctrl (

   input  wire        rstn,
   input  wire        clk,
   
   input  wire        fr_update_start,
   output  reg        fr_update_done,
   output wire        fr_update_pass,
   
   input  wire  [7:0] i2c_slave_address,
   
   input  wire        fb_update_en,
   input  wire [15:0] fb_update,
   
   // Wishbone interface
   output wire        wb_cyc_o,
   output  reg        wb_stb_o,
   output  reg        wb_we_o, 
   output  reg  [7:0] wb_adr_o, 
   input  wire  [7:0] wb_dat_i,
   output  reg  [7:0] wb_dat_o,
   input  wire        wb_ack_i

   );

reg [16:0] delay_count;
reg [4:0]  efb_state;
reg [1:0]  err_cnt;
reg [63:0] init_fr;
reg        fr_erased;
reg        fr_programmed;
reg        fr_prog_err;
reg [15:0] init_fb;
reg        fb_erased;
reg        fb_programmed;
reg        fb_prog_err;
reg        busy;
reg        wb_stb;

reg  [7:0] cmd_count;                             // Primary command counter register (see description below)
wire [5:0] current_command = cmd_count[7:2];      // Upper bits used as the index into command tables
wire       strobe          = ~cmd_count[1];


`define DELAY_ISCEN    440//53     // 5us pump ready time after ISC_ENABLE_X @ 50 MHz clock//@ ~10.5MHz clock

`ifdef _VCP
   `define ERASE_DELAY_LOOP     500   // reduced number for simulation
   //`define ERASE_BYPASS         1     // Comment this line to include the erase operation in simulation.
   //`define BUSY_CHK_BYPASS            // used for the simulation because it is stuck to busy after Dry Run in the simulation
`else
   `define ERASE_DELAY_LOOP     88000   // Approx 1ms wait per polling loop @ 50 MHz clock
`endif

//register mapping for EFB Flash
`define WBCFG_CTRL0    8'h70  // Configuration control register address
`define WBCFG_TXDR     8'h71  // Configuration transmit register address
`define WBCFG_RXDR     8'h73  // Configuration receive register address

parameter st_idle               = 5'd0;
parameter st_isc_enable_x       = 5'd1;
parameter st_enable_x_delay     = 5'd2;
parameter st_enable_x_chk_busy  = 5'd3;
parameter st_cmd                = 5'd4;
parameter st_erase              = 5'd5;
parameter st_erase_delay        = 5'd6;
parameter st_erase_chk_busy     = 5'd7;
parameter st_disable            = 5'd8;
parameter st_read_fr            = 5'd9;
parameter st_read_fb            = 5'd10;
parameter st_prog_fr            = 5'd11;
parameter st_prog_fr_delay      = 5'd12;
parameter st_prog_fr_chk_busy   = 5'd13;
parameter st_prog_fb            = 5'd14;
parameter st_prog_fb_delay      = 5'd15;
parameter st_prog_fb_chk_busy   = 5'd16;

`define ENABLE_CNT 7
wire [16:0] enable_cmd[`ENABLE_CNT-1:0];
//                         wb_we    wb_adr     wb_dat_i
//                           16   15.......8    7..0
assign enable_cmd[0]    = {1'b1, `WBCFG_CTRL0, 8'h80};//8'hC0};   // WB Reset
assign enable_cmd[1]    = {1'b1, `WBCFG_CTRL0, 8'h80};   // WB Enable
assign enable_cmd[2]    = {1'b1, `WBCFG_TXDR,  8'h74};   // ISC_ENABLE_X
assign enable_cmd[3]    = {1'b1, `WBCFG_TXDR,  8'h08};   // OP1 = Flash normal
assign enable_cmd[4]    = {1'b1, `WBCFG_TXDR,  8'h00};   // OP2
assign enable_cmd[5]    = {1'b1, `WBCFG_TXDR,  8'h00};   // OP3
assign enable_cmd[6]    = {1'b1, `WBCFG_CTRL0, 8'h00};   // WB Disable (Execute)

`define ERASE_CNT 6
wire [16:0] erase_cmd[`ERASE_CNT-1:0];
assign erase_cmd[0]     = {1'b1, `WBCFG_CTRL0, 8'h80};   // WB Enable
assign erase_cmd[1]     = {1'b1, `WBCFG_TXDR,  8'h0E};   // ISC_ERASE
assign erase_cmd[2]     = {1'b1, `WBCFG_TXDR,  8'h02};   // OP1, Feature_Row sectors selection
assign erase_cmd[3]     = {1'b1, `WBCFG_TXDR,  8'h00};   // OP2
assign erase_cmd[4]     = {1'b1, `WBCFG_TXDR,  8'h00};   // OP3
assign erase_cmd[5]     = {1'b1, `WBCFG_CTRL0, 8'h00};   // WB Disable (Execute)

`define CHKBSY_CNT 7
wire [16:0] busy_cmd[`CHKBSY_CNT-1:0];
assign busy_cmd[0]      = {1'b1, `WBCFG_CTRL0, 8'h80};   // WB Enable
assign busy_cmd[1]      = {1'b1, `WBCFG_TXDR,  8'hF0};   // CHECK_BUSY
assign busy_cmd[2]      = {1'b1, `WBCFG_TXDR,  8'h00};   // OP1
assign busy_cmd[3]      = {1'b1, `WBCFG_TXDR,  8'h00};   // OP2
assign busy_cmd[4]      = {1'b1, `WBCFG_TXDR,  8'h00};   // OP3
assign busy_cmd[5]      = {1'b0, `WBCFG_RXDR,  8'h00};   // Read data register
assign busy_cmd[6]      = {1'b1, `WBCFG_CTRL0, 8'h00};   // WB Disable (Execute)

`define DISABLE_CNT 9
wire [16:0] disable_cmd[`DISABLE_CNT-1:0];
assign disable_cmd[0]   = {1'b1, `WBCFG_CTRL0, 8'h80};   // WB Enable
assign disable_cmd[1]   = {1'b1, `WBCFG_TXDR,  8'h26};   // ISC_DISABLE
assign disable_cmd[2]   = {1'b1, `WBCFG_TXDR,  8'h00};   // OP1
assign disable_cmd[3]   = {1'b1, `WBCFG_TXDR,  8'h00};   // OP2
assign disable_cmd[4]   = {1'b1, `WBCFG_TXDR,  8'h00};   // OP3 added
assign disable_cmd[5]   = {1'b1, `WBCFG_CTRL0, 8'h00};   // WB Disable (Execute)
assign disable_cmd[6]   = {1'b1, `WBCFG_CTRL0, 8'h80};   // WB Enable
assign disable_cmd[7]   = {1'b1, `WBCFG_TXDR,  8'hFF};   // NOOP
assign disable_cmd[8]   = {1'b1, `WBCFG_CTRL0, 8'h00};   // WB Disable (Execute)

`define READFR_CNT 14
wire [16:0] readfr_cmd[`READFR_CNT-1:0];
assign readfr_cmd[0]   = {1'b1, `WBCFG_CTRL0, 8'h80};   // WB Enable
assign readfr_cmd[1]   = {1'b1, `WBCFG_TXDR,  8'hE7};   // LSC_READ_FEATURE
assign readfr_cmd[2]   = {1'b1, `WBCFG_TXDR,  8'h00};   // OP1
assign readfr_cmd[3]   = {1'b1, `WBCFG_TXDR,  8'h00};   // OP2
assign readfr_cmd[4]   = {1'b1, `WBCFG_TXDR,  8'h00};   // OP3 added
assign readfr_cmd[5]   = {1'b0, `WBCFG_RXDR,  8'h00};   // Read data register
assign readfr_cmd[6]   = {1'b0, `WBCFG_RXDR,  8'h00};   // Read data register
assign readfr_cmd[7]   = {1'b0, `WBCFG_RXDR,  8'h00};   // Read data register
assign readfr_cmd[8]   = {1'b0, `WBCFG_RXDR,  8'h00};   // Read data register
assign readfr_cmd[9]   = {1'b0, `WBCFG_RXDR,  8'h00};   // Read data register
assign readfr_cmd[10]  = {1'b0, `WBCFG_RXDR,  8'h00};   // Read data register
assign readfr_cmd[11]  = {1'b0, `WBCFG_RXDR,  8'h00};   // Read data register
assign readfr_cmd[12]  = {1'b0, `WBCFG_RXDR,  8'h00};   // Read data register
assign readfr_cmd[13]  = {1'b1, `WBCFG_CTRL0, 8'h00};   // WB Disable (Execute)

`define PROGFR_CNT 14
wire [16:0] progfr_cmd[`PROGFR_CNT-1:0];
assign progfr_cmd[0]   = {1'b1, `WBCFG_CTRL0, 8'h80};            // WB Enable
assign progfr_cmd[1]   = {1'b1, `WBCFG_TXDR,  8'hE4};            // LSC_PROG_FEATURE
assign progfr_cmd[2]   = {1'b1, `WBCFG_TXDR,  8'h00};            // OP1
assign progfr_cmd[3]   = {1'b1, `WBCFG_TXDR,  8'h00};            // OP2
assign progfr_cmd[4]   = {1'b1, `WBCFG_TXDR,  8'h00};            // OP3 added
assign progfr_cmd[5]   = {1'b1, `WBCFG_TXDR,  init_fr[7:0]};     // Feature_Row[7:0]
assign progfr_cmd[6]   = {1'b1, `WBCFG_TXDR,  init_fr[15:8]};    // Feature_Row[15:8]
assign progfr_cmd[7]   = {1'b1, `WBCFG_TXDR,  init_fr[23:16]};   // I2C slave address
assign progfr_cmd[8]   = {1'b1, `WBCFG_TXDR,  init_fr[31:24]};   // TraceID
assign progfr_cmd[9]   = {1'b1, `WBCFG_TXDR,  init_fr[39:32]};   // Custom_ID[7:0]
assign progfr_cmd[10]  = {1'b1, `WBCFG_TXDR,  init_fr[47:40]};   // Custom_ID[15:8]
assign progfr_cmd[11]  = {1'b1, `WBCFG_TXDR,  init_fr[55:48]};   // Custom_ID[23:16]
assign progfr_cmd[12]  = {1'b1, `WBCFG_TXDR,  init_fr[63:56]};   // Custom_ID[31:24]
assign progfr_cmd[13]  = {1'b1, `WBCFG_CTRL0, 8'h00};            // WB Disable (Execute)

`define READFB_CNT 8
wire [16:0] readfb_cmd[`READFB_CNT-1:0];
assign readfb_cmd[0]   = {1'b1, `WBCFG_CTRL0, 8'h80};   // WB Enable
assign readfb_cmd[1]   = {1'b1, `WBCFG_TXDR,  8'hFB};   // LSC_READ_FEABITS
assign readfb_cmd[2]   = {1'b1, `WBCFG_TXDR,  8'h00};   // OP1
assign readfb_cmd[3]   = {1'b1, `WBCFG_TXDR,  8'h00};   // OP2
assign readfb_cmd[4]   = {1'b1, `WBCFG_TXDR,  8'h00};   // OP3 added
assign readfb_cmd[5]   = {1'b0, `WBCFG_RXDR,  8'h00};   // Read data register
assign readfb_cmd[6]   = {1'b0, `WBCFG_RXDR,  8'h00};   // Read data register
assign readfb_cmd[7]   = {1'b1, `WBCFG_CTRL0, 8'h00};   // WB Disable (Execute)

`define PROGFB_CNT 8
wire [16:0] progfb_cmd[`PROGFB_CNT-1:0];
assign progfb_cmd[0]   = {1'b1, `WBCFG_CTRL0, 8'h80};            // WB Enable
assign progfb_cmd[1]   = {1'b1, `WBCFG_TXDR,  8'hF8};            // LSC_PROG_FEABITS
assign progfb_cmd[2]   = {1'b1, `WBCFG_TXDR,  8'h00};            // OP1
assign progfb_cmd[3]   = {1'b1, `WBCFG_TXDR,  8'h00};            // OP2
assign progfb_cmd[4]   = {1'b1, `WBCFG_TXDR,  8'h00};            // OP3 added
assign progfb_cmd[5]   = {1'b1, `WBCFG_TXDR,  init_fb[7:0]};     // Feature_Bit[7:0]
assign progfb_cmd[6]   = {1'b1, `WBCFG_TXDR,  init_fb[15:8]};    // Feature_Bit[15:8]
assign progfb_cmd[7]   = {1'b1, `WBCFG_CTRL0, 8'h00};            // WB Disable (Execute)

assign wb_cyc_o = wb_stb_o;

// create 80ps delay on rising edge of wb_stb, to avoid simulation mismatch due to sim model issue.    
always@(*)
        if(wb_stb)
            wb_stb_o <= #1 1;
        else
            wb_stb_o <= 0;

always @ ( posedge clk or negedge rstn ) begin
  if ( !rstn ) begin
    efb_state      <= st_idle;
    cmd_count      <= 0;
    err_cnt        <= 2'd0;
    init_fr        <= 64'd0;
    fr_erased      <= 1'b0;
    fr_programmed  <= 1'b0;
    fr_prog_err    <= 1'b0;
    init_fb        <= 16'd0;
    fb_erased      <= 1'b0;
    fb_programmed  <= 1'b0;
    fb_prog_err    <= 1'b0;
    busy           <= 0;
    wb_dat_o       <= 0;
    wb_adr_o       <= 0;
    wb_stb         <= 0;
    wb_we_o        <= 0;
  end
  else begin
    case ( efb_state )
      /* ############################################################################################## */
      // st_init - the initial state, waits from the fr_update_start signal to start the process
      /* ############################################################################################## */
      st_idle : begin
         if ( fr_update_start ) begin
            efb_state <= st_isc_enable_x;
         end
      end  
            
      /* ############################################################################################## */
      // st_isc_enable_x - sends the command sequence required to enable flash erase mode
      /* ############################################################################################## */
      st_isc_enable_x : begin
          if (current_command < `ENABLE_CNT) begin
              {wb_we_o, wb_adr_o, wb_dat_o} <= enable_cmd[current_command];
              
              cmd_count <= cmd_count + 1;
              wb_stb <= strobe;
          end
          else begin
              cmd_count <= 0;
              efb_state <= st_enable_x_delay;
          end
      end

      /* ############################################################################################## */
      // st_enable_x_delay - Implements a delay to satisfy the device requirement after enabling Flash
      //                   edit mode. Delay implemented dependent upon constant value assignment and
      //                   clock rate
      /* ############################################################################################## */
      st_enable_x_delay : begin
          if (delay_count < `DELAY_ISCEN)
              delay_count <= delay_count + 1;
          else begin
             delay_count <= 0;
             efb_state <= st_enable_x_chk_busy;
          end
      end

      st_enable_x_chk_busy : begin
          if (current_command < `CHKBSY_CNT) begin
             {wb_we_o, wb_adr_o, wb_dat_o} <= busy_cmd[current_command];
             cmd_count <= cmd_count + 1;
             wb_stb <= strobe;
                    
             if (!wb_we_o && wb_ack_i) begin
                busy <= wb_dat_i[7];
             end
          end
          else begin
             cmd_count <= 0;
             if (busy) 
                efb_state <= st_enable_x_delay; 
             else 
                efb_state <= st_read_fr;
         end
      end

      st_cmd : begin
          `ifdef ERASE_BYPASS 
              efb_state <= st_erase_delay;
              $display($time,"  %m  \t \t  << erase_ctrl.v ******** INFO : FLASH array erase BYPASSED.  Verify may fail >>");
          `else
              efb_state <= st_erase;
          `endif
      end
      
      /* ############################################################################################## */
      // st_erase - sends command sequences to start the erase of Flash config arrays
      /* ############################################################################################## */
      st_erase : begin
          if ( err_cnt > 1 )
             efb_state <= st_disable;
          else if (current_command < `ERASE_CNT) begin
              {wb_we_o, wb_adr_o, wb_dat_o} <= erase_cmd[current_command];
              
              cmd_count <= cmd_count + 1;
              wb_stb <= strobe;
          end
          else begin
              cmd_count <= 0;
              efb_state <= st_erase_delay;
          end
      end

      /* ############################################################################################## */
      // st_erase_delay - A nominal delay used in the status polling while the erase command is being
      //                  performed. An optional delay, the presence of this step reduces the number
      //                  of reads needed on the wishbone while the device is being erased.
      /* ############################################################################################## */
      st_erase_delay : begin
          if (delay_count < `ERASE_DELAY_LOOP)
              delay_count <= delay_count + 1;
          else begin
              delay_count <= 0;
              efb_state <= st_erase_chk_busy;
          end
      end

      /* ############################################################################################## */
      // st_erase_chk_busy - Issues the command sequence to read the busy status during the erase
      //                     process. Continues once erase is complete, otherwise branches back to
      //                     the previous state for more delay before checking again.
      /* ############################################################################################## */
      st_erase_chk_busy : begin
          if (current_command < `CHKBSY_CNT) begin
              {wb_we_o, wb_adr_o, wb_dat_o} <= busy_cmd[current_command];
              
              cmd_count <= cmd_count + 1;
              wb_stb <= strobe;
                    
              if (!wb_we_o && wb_ack_i) begin
                  busy <= wb_dat_i[7];
              end
          end
          else begin
              cmd_count <= 0;
              if (busy)
                  efb_state <= st_erase_delay;
              else begin
                  fr_erased <= 1'b1;
                  fr_programmed <= 1'b0;
                  fr_prog_err <= 1'b0;
                  fb_erased <= 1'b1;
                  fb_programmed <= 1'b0;
                  fb_prog_err <= 1'b0;
                  efb_state <= st_read_fr;
              end
          end
      end


      /* ############################################################################################## */
      // st_read_fr - Issues the command sequence to read the Feature_Row data. For the erased chip,
      //              save the initial Feature_Row data into the registers init_fr[63:0]; for the programmed
      //              chip, compare the wishbone output data with the expected Feature_Row -- init_fr[63:0].
      /* ############################################################################################## */
      st_read_fr : begin
          if (current_command < `READFR_CNT) begin
              {wb_we_o, wb_adr_o, wb_dat_o} <= readfr_cmd[current_command];
              
              cmd_count <= cmd_count + 1;
              wb_stb <= strobe;
                    
              if (!wb_we_o && wb_ack_i) begin
                 // check the programmed Feature_Row data
                 if ( fr_programmed ) begin
                    `ifdef _VCP
                    $display("\t\t\t at", $time, "ns, recieve programmed FR data %h from wishbone, expect %h", wb_dat_i[7:0], init_fr[7:0]);
                    `endif
                    init_fr <= { 8'd0, init_fr[63:8] };
                    if ( wb_dat_i[7:0] != init_fr[7:0] )
                       fr_prog_err <= 1'b1;
                 end
                 // check the default Feature_Row data after erasing
                 else if ( fr_erased ) begin
                    `ifdef _VCP
                    $display("\t\t\t at", $time, "ns, recieve default FR data %h from wishbone", wb_dat_i[7:0]);
                    `endif
                    //init_fr <= { wb_dat_i[7:0], init_fr[63:8] };
                 end
                 // save the initial Feature_Row data
                 else begin
                    `ifdef _VCP
                    $display("\t\t\t at", $time, "ns, recieve init FR data %h from wishbone", wb_dat_i[7:0]);
                    `endif
                    init_fr <= { wb_dat_i[7:0], init_fr[63:8] };
                 end
              end
          end
          else begin
              cmd_count <= 0;
              if ( fr_erased ) begin
                 init_fr[23:16] <= i2c_slave_address;
				 // init_fr[47:40] <= i2c_slave_address;
                 efb_state <= st_read_fb;
              end
              else if ( fr_programmed ) begin
                 if ( fr_prog_err ) begin
                    err_cnt <= err_cnt + 1;
                    efb_state <= st_erase;
                 end
                 else
                    efb_state <= st_read_fb;
              end
              else
                 efb_state <= st_read_fb;
          end
      end

      /* ############################################################################################## */
      // st_read_fb - Issues the command sequence to read the Feature_Row bits. For the erased chip,
      //              save the initial Feature_Row bits into the registers init_fb[15:0]; for the programmed
      //              chip, compare the wishbone output data with the expected Feature_Row -- init_fb[15:0].
      /* ############################################################################################## */
      st_read_fb : begin
          if (current_command < `READFB_CNT) begin
              {wb_we_o, wb_adr_o, wb_dat_o} <= readfb_cmd[current_command];
              
              cmd_count <= cmd_count + 1;
              wb_stb <= strobe;
                    
              if (!wb_we_o && wb_ack_i) begin
                 // check the programmed Feature_Row bits
                 if ( fb_programmed ) begin
                    `ifdef _VCP
                    $display("\t\t\t at", $time, "ns, recieve programmed FB bits %h from wishbone, expect %h", wb_dat_i[7:0], init_fb[7:0]);
                    `endif
                    init_fb <= { 8'd0, init_fr[15:8] };
                    if ( wb_dat_i[7:0] != init_fb[7:0] )
                       fb_prog_err <= 1'b1;
                 end
                 // check the default Feature_Row bits after erasing
                 else if ( fb_erased ) begin
                    `ifdef _VCP
                    $display("\t\t\t at", $time, "ns, recieve default FR bits %h from wishbone", wb_dat_i[7:0]);
                    `endif
                    //init_fb <= { wb_dat_i[7:0], init_fb[15:8] };
                 end
                 // save the initial Feature_Row bits
                 else begin
                    `ifdef _VCP
                    $display("\t\t\t at", $time, "ns, recieve init FR bits %h from wishbone", wb_dat_i[7:0]);
                    `endif
                    init_fb <= { wb_dat_i[7:0], init_fb[15:8] };
                 end
              end
          end
          else begin
              cmd_count <= 0;
              if ( fb_erased ) begin
                 if ( fb_update_en )
                    init_fb <= fb_update;
                 efb_state <= st_prog_fr;
              end
              else if ( fb_programmed ) begin
                 if ( fb_prog_err ) begin
                    err_cnt <= err_cnt + 1;
                    efb_state <= st_erase;
                 end
                 else
                    efb_state <= st_disable;
              end
              else
                 efb_state <= st_cmd;
          end
      end

      /* ############################################################################################## */
      // st_prog_fr - Issues the command sequence to program the Feature_Row data.
      /* ############################################################################################## */
      st_prog_fr : begin
          if (current_command < `PROGFR_CNT) begin
              {wb_we_o, wb_adr_o, wb_dat_o} <= progfr_cmd[current_command];
              
              cmd_count <= cmd_count + 1;
              wb_stb <= strobe;
          end
          else begin
              cmd_count <= 0;
              fr_erased <= 1'b0;
              fr_programmed <= 1'b1;
              fr_prog_err <= 1'b0;
              efb_state <= st_prog_fr_delay;
          end
      end

      /* ############################################################################################## */
      // st_prog_fr_delay - A nominal delay used in the status polling while the programming command is being
      //                  performed. An optional delay, the presence of this step reduces the number
      //                  of reads needed on the wishbone while the device is being erased.
      /* ############################################################################################## */
      st_prog_fr_delay : begin
          if (delay_count < `ERASE_DELAY_LOOP)
              delay_count <= delay_count + 1;
          else begin
              delay_count <= 0;
              efb_state <= st_prog_fr_chk_busy;
          end
      end

      /* ############################################################################################## */
      // st_prog_fr_chk_busy - Issues the command sequence to read the busy status during the programming
      //                     process. Continues once programming is complete, otherwise branches back to
      //                     the previous state for more delay before checking again.
      /* ############################################################################################## */
      st_prog_fr_chk_busy : begin
          if (current_command < `CHKBSY_CNT) begin
              {wb_we_o, wb_adr_o, wb_dat_o} <= busy_cmd[current_command];
              
              cmd_count <= cmd_count + 1;
              wb_stb <= strobe;
                    
              if (!wb_we_o && wb_ack_i) begin
                  busy <= wb_dat_i[7];
              end
          end
          else begin
              cmd_count <= 0;
              if (busy)
                  efb_state <= st_prog_fr_delay;
              else begin
                  fr_erased <= 1'b0;
                  fr_programmed <= 1'b1;
                  fr_prog_err <= 1'b0;
                  efb_state <= st_prog_fb;
              end
          end
      end

      /* ############################################################################################## */
      // st_prog_fb - Issues the command sequence to program the Feature_Row bits.
      /* ############################################################################################## */
      st_prog_fb : begin
          if (current_command < `PROGFB_CNT) begin
              {wb_we_o, wb_adr_o, wb_dat_o} <= progfb_cmd[current_command];
              
              cmd_count <= cmd_count + 1;
              wb_stb <= strobe;
          end
          else begin
              cmd_count <= 0;
              fb_erased <= 1'b0;
              fb_programmed <= 1'b1;
              fb_prog_err <= 1'b0;
              efb_state <= st_prog_fb_delay;
          end
      end

      /* ############################################################################################## */
      // st_prog_fb_delay - A nominal delay used in the status polling while the programming command is being
      //                  performed. An optional delay, the presence of this step reduces the number
      //                  of reads needed on the wishbone while the device is being erased.
      /* ############################################################################################## */
      st_prog_fb_delay : begin
          if (delay_count < `ERASE_DELAY_LOOP)
              delay_count <= delay_count + 1;
          else begin
              delay_count <= 0;
              efb_state <= st_prog_fb_chk_busy;
          end
      end

      /* ############################################################################################## */
      // st_prog_fb_chk_busy - Issues the command sequence to read the busy status during the programming
      //                     process. Continues once programming is complete, otherwise branches back to
      //                     the previous state for more delay before checking again.
      /* ############################################################################################## */
      st_prog_fb_chk_busy : begin
          if (current_command < `CHKBSY_CNT) begin
              {wb_we_o, wb_adr_o, wb_dat_o} <= busy_cmd[current_command];
              
              cmd_count <= cmd_count + 1;
              wb_stb <= strobe;
                    
              if (!wb_we_o && wb_ack_i) begin
                  busy <= wb_dat_i[7];
              end
          end
          else begin
              cmd_count <= 0;
              if (busy)
                  efb_state <= st_prog_fb_delay;
              else begin
                  fb_erased <= 1'b0;
                  fb_programmed <= 1'b1;
                  fb_prog_err <= 1'b0;
                  efb_state <= st_read_fr;
              end
          end
      end

                 
      /* ############################################################################################## */
      // st_disable - Issues the command sequence to exit Flash transfer
      /* ############################################################################################## */
      st_disable : begin
          if (current_command < `DISABLE_CNT) begin
              {wb_we_o, wb_adr_o, wb_dat_o} <= disable_cmd[current_command];
              cmd_count <= cmd_count + 1;
              wb_stb <= strobe;
          end
          else begin
              cmd_count <= 0;
              efb_state <= st_idle;
          end
      end

      default : efb_state <= st_idle;
    endcase
  end
end

always @ ( posedge clk or negedge rstn )
  if ( !rstn )
     fr_update_done <= 1'b0;
  else if ( fr_update_start )
     fr_update_done <= 1'b0;
  else if ( ( efb_state == st_disable ) && ( current_command == `DISABLE_CNT ) )
     fr_update_done <= 1'b1;

assign fr_update_pass = !fr_prog_err;

endmodule