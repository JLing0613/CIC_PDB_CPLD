// -------------------------------------------------------------------
// Copyright (c) 2022 by WEIKENG INDUSTRIAL CO., LTD. 
// -------------------------------------------------------------------
//
// 11F, 308, Sec.1, NeiHu Rd., Taipei 11493, Taiwan
// TEL : +886-2-2658-0959
// WEB : http://www.weikeng.com.tw
//
// -------------------------------------------------------------------
//
// File :
//     SMBusControl.v
// Description :
//     SMBusControl Module
//
// -------------------------------------------------------------------
// Code Revision History:
// -------------------------------------------------------------------
// Version | Author         | Modify Date | Changes Made
// V0.0    | Vincent Lee    | 2022/01/11  | Initial Version
// -------------------------------------------------------------------
// CPLD/FPGA Vender : Lattice
// Part Number      : LCMXO3LF-2100C-5BG324C
// -------------------------------------------------------------------


`timescale 1 ns/100 ps

module SMBusControl
(
  input         CLK_IN,    // CLPD Global Clock
  input        	RESET_N,   // CPLD Global Reset Active Low
  input  		[  6:0] I2C_ADR_I, // I2C Address 7 bits
  inout         SDA,       // I2C Serial Data
  input         SCL,       // I2C Serial Clock
  output 		[  7:0] I2C_CMD_O, // Local Command Output
  output 		[  7:0] I2C_DAT_O, // Local Data Output
  input  		[  7:0] I2C_DAT_I, // Local Data Input
  output        I2C_WREN,  // Local Write Enable
  output        I2C_RDEN   // Local Read Enable
);

  parameter TP = 1;            // Timescale 1 ns delay for RTL Simulation
  parameter sm_idle    = 4'h0, // State Machine
            sm_pre_adr = 4'h1,
            sm_adr     = 4'h2,
            sm_adr_ack = 4'h3,
            sm_cmd     = 4'h4,
            sm_cmd_ack = 4'h5,
            sm_dat     = 4'h6,
            sm_dat_ack = 4'h7,
            sm_stop    = 4'h8;


  wire        clk,nrst;
  wire        i2c_start,i2c_stop;
  wire        clr_bit_cnt,bit_cnt_en,bit_cnt_zero;
  wire        latch_adr_en,latch_cmd_en,latch_dat_en,latch_read_ack,cmd_plus;
  wire        i2c_rw_flag,i2c_rnw;
  reg         load_rd_dat_q;
  wire        load_rd_dat_d;  
  wire        shift_reg_en,i2c_ack_bit,i2c_adr_match;
  wire        scl_pos,scl_neg;
  reg         i2c_ack_q;
  wire        i2c_ack_d;
  reg         sda_en_q;
  wire        sda_en_d;  
  reg [ 2:0]  sda_pipe,scl_pipe;
  reg [ 3:0]  csm,nsm;
  reg [ 3:0]  bit_cnt_q;
  wire [ 3:0] bit_cnt_d;
  reg [ 7:0]  adr_reg_q,cmd_reg_q,dat_reg_q;
  reg [ 7:0]  rdat_shift_reg_q;
  wire [ 7:0] rdat_shift_reg_d;  



  assign clk  = CLK_IN;
  assign nrst = RESET_N;



  // DFF //
  always @(posedge clk or negedge nrst)
    begin
      if (!nrst) begin
          sda_pipe         <= # TP 3'b111;
          scl_pipe         <= # TP 3'b111;
          csm              <= # TP sm_idle;
          bit_cnt_q        <= # TP 4'h7;
          i2c_ack_q        <= # TP 1'b0;
          load_rd_dat_q    <= # TP 1'b0;
          rdat_shift_reg_q <= # TP 8'h0;
          sda_en_q         <= # TP 1'b1;
        end
      else begin
          sda_pipe         <= # TP {sda_pipe[1:0],SDA};
          scl_pipe         <= # TP {scl_pipe[1:0],SCL};
          csm              <= # TP nsm;
          bit_cnt_q        <= # TP bit_cnt_d;
          i2c_ack_q        <= # TP i2c_ack_d;
          load_rd_dat_q    <= # TP load_rd_dat_d;
          rdat_shift_reg_q <= # TP rdat_shift_reg_d;
          sda_en_q         <= # TP sda_en_d;
        end
    end

  always @(posedge clk or negedge nrst) begin
      if (!nrst) begin
          adr_reg_q <= 8'h0;
          cmd_reg_q <= 8'h0;
          dat_reg_q <= 8'h0;
        end
      else begin
          if (latch_adr_en) begin
              adr_reg_q[bit_cnt_q] <= sda_pipe[2];
            end
          if (latch_cmd_en) begin
              cmd_reg_q[bit_cnt_q] <= sda_pipe[2];
            end
          else if (cmd_plus) begin
              cmd_reg_q <= cmd_reg_q + 1'b1;
            end
          if (latch_dat_en) begin
              dat_reg_q[bit_cnt_q] <= sda_pipe[2];
            end
        end
    end


  // State Machine //
  always @(*)
    begin
      case (csm)
        sm_idle     : nsm = i2c_start           ? sm_pre_adr : sm_idle;
		
        sm_pre_adr  : nsm = i2c_stop            ? sm_idle    :
                            scl_neg             ? sm_adr     : sm_pre_adr;
							
        sm_adr      : nsm = i2c_stop            ? sm_idle    :
                            bit_cnt_zero        ? sm_adr_ack : sm_adr;
							
        sm_adr_ack  : nsm = i2c_stop            ? sm_idle    :
                            scl_neg             ?
                            i2c_adr_match       ?
                            i2c_rnw             ? sm_dat     : sm_cmd
                                                             : sm_stop
                                                             : sm_adr_ack;
															 
        sm_cmd      : nsm = i2c_stop            ? sm_idle    :
                            bit_cnt_zero        ? sm_cmd_ack : sm_cmd;
							
        sm_cmd_ack  : nsm = i2c_stop            ? sm_idle    :
                            scl_neg             ? sm_dat     : sm_cmd_ack;
							
        sm_dat      : nsm = i2c_stop            ? sm_idle    :
                            i2c_start           ? sm_pre_adr :
                            bit_cnt_zero        ? sm_dat_ack : sm_dat;
							
        sm_dat_ack  : nsm = i2c_stop            ? sm_idle    :
                            scl_neg             ?
                            i2c_rnw & i2c_ack_q ? sm_stop    : sm_dat
                                                             : sm_dat_ack;
															 
        sm_stop     : nsm = i2c_stop            ? sm_idle    : sm_stop;
		
        default     : nsm = sm_idle;
      endcase
    end


  // SCL Rising,Falling edge //
  assign scl_neg = (scl_pipe[2:1] == 2'b10);
  assign scl_pos = (scl_pipe[2:1] == 2'b01);


  // I2C START,STOP detect //
  assign i2c_start = ((sda_pipe[2:1] == 2'b10) && (scl_pipe[2:1] == 2'b11));
  assign i2c_stop  = ((sda_pipe[2:1] == 2'b01) && (scl_pipe[2:1] == 2'b11));


  // I2C bit counter //
  assign clr_bit_cnt  = i2c_start || (csm == sm_adr_ack) || (csm == sm_cmd_ack) || (csm == sm_dat_ack);

  assign bit_cnt_en   = ((csm == sm_adr) || (csm == sm_cmd) || (csm == sm_dat)) && scl_neg;

  assign bit_cnt_d    = clr_bit_cnt ? 4'h7             :
                        bit_cnt_en  ? bit_cnt_q - 1'b1 : bit_cnt_q;

  assign bit_cnt_zero = (bit_cnt_q == 4'hf);


  // Latch I2C address //
  assign latch_adr_en = (csm == sm_adr) && scl_neg;

  assign i2c_adr_match = (adr_reg_q[7:1] == I2C_ADR_I);

  assign i2c_rnw = adr_reg_q[0];


  // Latch I2C command //
  assign latch_cmd_en = (csm == sm_cmd) && scl_neg && i2c_adr_match;

  // I2C command plus //
  assign cmd_plus = (csm == sm_dat_ack) && scl_neg && i2c_adr_match;

  // Latch I2C data //
  assign latch_dat_en = (csm == sm_dat) && scl_neg && !i2c_rnw && i2c_adr_match;


  // Write and Read access //
  assign i2c_rw_flag = (csm == sm_dat_ack) && scl_pos && i2c_adr_match;


  // I2C read ack //
  assign latch_read_ack = (csm == sm_dat_ack) && i2c_rnw && scl_pos && i2c_adr_match;


  assign i2c_ack_d = latch_read_ack ? sda_pipe[2] : i2c_ack_q;


  // Read data shift register //
  assign load_rd_dat_d = ((csm == sm_adr_ack) || (csm == sm_dat_ack)) && i2c_rnw && scl_neg && i2c_adr_match;


  assign shift_reg_en = (csm == sm_dat) && i2c_rnw && scl_neg && i2c_adr_match;


  assign rdat_shift_reg_d = load_rd_dat_q ? I2C_DAT_I                    :
                            shift_reg_en  ? {rdat_shift_reg_q[6:0],1'b1} : rdat_shift_reg_q;


  assign i2c_ack_bit = ((csm == sm_adr_ack) || (csm == sm_cmd_ack) || ((csm == sm_dat_ack) && !i2c_rnw)) & i2c_adr_match;


  assign sda_en_d = i2c_ack_bit                  ? 1'b0                :
                    ((csm == sm_dat) && i2c_rnw) ? rdat_shift_reg_q[7] : 1'b1;




  assign I2C_CMD_O = cmd_reg_q;

  assign I2C_DAT_O = dat_reg_q;

  assign I2C_WREN = i2c_rw_flag && !i2c_rnw;

  assign I2C_RDEN = i2c_rw_flag &&  i2c_rnw;

  assign SDA = (sda_en_q) ? 1'bz : 1'b0;

//  assign SCL = 1'bz;


endmodule