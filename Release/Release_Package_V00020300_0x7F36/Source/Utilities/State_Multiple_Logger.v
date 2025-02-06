module State_Multiple_Logger#
(
	parameter bits = 1
)
(
    input   wire				iClk,
    input   wire				iRst_n,
	input	wire				iClear,
	input	wire				iEnable,

    input   wire [bits-1 : 0]   iDbgSt,

    output  reg  [bits-1 : 0]	prev_state,
    output  reg  [bits-1 : 0]	prev_state_1,
    output  reg  [bits-1 : 0]	prev_state_2,
    output  reg  [bits-1 : 0]	current_state,	
	output	reg					ochange
);

always @ (posedge iClk or negedge iRst_n or negedge iClear) begin
	if(!iRst_n || !iClear) begin
		current_state	<= iDbgSt;
		prev_state		<= {bits{1'h0}};
		prev_state_1	<= {bits{1'h0}};
		prev_state_2	<= {bits{1'h0}};
		ochange			<= 1'b0;
	end
	else if(iDbgSt != current_state && iEnable) begin
		prev_state		<= prev_state_1;
		prev_state_1	<= prev_state_2;
		prev_state_2	<= current_state;
		current_state	<= iDbgSt;
		ochange			<= 1'b1;
	end
	else begin
		prev_state		<= prev_state;
		prev_state_1	<= prev_state_1;
		prev_state_2	<= prev_state_2;
		current_state	<= current_state;
		ochange			<= ochange;
	end
end

endmodule
