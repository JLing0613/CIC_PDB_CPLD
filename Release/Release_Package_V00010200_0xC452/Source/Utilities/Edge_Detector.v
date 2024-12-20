module Edge_Detector
(
    input   wire        iClk,
	input   wire        iClk_delay,
    input   wire        iRst_n,
    input   wire        iClear,
	input	wire [15:0]	iDelay_time,

	input   wire		pos_neg,		// Positive edge detect or Negative edge detect
	input	wire		both,
    input   wire		input_sig,

    output  wire		output_pulse_sig,
	output	wire		output_ext_pulse_sig,
    output  wire		output_constant_sig
);

wire 	wDLY_TIMEOUT;

reg 	rinput_sig_delay;

reg 	routput_ext_pulse_triggered;
reg 	routput_constant_triggered;

assign 	output_pulse_sig 		= 	(both) ? (input_sig & ~rinput_sig_delay) | (~input_sig & rinput_sig_delay) : (pos_neg) ? input_sig & ~rinput_sig_delay : ~input_sig & rinput_sig_delay;
assign	output_ext_pulse_sig	=	routput_ext_pulse_triggered;
assign 	output_constant_sig		= 	routput_constant_triggered;

always @ (posedge iClk_delay) begin
	rinput_sig_delay	<= input_sig;
end

always @ (posedge iClk or negedge iRst_n or posedge wDLY_TIMEOUT) begin
	if(!iRst_n || wDLY_TIMEOUT) begin
		routput_ext_pulse_triggered	<= 1'b0;
	end
	else if(output_pulse_sig) begin
		routput_ext_pulse_triggered	<= 1'b1;
	end
	else begin
		routput_ext_pulse_triggered	<= routput_ext_pulse_triggered;
	end
end

always @ (posedge iClk or negedge iRst_n or negedge iClear) begin
	if(!iRst_n || !iClear) begin
		routput_constant_triggered	<= 1'b0;
	end
	else if(output_pulse_sig) begin
		routput_constant_triggered	<= 1'b1;
	end
	else begin
		routput_constant_triggered	<= routput_constant_triggered;
	end
end

dly_timer#
(
	.pulse_constant		(1'b0)	//1'b0 = pulse, 1'b1 = constant
)
mIOEXP0_INT_N_dly_timer
(
	.clk_in				(iClk_delay),
	.iRst_n				(iRst_n),
	.iClear				(1'b1),
	.dly_timer_en		(routput_ext_pulse_triggered),
	.dly_timer_start	(1'b1),
	.dly_time			(iDelay_time),
	.dly_timeout		(wDLY_TIMEOUT)
);

endmodule