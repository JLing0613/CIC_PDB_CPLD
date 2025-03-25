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

wire  [bits-1 : 0]	v_prev_state;
wire  [bits-1 : 0]	v_prev_state_1;
wire  [bits-1 : 0]	v_prev_state_2;
wire  [bits-1 : 0]	v_current_state;	
wire 				v_ochange;
	
assign v_prev_state     =  !iClear ?  iDbgSt       : (iDbgSt != current_state && iEnable) ? prev_state_1 : prev_state;
assign v_prev_state_1   =  !iClear ?  {bits{1'h0}} : (iDbgSt != current_state && iEnable) ? prev_state_2 : prev_state_1;
assign v_prev_state_2   =  !iClear ?  {bits{1'h0}} : (iDbgSt != current_state && iEnable) ? current_state: prev_state_2;
assign v_current_state  =  !iClear ?  {bits{1'h0}} : (iDbgSt != current_state && iEnable) ? iDbgSt       : current_state;
assign v_ochange        =  !iClear ?  1'b0         : (iDbgSt != current_state && iEnable) ? 1'b1         : ochange;

always @ (posedge iClk or negedge iRst_n) begin
	if(!iRst_n) begin
		current_state	<= {bits{1'h0}};
		prev_state		<= {bits{1'h0}};
		prev_state_1	<= {bits{1'h0}};
		prev_state_2	<= {bits{1'h0}};
		ochange			<= 1'b0;
	end
	else begin
		prev_state		<= v_prev_state;
		prev_state_1	<= v_prev_state_1;
		prev_state_2	<= v_prev_state_2;
		current_state	<= v_current_state;
		ochange			<= v_ochange;
	end
end

endmodule
