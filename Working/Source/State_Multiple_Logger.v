module State_Multiple_Logger#
(
	parameter bits = 1
)
(
    input     wire			iClk,
    input     wire			iRst_n,
	input	  wire			iClear,

    input     wire [bits-1 : 0]    iDbgSt,

    output    reg  [bits-1 : 0]    prev_state_0,
    output    reg  [bits-1 : 0]    prev_state_1,
    output    reg  [bits-1 : 0]    prev_state_2,
    output    reg  [bits-1 : 0]    current_state
);

always @ ( posedge iClk)
	begin
		if(!iRst_n || iClear)
		begin
			current_state	<= iDbgSt;
			prev_state_0	<= {bits{1'h0}};
			prev_state_1	<= {bits{1'h0}};
			prev_state_2	<= {bits{1'h0}};

		end
		else if(iDbgSt != current_state)
		begin
			prev_state_0	<= prev_state_1;
			prev_state_1	<= prev_state_2;
			prev_state_2	<= current_state;
			current_state	<= iDbgSt;
		end
		else
		begin
			prev_state_0	<= prev_state_0;
			prev_state_1	<= prev_state_1;
			prev_state_2	<= prev_state_2;
			current_state	<= current_state;
		end
	end

endmodule
