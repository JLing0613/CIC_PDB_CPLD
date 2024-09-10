module Edge_Detector
(
    input     wire          iClk,
    input     wire          iRst_n,

	input	  wire			pos_neg,		// Positive edge detect or Negative edge detect
    input     wire		    input_sig,

    output    wire		    output_pulse_sig,
    output    wire		    output_constant_sig
);

reg rchange;
reg rprev_state;
reg rcurr_state;
reg rinput_sig_delay;

assign output_pulse_sig = (pos_neg) ? input_sig & ~rinput_sig_delay : ~input_sig & rinput_sig_delay;
assign output_constant_sig  = prev_state;

always @ (posedge iClk)
	begin
		rinput_sig_delay	<= input_sig;
	end

always @ (posedge iClk)
    begin
		if(!iRst_n || iClear)
		begin
			rcurr_state	<= input_sig;
			rprev_state	<= 1'b0;
            rchange     <= 1'b0;
		end
		else if(input_sig != rcurr_state)
		begin
			rprev_state	<= rcurr_state;
			rcurr_state	<= input_sig;
            rchange     <= 1'b1;
		end
		else
		begin
			rprev_state	<= rprev_state;
			rcurr_state	<= rcurr_state;
		end
	end

endmodule
