`timescale 1 ns/1 ns
module I2C_Control#(parameter i2c_slave_addr = 7'h0f)
(
    input  wire  iClk,
    input  wire  iClk_1ms,
    input  wire  iRst_n,

    input  wire  SMB_CPLD_LOG_SCL,
    inout  wire  SMB_CPLD_LOG_SDA,

    input  wire  [7:0]  iI0,
    input  wire  [7:0]  iI1,

    output wire  INT_N,
    output wire  [15:0] output_data,
    output wire  [3:0] IOEXP_CTL_prev0,
    output wire  [3:0] IOEXP_CTL_prev1,
    output wire  [3:0] IOEXP_CTL_curr

);

wire         nrst;
reg  [7:0]   internal_rst_cnt = 8'h00;  
wire         i2c_wren;
wire         i2c_rden;
wire         i2c_start;
wire         i2c_stop;
wire [7:0]  i2c_offset;
wire [7:0]  i2c_dat_o;
wire [7:0]  i2c_dat_i;

wire [7:0]  wire_I0 ;
wire [7:0]  wire_I1 ;
reg  [7:0]  reg_C0 ;
reg  [7:0]  reg_C1 ;
wire [7:0]  reg_O0 ;
wire [7:0]  reg_O1 ;
reg  [7:0]  reg_Output0 ;
reg  [7:0]  reg_Output1 ;


wire [15:0] IOEXP_INT_prev;
wire [15:0] IOEXP_INT_curr;
wire P0_read_prev;
wire P0_read_curr;
wire P1_read_prev;
wire P1_read_curr;
wire [7:0]  lock_wire_I0;
wire [7:0]  lock_wire_I1;
reg  rchange_0;
reg  rchange_1;
wire wP0_read;
wire wP1_read;
wire wINT_Clear;
wire wINT_Clear_Delay;

localparam	dly_0ms				= 16'd0;		// 1ms x 0    	= 0ms
localparam	dly_1ms				= 16'd1;		// 1ms x 1    	= 1ms

assign nrst = internal_rst_cnt[7] ;
//-------------------------------nrst-------------------------------------------
always @(posedge iClk)
begin
if (internal_rst_cnt < 8'hff)
internal_rst_cnt <= internal_rst_cnt + 1'b1 ;
else
internal_rst_cnt <= internal_rst_cnt;
end 
 
I2C_Slave i2c_slave_SYS
(

  .CLK_IN               (iClk),
  .RESET_N              (nrst),
  .I2C_SLAVE_ADDR       (i2c_slave_addr),
  .SDA                  (SMB_CPLD_LOG_SDA),
  .SCL                  (SMB_CPLD_LOG_SCL),
  .OFFSET               (i2c_offset),
  .DATA_OUT             (i2c_dat_o),
  .DATA_IN              (i2c_dat_i),
  .WRITE_EN             (i2c_wren),
  .READ_EN              (i2c_rden),
  .START                (i2c_start),
  .STOP                 (i2c_stop)
);

always @(posedge iClk or negedge nrst)
    begin
        if (!nrst)
            begin
                reg_Output0 <= 8'hFF ;
                reg_Output1 <= 8'hFF ;
                reg_C0 <= 8'hFF ;
                reg_C1 <= 8'hFF ;
            end
        else if (i2c_wren)
            begin
            case (i2c_offset)
                8'h02 : reg_Output0  <= i2c_dat_o;
                8'h03 : reg_Output1  <= i2c_dat_o;
                8'h06 : reg_C0  <= i2c_dat_o;
                8'h07 : reg_C1  <= i2c_dat_o;
            default :
                begin		   
                    reg_Output0  <= reg_Output0;
                    reg_Output1  <= reg_Output1;
                    reg_C0    <= reg_C0;
                    reg_C1    <= reg_C1;
                end
            endcase
            end
    end

assign wire_I0 = iI0;
assign wire_I1 = iI1;

assign reg_O0[7] = (reg_C0[7]) ? iI0[7] :  reg_Output0[7];
assign reg_O0[6] = (reg_C0[6]) ? iI0[6] :  reg_Output0[6];
assign reg_O0[5] = (reg_C0[5]) ? iI0[5] :  reg_Output0[5];
assign reg_O0[4] = (reg_C0[4]) ? iI0[4] :  reg_Output0[4];
assign reg_O0[3] = (reg_C0[3]) ? iI0[3] :  reg_Output0[3];
assign reg_O0[2] = (reg_C0[2]) ? iI0[2] :  reg_Output0[2];
assign reg_O0[1] = (reg_C0[1]) ? iI0[1] :  reg_Output0[1];
assign reg_O0[0] = (reg_C0[0]) ? iI0[0] :  reg_Output0[0];

assign reg_O1[7] = (reg_C1[7]) ? iI1[7] :  reg_Output1[7];
assign reg_O1[6] = (reg_C1[6]) ? iI1[6] :  reg_Output1[6];
assign reg_O1[5] = (reg_C1[5]) ? iI1[5] :  reg_Output1[5];
assign reg_O1[4] = (reg_C1[4]) ? iI1[4] :  reg_Output1[4];
assign reg_O1[3] = (reg_C1[3]) ? iI1[3] :  reg_Output1[3];
assign reg_O1[2] = (reg_C1[2]) ? iI1[2] :  reg_Output1[2];
assign reg_O1[1] = (reg_C1[1]) ? iI1[1] :  reg_Output1[1];
assign reg_O1[0] = (reg_C1[0]) ? iI1[0] :  reg_Output1[0];

assign i2c_dat_i   =  (i2c_offset == 8'hff) ? 8'hff    :
                      (i2c_offset == 8'h00) ? lock_wire_I0  :
                      (i2c_offset == 8'h01) ? lock_wire_I1  :
                      (i2c_offset == 8'h02) ? reg_O0   :
                      (i2c_offset == 8'h03) ? reg_O1   :
                      (i2c_offset == 8'h04) ? 8'h00    :
                      (i2c_offset == 8'h05) ? 8'h00    :
                      (i2c_offset == 8'h06) ? reg_C0   :
                      (i2c_offset == 8'h07) ? reg_C1   :  8'hff;	

assign output_data  = {reg_O0,reg_O1};

assign wP0_read     = (!INT_N && i2c_offset == 8'h00) ? 1 : 0;
assign wP1_read     = (!INT_N && i2c_offset == 8'h01) ? 1 : 0;
assign wINT_Clear   = ((P0_read_prev ^ P0_read_curr) && (P1_read_prev ^ P1_read_curr)) ? 1 : 0;     //Offset check method to clear INT_N
//assign wINT_Clear   = (!INT_N) ? 1 : 0;   //Delay method to clear INT_N
assign INT_N        = (IOEXP_INT_prev != 16'h0 && IOEXP_INT_curr != IOEXP_INT_prev) ? 0 : 1;
assign OFFSET       = i2c_offset;
assign lock_wire_I0 = (INT_N) ? wire_I0 : IOEXP_INT_prev[15:8];
assign lock_wire_I1 = (INT_N) ? wire_I1 : IOEXP_INT_prev[7:0];

State_Logger_16bit IOEXP_INT_N
(
	.iClk			    (iClk),
	.iRst_n			    (iRst_n),
    .iClear             (wINT_Clear_Delay),
	
    .iDbgSt				({wire_I0,wire_I1}),

	.prev_state 		(IOEXP_INT_prev),
	.current_state		(IOEXP_INT_curr)
);

State_Logger_1bit P0_read_ready
(
	.iClk			    (iClk),
	.iRst_n			    (iRst_n),
    .iClear             (INT_N),
	
    .iDbgSt				(wP0_read),

	.prev_state 		(P0_read_prev),
	.current_state		(P0_read_curr)
);

State_Logger_1bit P1_read_ready
(
	.iClk			    (iClk),
	.iRst_n			    (iRst_n),
    .iClear             (INT_N),
	
    .iDbgSt				(wP1_read),

	.prev_state 		(P1_read_prev),
	.current_state		(P1_read_curr)
);

dly_timer mdly_timer
(
	.clk_in			(iClk_1ms),
	.iRst_n			(iRst_n),
	.dly_timer_en	(wINT_Clear),
	.dly_time		(dly_0ms),
	.dly_timeout	(wINT_Clear_Delay)
);

endmodule