//////////////////////////////////////////////////////////////////////////////////
/*!

	\brief    <b>%Generator of Reset</b>
	\file    Generator_reset.v
	\details    <b>Image of the Block:</b>
				\image html genreset.PNG
	
				 <b>Description:</b> \n
				This module is for generate the signal of reset, the duration is two cycle of input clock \n
				 
				
	\brief  <b>Last modified</b>
			$Date:   Dec 04, 2014 $
			$Author:  jose.d.bolanos.rodriguez@intel.com $			
			Project			: HSBP Neon
			Group			: BD
	\version    
			 20141203 \b  jose.d.bolanos.rodriguez@intel.com - File creation\n
			   
	\copyright Intel Proprietary -- Copyright 2014 Intel -- All rights reserved
*/
//////////////////////////////////////////////////////////////////////////////////

module Generator_reset
	(
		input iClk,//%Input Clock
		output oReset//%Output Reset
	);
//////////////////////////////////////////////////////////////////////////////////
// Internal Signals
//////////////////////////////////////////////////////////////////////////////////
//!
	reg [15:0] rCounter=16'h0;
	reg rReset=1'b0;
//////////////////////////////////////////////////////////////////////////////////
// Continuous assignments
//////////////////////////////////////////////////////////////////////////////////
	assign oReset=rReset;
//////////////////////////////////////////////////////////////////////////////////
// Sequential logic
//////////////////////////////////////////////////////////////////////////////////
always @ (posedge iClk)
	begin 
		if(rCounter != 16'h000f)
			begin		
				rCounter = rCounter+ 16'h1;
				rReset<=1'b0;
			end
		else 
			begin
				rReset<=1'b1;			
			end	 
	end
		
endmodule 
		
	