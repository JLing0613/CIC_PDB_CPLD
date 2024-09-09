// (C) 2020 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

module GlitchFilter 
   #(
	   parameter	NUMBER_OF_SIGNALS	= 1,
      parameter   RST_VALUE = 0)       //reset value for all filter stages
   (
      input                            iClk, //% Clock Input
      input                            iARst_n,//% Asynchronous Reset Input
      input                            iSRst_n, //Synchronous Reset Input
      input                            iEna,  //%enable signal (only executes when this is HIGH)
      input [NUMBER_OF_SIGNALS-1 : 0]  iSignal,//% Input Signals
      output [NUMBER_OF_SIGNALS-1 : 0] oFilteredSignals//%Glitchless Signal
   );
   
   //Internal signals
   reg [NUMBER_OF_SIGNALS-1 : 0]     rFilter;
   reg [NUMBER_OF_SIGNALS-1 : 0]     rFilteredSignals;

   integer                           i;
   
   always @(posedge iClk, negedge iARst_n) begin
      if (!iARst_n) begin //asynch active-low Reset condition
         rFilter			<= RST_VALUE;     //{NUMBER_OF_SIGNALS{1'b0}};
         rFilteredSignals	<= RST_VALUE;     //{NUMBER_OF_SIGNALS{1'b0}};
      end
      else begin
           if (!iSRst_n)
           begin
              rFilteredSignals <= RST_VALUE;
              rFilter          <= RST_VALUE;
           end
         else if (iEna)          //if this module requires a slower than core clock, we generate a pulse with proper 
           begin            //frequency and feed to iEna input signal, otherwise it can be HIGH all the time
	          rFilter <= iSignal; //Input signal flip flop

              for (i=0; i<=NUMBER_OF_SIGNALS-1; i=i+1)
                begin
	               if (iSignal[i] == rFilter[i]) //if previous and current signal are the same output is enabled
                     begin 
		                rFilteredSignals[i] <= rFilter[i];
                     end
	            end
           end // if (iEna)
         else
           begin
              rFilteredSignals <= rFilteredSignals;
           end
         
      end // else: !if(!iARst_n)
   end // always @ (posedge iClk, negedge iARst_n)
   
   //Output assignment
   assign oFilteredSignals = rFilteredSignals;
   
endmodule
