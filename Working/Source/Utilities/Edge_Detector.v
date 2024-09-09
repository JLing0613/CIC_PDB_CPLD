module Edge_Detector
(
    input     wire          iClk,
    input     wire          iRst_n,

	input	  wire			pos_neg,		// Positive edge detect or Negative edge detect
    input     wire		    input_sig,

    output    wire		    output_sig
);

reg input_sig_delay;

assign output_sig = (pos_neg) ? input_sig & ~input_sig_delay : ~input_sig & input_sig_delay;

always @ (posedge iClk)
	begin
		input_sig_delay	<= input_sig;
	end

endmodule
