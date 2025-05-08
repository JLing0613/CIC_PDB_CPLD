module State_Single_Ref_Logger#
(
	parameter bits = 1
)
(
    input   wire					iClk,
    input   wire					iRst_n,
	input	wire					iClear,
	input	wire					iEnable,

    input   wire	[bits-1 : 0]	iRef,
    input   wire	[bits-1 : 0]	iDbgSt,

    //output  reg		[bits-1 : 0]	prev_state,
    //output  reg		[bits-1 : 0]	current_state,

	output	reg	  	[bits-1 : 0]	ochange
);

always @ (posedge iClk or negedge iRst_n or negedge iClear) begin
	if(!iRst_n || !iClear) begin
		//current_state	<= iDbgSt;
		//prev_state		<= {bits{1'h0}};
		ochange			<= {bits{1'h0}};
	end
	else if(iDbgSt != iRef && iEnable) begin
		//prev_state		<= current_state;
		//current_state	<= iDbgSt;
		ochange			<= iDbgSt ^ iRef;
	end
	else begin
		//prev_state		<= prev_state;
		//current_state	<= current_state;
		ochange			<= ochange;	
	end
end

endmodule