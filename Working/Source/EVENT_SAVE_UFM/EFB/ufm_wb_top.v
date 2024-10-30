`timescale 1ns / 100ps
`include "efb_define_def.v"

module ufm_wb_top(
				  input clk_i
				, input ext_rstn
				, input[2:0] cmd
				, input[10:0] ufm_page
				, input GO
				, output reg BUSY
				, output reg ERR
				
				/***************** DPRAM port B signals *************/
				, input mem_clk
				, input mem_we
				, input mem_ce
				, input[3:0] mem_addr
				, input[7:0] mem_wr_data
				, output [7:0] mem_rd_data
				
				/***************** feature_row_update *************/	
				//, input  wire  DIP				
				, input  wire [2:0] i2c_cs
				//, output wire  update_done
				//, output wire  update_pass
				//FWUpdate

				,output i2c1_irqo
				,inout i2c1_scl
				,inout i2c1_sda
);



parameter READ_DELAY = 8;
//*****************
wire ufm_enable_cmd;
wire ufm_read_cmd;
wire ufm_write_cmd;
wire ufm_erase_cmd;
wire ufm_disable_cmd;
reg ufm_enabled;
reg n_ufm_enabled;
wire ufm_repeated_read;
wire ufm_repeated_write;

reg  [7:0] wb_dat_i ;
reg        wb_stb_i ;
wire       wb_cyc_i =  wb_stb_i ;
wire       rstn;
reg  [7:0] wb_adr_i ;
reg        wb_we_i  ;
// wire [7:0] wb_dat_o ;
// wire       wb_ack_o ;

reg [7:0] wb_dat_o ;
reg       wb_ack_o ;

reg  [7:0] n_wb_dat_i ;
reg        n_wb_stb_i ;
reg  [7:0] n_wb_adr_i ;
reg        n_wb_we_i  ;
reg n_busy;
reg n_error;
reg [7:0]   c_state ,n_state;
reg efb_flag,n_efb_flag;
reg[7:0] sm_wr_data;
reg[3:0] sm_addr;
reg sm_ce;
reg sm_we;
reg[4:0] count;
reg sm_addr_MSB;
wire[7:0] sm_rd_data;


reg[7:0] n_data_frm_ufm;
reg[3:0] n_addr_ufm;
reg n_clk_en_ufm;
reg n_wr_en_ufm;
reg[4:0] n_count;
reg n_ufm_addr_MSB;

/***************** feature_row_update *************/	
    parameter    Div  = 4'b1111; // �頻Even)
    parameter    Div2 = 4'b1010;  // Div/2
    parameter    DivW = 16;          // Divide寬度
	
    reg     rCLK_Out;
    reg     [DivW-1:0] CLK_Cnt = 0;
	

   reg  [11:0] reset_count;
   reg         reset_sync_1;
   reg         reset_sync_2;
   reg         reset_sync;
   reg         reset_det = 0;
   reg         release_reset_sync;
   reg         CLK_Out; 
   reg  [19:0] update_count;
   reg         update_start;
   
   wire        rst_n;
   //wire        clk_i;
   
  // wire  [7:0] i2c_slave_address;
   
   ////////////////// feature_row_update//////////////////
//   wire        wb_cyc_fr;
//   wire        wb_stb_fr;
//   wire        wb_we_fr; 
//   wire  [7:0] wb_adr_fr; 
//   reg  [7:0] wb_dat_rd_fr;
//   wire  [7:0] wb_dat_wr_fr;
//   //wire       wb_ack_n_fr;
//    reg       wb_ack_n_fr;
   //////////////////////////////////////////////////////
   
   
   ///////////////////////////////////////////////  
   reg          wb_cyc_n;
   reg          wb_stb_n;
   reg          wb_we_n;
   reg   [7:0]  wb_adr_n;          
   reg   [7:0]  wb_dat_i_n;
   wire   [7:0] wb_dat_o_n;  
   wire         wb_ack_n;


//    fr_ctrl UUT (  
//      .rstn             (rstn),
//      .clk               (clk_i),                        
//      .fr_update_start   (update_start),
//      .fr_update_done    (update_done),
//      .fr_update_pass    (update_pass),     
//      .i2c_slave_address (i2c_slave_address),     
//      .fb_update_en      (1'b0),
//      .fb_update         (16'h0030),
//
//      .wb_cyc_o          (wb_cyc_fr),
//      .wb_stb_o          (wb_stb_fr),
//      .wb_we_o           (wb_we_fr), 
//      .wb_adr_o          (wb_adr_fr), 
//      .wb_dat_i          (wb_dat_rd_fr),
//      .wb_dat_o          (wb_dat_wr_fr),
//      .wb_ack_i          (wb_ack_n_fr)
//
//   ); 
   
 


EFB_UFM inst1 (	.wb_clk_i(clk_i ),					// EFB with UFM enabled
				.wb_rst_i(!ext_rstn ),
				.wb_cyc_i(wb_cyc_n ),
				.wb_stb_i(wb_stb_n ), 
				.wb_we_i(wb_we_n ),
				.wb_adr_i(wb_adr_n), 
				.wb_dat_i(wb_dat_i_n ), 
				.wb_dat_o(wb_dat_o_n ), 
				.wb_ack_o(wb_ack_n ),			
				/***************** feature_row_update *************/	
				.wbc_ufm_irq(),				
				.i2c1_irqo(i2c1_irqo),
				.i2c1_scl(i2c1_scl),
				.i2c1_sda(i2c1_sda)
				);
				
USR_MEM inst2 (	.DataInA(sm_wr_data ),					// True dual port RAM. Port A controlled by internal SM and port B controlled by user.
				.DataInB(mem_wr_data ), 
				.AddressA({sm_addr_MSB,sm_addr} ), 
				.AddressB({!sm_addr_MSB,mem_addr} ), 
				.ClockA(clk_i ), 
				.ClockB(mem_clk ), 
				.ClockEnA(sm_ce ), 
				.ClockEnB(mem_ce ), 
				.WrA(sm_we ), 
				.WrB(mem_we ), 
				.ResetA(!ext_rstn ), 
				.ResetB(!ext_rstn ), 
				.QA(sm_rd_data ), 
				.QB(mem_rd_data ));				
				

  
  assign ufm_enable_cmd = (cmd == 3'b100) ? 1'b1 : 1'b0 ;
  assign ufm_read_cmd = ((cmd == 3'b000) || (cmd == 3'b001)) ? 1'b1 : 1'b0 ;
  assign ufm_write_cmd = ((cmd == 3'b010) || (cmd == 3'b011)) ? 1'b1 : 1'b0 ;
  assign ufm_erase_cmd = (cmd == 3'b111) ? 1'b1 : 1'b0 ;
  assign ufm_disable_cmd = (cmd == 3'b101) ? 1'b1 : 1'b0 ;
  assign ufm_repeated_read = (cmd == 3'b001) ? 1'b1 : 1'b0 ;
  assign ufm_repeated_write = (cmd == 3'b011) ? 1'b1 : 1'b0 ;
  
 /***************** switch UFM and feature_row_update *************/
always @ (*)			
	begin
//        if (DIP)  // Enable feature_row_update
//		    begin
//                wb_cyc_n <= wb_cyc_fr;
//                wb_stb_n <= wb_stb_fr;
//                wb_we_n <= wb_we_fr;
//                wb_adr_n <= wb_adr_fr;          
//                wb_dat_i_n <= wb_dat_wr_fr;			
//				wb_dat_rd_fr <= wb_dat_o_n;
//				wb_ack_n_fr<= wb_ack_n; 
//			end	
// 		else  // Enable UFM
			begin
	            wb_cyc_n <= wb_cyc_i;
                wb_stb_n <= wb_stb_i;
                wb_we_n <= wb_we_i;
                wb_adr_n <= wb_adr_i;          
                wb_dat_i_n <= wb_dat_i;
				wb_dat_o <= wb_dat_o_n;
			    wb_ack_o <= wb_ack_n;

            end			
    end
 
 /******************************************************************/


always @ (posedge clk_i or negedge ext_rstn)			// generate clk enable and write enable signals for port A of the DPRAM
	begin
		if(!ext_rstn)
			begin
				sm_ce <= 1'b0;
				sm_we <= 1'b0;
			end
		else if (((c_state == `state58) && (n_state == `state59))  || ((c_state == `state51)))			
			begin
				sm_ce <= 1'b0;
				sm_we <= 1'b0;
			end
		else if ((n_state == `state58) || ((c_state == `state50) && (n_state == `state51)))		
			begin
				sm_ce <= 1'b1;
				if (ufm_read_cmd)
					sm_we <= 1'b1;
				else
					sm_we <= 1'b0;
			end
		else 
			begin
				sm_ce <= 1'b0;
				sm_we <= 1'b0;
			end
	end
	
	
always @ (posedge clk_i or negedge ext_rstn)
  begin 
    if(!ext_rstn)
      begin 
         wb_dat_i <= 8'h00;
         wb_stb_i <= 1'b0 ;
         wb_adr_i <= 8'h00;
         wb_we_i  <= 1'b0;   
      end   
    else 
      begin 
         wb_dat_i <=  n_wb_dat_i;
         wb_stb_i <=  #0.1 n_wb_stb_i;
         wb_adr_i <=  n_wb_adr_i;
         wb_we_i  <=  n_wb_we_i ;

       end 
  end 

 always @ (posedge clk_i or negedge ext_rstn)
  begin 
    if(!ext_rstn) begin 
      c_state  <= 10'h000;
      BUSY     <= 1'b1;
	  efb_flag <= 1'b0 ;
	  ERR	   <= 1'b0;
	  ufm_enabled <= 1'b0;
	  sm_wr_data <= 8'h00;
	  sm_addr <= 4'b0000;
	  count <= 4'hF;
	  sm_addr_MSB <= 1'b0;
    end  
    else begin  
      c_state  <= n_state   ;
      BUSY     <= n_busy;
	  efb_flag <= n_efb_flag;
	  ERR	   <= n_error;
	  ufm_enabled <= n_ufm_enabled;
	  sm_wr_data <= n_data_frm_ufm;
	  sm_addr <= n_addr_ufm;
	  count <= n_count;
	  sm_addr_MSB <= n_ufm_addr_MSB;
    end  
  end
 
 
  
  always @ (*)
  begin
	n_state = c_state;
	n_efb_flag   =  1'b0 ;
	n_busy  = BUSY;
	n_error = ERR;
	n_ufm_enabled = ufm_enabled;
	n_data_frm_ufm = sm_wr_data;
	n_addr_ufm = sm_addr;
	n_clk_en_ufm = sm_ce;
	n_wr_en_ufm = sm_we;
	n_count = count;
	n_ufm_addr_MSB = sm_addr_MSB;
	 n_wb_dat_i = 8'h00;
     n_wb_stb_i = 1'b0 ;
     n_wb_adr_i = 8'h00;
     n_wb_we_i  = 1'b0;
	 n_efb_flag   =  1'b0 ; 
	case (c_state)
	
		`state0 : begin
		   n_wb_dat_i =  8'h00;
           n_wb_adr_i =  8'h00;
		   n_efb_flag   =  1'b0 ;
           n_wb_we_i  =  1'b0;           
           n_wb_stb_i =  1'b0 ;
		   n_busy     =  1'b1;
		   n_error    =  1'b0;
		   n_ufm_enabled = 1'b0;
		   n_state    =  `state1;					// (state1 - state8)--check if UFM is busy and deassert BUSY flag if free.
		 end
		 
		 `state1: begin // enable WB-UFM interface
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_efb_flag   =  1'b0 ;
			  n_wb_stb_i = `LOW ;
			  n_state = `state2;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGCR;
		   n_wb_dat_i = 8'h80;
		   n_wb_stb_i = `HIGH ; 
		   n_efb_flag   =  1'b1 ;
		   n_state = c_state; 
			end
		 end
 
 
	  `state2: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
              n_state = `state3;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'hF0;
		   n_wb_stb_i = `HIGH ; 
		   n_efb_flag   =  1'b1 ;
		   n_state = c_state;	   
		end
		 end
	 
	 
	  `state3: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state4;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h00;
		   n_wb_stb_i = `HIGH ;
		   n_efb_flag   =  1'b1 ;		   
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state4: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state5;
			   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h00;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state5: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state6;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGTXDR;
		   n_efb_flag   =  1'b1 ;
		   n_wb_dat_i = 8'h00;
		   n_wb_stb_i = `HIGH ; 
		   n_efb_flag   =  1'b1 ;
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state6: begin // Return Back to State 2
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_efb_flag   =  1'b0 ;
			  n_wb_stb_i = `LOW ;
		   if(wb_dat_o & (8'h80) )
			   n_state = `state7;
		   else
			   n_state = `state8;
		   end
		   else begin
		   n_wb_we_i =  `READ_STATUS;
		   n_wb_adr_i = `CFGRXDR;
		   n_wb_dat_i = 8'h00;
		   n_wb_stb_i = `HIGH ;
		   n_efb_flag   =  1'b1 ;		   
		   n_state = c_state; 
		end
		 end
		 
	`state7: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state1;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGCR;
		   n_wb_dat_i = 8'h00;
		   n_wb_stb_i = `HIGH ;
		   n_busy     =  1'b1;		   
		   n_state = c_state; 
		end
		 end	 
		 
	  `state8: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			  n_busy     =  1'b0;
			   n_state = `state9;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGCR;
		   n_wb_dat_i = 8'h00;
		   n_wb_stb_i = `HIGH ;
		   n_busy     =  1'b1;		   
		   n_state = c_state; 
		end
		 end
	
	  `state9: begin
		  if (GO)
			begin
				n_busy     =  1'b1;
				n_error    =  1'b0;
				if (ufm_enabled && ufm_write_cmd)
					n_ufm_addr_MSB = !sm_addr_MSB;	
				n_state    =  `state10;
			end
		  else
			begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_busy     =  1'b0;
			  n_error    =  ERR;
			  n_state = c_state;
			end
		end
		
		
	 `state10: begin 	
		if(ufm_enable_cmd)					// enable UFM   
			n_state    =  `state11;
		else if (ufm_enabled)begin			// decode command only if UFM is already enabled
			if (ufm_read_cmd)
				n_state    =  `state35;
			else if (ufm_write_cmd)
				n_state    =  `state35;
			else if (ufm_erase_cmd)
				n_state    =  `state17;
			else if (ufm_disable_cmd)
				n_state    =  `state23;
		  end
		else begin							// set ERR if a command is sent when UFM is disabled and go to previous state and wait for GO
			n_busy     =  1'b0;
			n_error    =  1'b1;
			n_state    =  `state9;
		end
	 end	
		  
	  `state11: begin 							//  (state11 - state16) enable UFM	
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
		  n_efb_flag   =  1'b0 ;
          n_wb_stb_i = `LOW ;
           n_state = `state12;
       end
       else begin
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGCR;
	   n_efb_flag   =  1'b1 ;
       n_wb_dat_i = 8'h80;
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
 
 
	  `state12: begin // enable configuration
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state13;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h74;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state13: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state14;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h08;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state14: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state15;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h00;
		   n_efb_flag   =  1'b1 ;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state15: begin // 						
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state16;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h00;
		   n_wb_stb_i = `HIGH ;		   
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state16: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_efb_flag   =  1'b0 ;
			  n_wb_stb_i = `LOW ;
			  n_ufm_enabled = 1'b1;
			   n_state = `state1;				// check for busy flag after enabling UFM
		   end
		   else begin
			   n_efb_flag   =  1'b1 ;
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGCR ;
		   n_wb_dat_i = 8'h00;
		   n_busy     =  1'b1;
		   n_wb_stb_i = `HIGH ;
		   n_ufm_enabled = 1'b0;		   
		   n_state = c_state; 
		end
	  end 
	  
	  
	`state17: begin 							// (state17- state22) erase UFM
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
		  n_efb_flag   =  1'b0 ;
          n_wb_stb_i = `LOW ;
           n_state = `state18;
       end
       else begin
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGCR;
	   n_efb_flag   =  1'b1 ;
       n_wb_dat_i = 8'h80;
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
 
 
	  `state18: begin 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state19;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'hCB;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state19: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state20;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h00;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state20: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state21;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h00;
		   n_efb_flag   =  1'b1 ;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
 
	 
	  `state21: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state22;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h00;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
		 
			  `state22: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_efb_flag   =  1'b0 ;
			  n_wb_stb_i = `LOW ;
			   n_state = `state1;			// check for busy flag after erasing UFM
		   end
		   else begin
			   n_efb_flag   =  1'b1 ;
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGCR ;
		   n_wb_dat_i = 8'h00;
		   n_busy     =  1'b1;
		   n_wb_stb_i = `HIGH ;		   
		   n_state = c_state; 
		end
	  end 

	  
	  `state23: begin // open frame			// (state23 - state 32) disable UFM
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
		  n_efb_flag   =  1'b0 ;
          n_wb_stb_i = `LOW ;
           n_state = `state24;
       end
       else begin
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGCR;
	   n_efb_flag   =  1'b1 ;
       n_wb_dat_i = 8'h80;
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
 
 
	  `state24: begin // disable configuration
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state25;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h26;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state25: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state26;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h00;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state26: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state27;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h00;
		   n_efb_flag   =  1'b1 ;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state27: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state28;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h00;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
				  `state28: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_efb_flag   =  1'b0 ;
			  n_wb_stb_i = `LOW ;
			   n_state = `state29;
		   end
		   else begin
			   n_efb_flag   =  1'b1 ;
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGCR ;
		   n_wb_dat_i = 8'h00;
		   n_busy     =  1'b1;
		   n_wb_stb_i = `HIGH ;		   
		   n_state = c_state; 
		end
	  end  
	  
	  			  `state29: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_efb_flag   =  1'b0 ;
			  n_wb_stb_i = `LOW ;
			   n_state = `state30;
		   end
		   else begin
			   n_efb_flag   =  1'b1 ;
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGCR ;
		   n_wb_dat_i = 8'h80;
		   n_busy     =  1'b1;
		   n_wb_stb_i = `HIGH ;		   
		   n_state = c_state; 
		end
	  end 
	 `state30: begin 								//  bypass command
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state31;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'hFF;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state31: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state32;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'hFF;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state32: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state33;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'hFF;
		   n_efb_flag   =  1'b1 ;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state33: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag   =  1'b0 ;
			   n_state = `state34;
		   end
		   else begin
		   n_wb_we_i =  `WRITE;
		   n_efb_flag   =  1'b1 ;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'hFF;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
		 
		 
	  `state34: begin 								// 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_efb_flag   =  1'b0 ;
			  n_wb_stb_i = `LOW ;
			  n_busy     =  1'b0;
			  n_ufm_enabled = 1'b0;
			   n_state = `state9;
		   end
		   else begin
			   n_efb_flag   =  1'b1 ;
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGCR ;
		   n_wb_dat_i = 8'h00;
		   n_busy     =  1'b1;
		   n_wb_stb_i = `HIGH ;		   
		   n_state = c_state; 
		end
	  end
	 

	  `state35: begin // 						(state35 - state60 ) UFM read/write operations
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
          n_wb_stb_i = `LOW ;
          n_efb_flag = `LOW ;
		  if (ufm_repeated_read)
		   n_state = `state46;
		  else if (ufm_repeated_write)
           n_state = `state54;
		  else
		   n_state = `state36;
       end
       else begin
       n_efb_flag = `HIGH ;
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGCR;
       n_wb_dat_i = 8'h80;
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
 
 
  `state36: begin 								// Set UFM Page Address  
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
          n_wb_stb_i = `LOW ;
          n_efb_flag = `LOW ;
           n_state = `state37;
       end
       else begin
       n_efb_flag = `HIGH ;
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGTXDR;
       n_wb_dat_i = 8'hB4;
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
 
 
  `state37: begin // 
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
          n_wb_stb_i = `LOW ;
          n_efb_flag = `LOW ;
           n_state = `state38;
       end
       else begin
       n_efb_flag = `HIGH ;
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGTXDR;
       n_wb_dat_i = 8'h00;
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
 
 
  `state38: begin // 
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
          n_wb_stb_i = `LOW ;
          n_efb_flag = `LOW ;
           n_state = `state39;
       end
       else begin
       n_efb_flag = `HIGH ;
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGTXDR;
       n_wb_dat_i = 8'h00;
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
 
 
  `state39: begin // 
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
          n_wb_stb_i = `LOW ;
          n_efb_flag = `LOW ;
           n_state = `state40;
       end
       else begin
       n_efb_flag = `HIGH ;
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGTXDR;
       n_wb_dat_i = 8'h00;
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
 
 
  `state40: begin // 
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
          n_wb_stb_i = `LOW ;
          n_efb_flag = `LOW ;
           n_state = `state41;
       end
       else begin
       n_efb_flag = `HIGH ;
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGTXDR;
       n_wb_dat_i = 8'h40;
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
 
 
  `state41: begin // 
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
          n_wb_stb_i = `LOW ;
          n_efb_flag = `LOW ;
           n_state = `state42;
       end
       else begin
       n_efb_flag = `HIGH ;
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGTXDR;
       n_wb_dat_i = 8'h00;
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
 
 
  `state42: begin // 
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
          n_wb_stb_i = `LOW ;
          n_efb_flag = `LOW ;
           n_state = `state43;
       end
       else begin
       n_efb_flag = `HIGH ;
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGTXDR;
       n_wb_dat_i = {5'b00000,ufm_page[10:8]};
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
 
 
  `state43: begin // 
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
          n_wb_stb_i = `LOW ;
          n_efb_flag = `LOW ;
		n_state = `state44;
       end
       else begin
       n_efb_flag = `HIGH ;
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGTXDR;
       n_wb_dat_i = ufm_page[7:0];
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
  
	 `state44: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_efb_flag   =  1'b0 ;
			  n_wb_stb_i = `LOW ;
		  if (ufm_write_cmd)
           n_state = `state53;
		  else
		   n_state = `state45;
		   end
		   else begin
			   n_efb_flag   =  1'b1 ;
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGCR ;
		   n_wb_dat_i = 8'h00;
		   n_busy     =  1'b1;
		   n_wb_stb_i = `HIGH ;		   
		   n_state = c_state; 
		end
	  end 
  	  
 	`state45: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_efb_flag   =  1'b0 ;
			  n_wb_stb_i = `LOW ;
		   n_state = `state46;
		   end
		   else begin
			   n_efb_flag   =  1'b1 ;
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGCR ;
		   n_wb_dat_i = 8'h80;
		   n_busy     =  1'b1;
		   n_wb_stb_i = `HIGH ;		   
		   n_state = c_state; 
		end
	  end 	  
	  
 `state46: begin // Read Operation
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
          n_wb_stb_i = `LOW ;
          n_efb_flag = `LOW ;
		  n_count = READ_DELAY;
           n_state = `stateRD_delay;
       end
       else begin
       n_efb_flag = `HIGH ;
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGTXDR;
       n_wb_dat_i = 8'hCA;
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
 
  `stateRD_delay: begin
		 		if (count == 0)
					n_state = `state47;
				else begin
				    n_count = count - 1;
				    n_state = `stateRD_delay;
				end
   end
 
  `state47: begin // 
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
          n_wb_stb_i = `LOW ;
          n_efb_flag = `LOW ;
          n_state = `state48;
       end
       else begin
       n_efb_flag = `HIGH ;
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGTXDR;
       n_wb_dat_i = 8'h10;
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
 
 
  `state48: begin // 
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
          n_wb_stb_i = `LOW ;
          n_efb_flag = `LOW ;
           n_state = `state49;
       end
       else begin
       n_efb_flag = `HIGH ;
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGTXDR;
       n_wb_dat_i = 8'h00;
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end
 
 
  `state49: begin // 
      if (wb_ack_o && efb_flag) begin
          n_wb_dat_i = `ALL_ZERO ;
          n_wb_adr_i = `ALL_ZERO ;
          n_wb_we_i =  `LOW ;
          n_wb_stb_i = `LOW ;
          n_efb_flag = `LOW ;
		  n_count = 5'b10000;
		  n_addr_ufm = 4'h0;
		  n_clk_en_ufm = 1'b1;
           n_state = `state50;
       end
       else begin
       n_efb_flag = `HIGH ;
       n_wb_we_i =  `WRITE;
       n_wb_adr_i = `CFGTXDR;
       n_wb_dat_i = 8'h01;
       n_wb_stb_i = `HIGH ; 
       n_state = c_state; 
    end
     end


	 `state51: begin // 
		  n_wb_dat_i = `ALL_ZERO ;
		  n_wb_adr_i = `ALL_ZERO ;
		  n_wb_we_i =  `LOW ;
		  n_wb_stb_i = `LOW ;
		  n_efb_flag = `LOW ;
		 n_addr_ufm = sm_addr + 1;
		 		if (count == 0)
					n_state = `state52;
				  else begin
				    n_state = `state50;
				   end
		end
		   
	 `state50: begin // 
			  if (wb_ack_o && efb_flag) begin
				  n_wb_dat_i = `ALL_ZERO ;
				  n_wb_adr_i = `ALL_ZERO ;
				  n_wb_we_i =  `LOW ;
				  n_wb_stb_i = `LOW ;
				  n_efb_flag = `LOW ;
				  n_count = count - 1;
				  n_data_frm_ufm = wb_dat_o;
				   n_state = `state51;
			 end
			 else begin
			   n_efb_flag = `HIGH ;
			   n_wb_we_i =  `READ_DATA;
			   n_wb_adr_i = `CFGRXDR;
			   n_wb_dat_i = 8'h00;
			   n_wb_stb_i = `HIGH ;
			   n_state = c_state; 
			end
	    end		 

	`state52: begin // 
			  if (wb_ack_o && efb_flag) begin
				  n_wb_dat_i = `ALL_ZERO ;
				  n_wb_adr_i = `ALL_ZERO ;
				  n_wb_we_i =  `LOW ;
				  n_wb_stb_i = `LOW ;
				  n_efb_flag   =  1'b0 ;
				  n_ufm_addr_MSB = !sm_addr_MSB;
				  n_busy     =  1'b0;
				   n_state = `state9;
			   end
			   else begin
			   n_wb_we_i =  `WRITE;
			   n_efb_flag   =  1'b1 ;
			   n_wb_adr_i = `CFGCR;
			   n_wb_dat_i = 8'h00;
			   n_wb_stb_i = `HIGH ;
			   n_busy     =  1'b1;		   
			   n_state = c_state; 
			end
			 end	
			 
   	 `state53: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_efb_flag   =  1'b0 ;
			  n_wb_stb_i = `LOW ;
		   n_state = `state54;
		   end
		   else begin
			   n_efb_flag   =  1'b1 ;
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGCR ;
		   n_wb_dat_i = 8'h80;
		   n_busy     =  1'b1;
		   n_wb_stb_i = `HIGH ;		   
		   n_state = c_state; 
		end
	  end
	`state54: begin // Write Operation
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag = `LOW ;
     		   n_state = `state55;
		   end
		   else begin
		   n_efb_flag = `HIGH ;
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'hC9;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state55: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag = `LOW ;
			   n_state = `state56;
		   end
		   else begin
		   n_efb_flag = `HIGH ;
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h00;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state56: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag = `LOW ;
			   n_state = `state57;
		   end
		   else begin
		   n_efb_flag = `HIGH ;
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h00;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state57: begin // 
		  if (wb_ack_o && efb_flag) begin
			  n_wb_dat_i = `ALL_ZERO ;
			  n_wb_adr_i = `ALL_ZERO ;
			  n_wb_we_i =  `LOW ;
			  n_wb_stb_i = `LOW ;
			  n_efb_flag = `LOW ;
			  n_count = 5'b10000;
			  n_addr_ufm = 4'h0;
			  n_clk_en_ufm = 1'b1;
			  n_wr_en_ufm = 1'b0;
			   n_state = `state58;
		   end
		   else begin
		   n_efb_flag = `HIGH ;
		   n_wb_we_i =  `WRITE;
		   n_wb_adr_i = `CFGTXDR;
		   n_wb_dat_i = 8'h01;
		   n_wb_stb_i = `HIGH ; 
		   n_state = c_state; 
		end
		 end
	 
	 
	  `state58: begin // 
		  n_wb_dat_i = `ALL_ZERO ;
		  n_wb_adr_i = `ALL_ZERO ;
		  n_wb_we_i =  `LOW ;
		  n_wb_stb_i = `LOW ;
		  n_efb_flag = `LOW ;
		 n_count = count - 1;
		 n_state = `state59;
		end
		   
	 `state59: begin // 
			  if (wb_ack_o && efb_flag) begin
				  n_wb_dat_i = `ALL_ZERO ;
				  n_wb_adr_i = `ALL_ZERO ;
				  n_wb_we_i =  `LOW ;
				  n_wb_stb_i = `LOW ;
				  n_efb_flag = `LOW ;
				  n_addr_ufm = sm_addr + 1;
				  if (count == 0)
					n_state = `state60;					
				  else begin
				    n_state = `state58;
				   end
			 end
			 else begin
			   n_efb_flag = `HIGH ;
			   n_wb_we_i =  `WRITE;
			   n_wb_adr_i = `CFGTXDR;
			   n_wb_dat_i = sm_rd_data;
			   n_wb_stb_i = `HIGH ;
			   n_state = c_state; 
			end
	    end	
	
	`state60: begin // 
			  if (wb_ack_o && efb_flag) begin
				  n_wb_dat_i = `ALL_ZERO ;
				  n_wb_adr_i = `ALL_ZERO ;
				  n_wb_we_i =  `LOW ;
				  n_efb_flag   =  1'b0 ;
				  n_wb_stb_i = `LOW ;
				n_state = `state1;
			   end
			   else begin
				   n_efb_flag   =  1'b1 ;
				   n_wb_we_i =  `WRITE;
				   n_wb_adr_i = `CFGCR ;
				   n_wb_dat_i = 8'h00;
				   n_busy     =  1'b1;
				   n_wb_stb_i = `HIGH ;		   
				   n_state = c_state; 
			end
		  end	
  endcase
 end
 
 
 
//--------------------------------------------------------------------
// -- feature_row_update 20210316
//--------------------------------------------------------------------


 // -- Oscillator
// -------------------------------------------------------------------
always @( posedge clk_i, negedge ext_rstn ) begin
        if( !ext_rstn )
            CLK_Cnt <= 0;
        else if( CLK_Cnt == Div-1 )
            CLK_Cnt <= 0;
        else
            CLK_Cnt <= CLK_Cnt + 1'b1;
    end
    always @( posedge clk_i or negedge ext_rstn ) begin
        if( !ext_rstn )
            CLK_Out <= 0;
        else if( CLK_Cnt <= Div2-1 )
            CLK_Out <= 0;
        else
            CLK_Out <= 1'b1;
    end
 
 
//--------------------------------------------------------------------
// -- internal reset
//--------------------------------------------------------------------

   always @ ( posedge clk_i or negedge release_reset_sync )
      if ( release_reset_sync !== 1'b1 ) begin
         reset_sync_1 <= 1'b1;
         reset_sync_2 <= 1'b1;
         reset_sync <= 1'b1;
      end else begin
         reset_sync_1 <= 1'b0;
         reset_sync_2 <= reset_sync_1;
         reset_sync <= reset_sync_2;
      end
   
   assign rstn = ~reset_sync && ext_rstn;
   
   always @ ( posedge clk_i )
      if ( !rstn )
         reset_det <= 1'b1;
   
   always @ ( posedge clk_i )
      if ( reset_count[11] !== 1'b0 )
         reset_count <= reset_det ? 12'h800 : 0;
      else
         reset_count <= reset_count + 1;
   
   always @ ( posedge clk_i )
      if ( reset_count[11] !== 1'b0 )
         release_reset_sync <= reset_det;
      else if ( !release_reset_sync && !rstn )
         release_reset_sync <= reset_count[10];

//--------------------------------------------------------------------
// -- update start
//--------------------------------------------------------------------

   always @ ( posedge clk_i or negedge rstn )
      if ( !rstn )
         update_count <= 20'd0;
      //else if ( update_done )
         //update_count <= 20'hFFFFF;
      else if ( update_count == 20'hFFFFF )
         update_count <= 20'hFFFFF;
      else
         update_count <= update_count + 1;
      
   always @ ( posedge clk_i or negedge rstn )
      if ( !rstn )
         update_start <= 1'b0;
      else if ( |update_count[19:5] )
         update_start <= 1'b0;
      else if ( !update_count[4] )
         update_start <= 1'b0;
      else
         update_start <= 1'b1;

//--------------------------------------------------------------------
// -- Feature_Row controlling
//--------------------------------------------------------------------

   //assign i2c_slave_address = { {(5){1'b0}}, i2c_cs };
 
 
endmodule  
		
		  
		  