//OSC original clk:24.18MHz
//System clk:1MHz (1us)
//-----------------------------------------------------------------------------	  
module TimerMang(iClk, resetn_i, Trigger1us, Trigger10us, Trigger1ms,
                 Trigger10ms, Trigger100ms, Trigger1s, clk1ms, clk1us);
				 
	input iClk;
	input resetn_i;
	output Trigger1us, Trigger10us;
	output Trigger1ms, Trigger10ms, Trigger100ms, Trigger1s;
	output clk1ms, clk1us;
	
//============time trigger======================================================
	reg Trigger10us;
	reg Trigger10ms, Trigger100ms, Trigger1s;
	reg clk1ms, clk1us;
	reg Trigger1us=0;
	reg Trigger1ms=0;
	
	reg[5:0] count1us=0;
	reg[3:0] count10us=0;
	reg[9:0] count1ms=0;
	reg[3:0] count10ms=0;
	reg[6:0] count100ms=0;
	reg[9:0] count1s=0;
	reg[2:0] countRst=0;

	parameter t_1us=6'd23; //unit
	parameter t_10us=4'd9; //unit
	parameter t_1ms=10'd999; //unit
	parameter t_10ms=4'd9; //unit
	parameter t_100ms=7'd99; //unit
	parameter t_1s=10'd999; //unit
	parameter t_Rst=3'd5; //unit 1s


//count 1us
always@(posedge iClk)
	if(count1us==t_1us)  count1us<=6'd0;
	else count1us<=count1us+1'b1;

//count 10us		
always@(posedge iClk)
	if(count10us==t_10us) count10us<=4'd0;
	else if(Trigger1us) count10us<=count10us+1'b1;
		
//count 1ms
always@(posedge iClk)
	if(count1ms==t_1ms) count1ms<=10'd0;
	else if(Trigger1us) count1ms<=count1ms+1'b1;

//count 10ms
always@(posedge iClk)
	if(count10ms==t_10ms) count10ms<=4'd0;
	else if(Trigger1ms) count10ms<=count10ms+1'b1;

//count 100ms
always@(posedge iClk)
	if(count100ms==t_100ms) count100ms<=7'd0;
	else if(Trigger1ms) count100ms<=count100ms+1'b1;

//count 1s
always@(posedge iClk)
	if(count1s==t_1s) count1s<=10'd0;
	else if(Trigger1ms) count1s<=count1s+1'b1; 
			
//1us iClk & Trigger
always@(posedge iClk)
	if(count1us==6'd1) begin
		clk1us<=1'b1;
		Trigger1us<=1'b1;
	end
	else if(count1us==6'd20) clk1us<=1'b0;
	else Trigger1us<=1'b0;
		
//10us Trigger
always@(posedge iClk)
	if(count10us==4'd1&& Trigger1us) Trigger10us<=1'b1;
	else Trigger10us<=1'b0;		

//1ms iClk & Trigger
always@(posedge iClk)
	if(count1ms==10'd1 && Trigger1us) begin
		clk1ms<=1'b1;
		Trigger1ms<=1'b1;
	end
	else if(count1ms==10'd501) clk1ms<=1'b0;
	else Trigger1ms<=1'b0;
		
//10ms Trigger
always@(posedge iClk)
	if(count10ms==4'd1&& Trigger1ms) Trigger10ms<=1'b1;
	else Trigger10ms<=1'b0;		
		
//100ms Trigger
always@(posedge iClk)
	if(count100ms==7'd1&& Trigger1ms) Trigger100ms<=1'b1;
	else Trigger100ms<=1'b0;	

//1s Trigger
always@(posedge iClk)
	if(count1s==10'd1&& Trigger1ms) Trigger1s<=1'b1;
	else Trigger1s<=1'b0;	


endmodule