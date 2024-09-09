module State_Single_Logger#
(
	parameter bits = 1
//	parameter n_prev = 1
)
(
    input     wire    iClk,
    input     wire    iRst_n,
	input	  wire	  iClear,

    input     wire	  [bits-1 : 0]  iDbgSt,

    output    reg     [bits-1 : 0]	prev_state,
    output    reg     [bits-1 : 0]	current_state,
	output	  reg	  ochange
);

always @ (posedge iClk)
	begin
		if(!iRst_n || iClear)
		begin
			current_state	<= iDbgSt;
			prev_state		<= {bits{1'h0}};
			ochange			<= 1'b0;
		end
		else if(iDbgSt != current_state)
		begin
			prev_state		<= current_state;
			current_state	<= iDbgSt;
			ochange			<= 1'b1;
		end
		else
		begin
			prev_state		<= prev_state;
			current_state	<= current_state;
			ochange			<= ochange;	
		end
	end

//integer i;
//integer j;
//
//always @ (posedge iClk)
//	begin
//		if(!iRst_n || iClear)
//		begin
//			current_state	<= iDbgSt;
//			prev_state		<= {bits*n_prev{1'h0}};
//		end
//		else if(iDbgSt != current_state)
//		begin
//			current_state				<= iDbgSt;
//			prev_state[(bits-1):0]		<= current_state;
//			for(j=0 ;j<n_prev-1 ;j=j+1)
//			begin
//				for(i=bits*j ;i<=bits*(j+1) ;i=i+1)
//				begin
//					prev_state[i+bits]			<= prev_state[i];
//				end
//			end
//		end
//		else
//		begin
//			prev_state		<= prev_state;
//			current_state	<= current_state;
//		end
//	end

endmodule
