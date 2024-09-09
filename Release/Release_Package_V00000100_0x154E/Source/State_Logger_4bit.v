module State_Logger_4bit
(
    input     wire			iClk,
    input     wire			iRst_n,
	input	  wire			iClear,

    input     wire [3:0]    iDbgSt,

    output    reg  [3:0]    prev_state_0,
    output    reg  [3:0]    prev_state_1,
    output    reg  [3:0]    prev_state_2,
    output    reg  [3:0]    current_state
);

always @ ( posedge iClk)
	begin
		if(!iRst_n || iClear)
		begin
			current_state	<= iDbgSt;
			prev_state_0	<= 4'h0;
			prev_state_1	<= 4'h0;
			prev_state_2	<= 4'h0;

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
