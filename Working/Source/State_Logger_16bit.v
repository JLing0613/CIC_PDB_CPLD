module State_Logger_16bit
(
    input     wire          iClk,
    input     wire          iRst_n,
	input	  wire			iClear,

    input     wire [15:0]   iDbgSt,

    output    reg  [15:0]   prev_state,
    output    reg  [15:0]   current_state
);

always @ ( posedge iClk)
	begin
		if(!iRst_n || iClear)
		begin
			current_state	<= iDbgSt;
			prev_state		<= 16'h0;
		end
		else if(iDbgSt != current_state)
		begin 
			prev_state		<= current_state;
			current_state	<= iDbgSt;
		end
		else
		begin
			prev_state		<= prev_state;
			current_state	<= current_state;
		end
	end

endmodule
