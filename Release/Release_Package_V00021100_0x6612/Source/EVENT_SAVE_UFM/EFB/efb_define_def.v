//----------------------------------------------------------------------------------//
//   Copyright (c) 2014 by Lattice Semiconductor Corporation						//
//   ALL RIGHTS RESERVED 															//
//----------------------------------------------------------------------------------//
//																					//
//   Permission:																	//
//																					//
//      Lattice SG Pte. Ltd. grants permission to use this code						//
//      pursuant to the terms of the Lattice Reference Design License Agreement. 	//
//																					//
//																					//
//   Disclaimer:																	//
//																					//
//      This VHDL or Verilog source code is intended as a design reference			//
//      which illustrates how these types of functions can be implemented.			//
//      It is the user's responsibility to verify their design for					//
//      consistency and functionality through the use of formal						//
//      verification methods.  Lattice provides no warranty							//
//      regarding the use or functionality of this code.							//
//																					//
//----------------------------------------------------------------------------------//
//																					//
//                  Lattice SG Pte. Ltd.											//
//                  101 Thomson Road, United Square #07-02 							//
//                  Singapore 307591												//
//																					//
//																					//
//                  TEL: 1-800-Lattice (USA and Canada)								//
//                       +65-6631-2000 (Singapore)									//
//                       +1-503-268-8001 (other locations)							//
//																					//
//                  web: http://www.latticesemi.com/								//
//                  email: techsupport@latticesemi.com								//
//																					//
//----------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------//
//  Change History (Latest changes on top )
//
//  Ver    Date        Person
//----------------------------------------------------------------------------------
//  3.0    13/9/2011   Akhilesh LBN
//
//----------------------------------------------------------------------------------


/***********************************************************************
 *                                                                     *
 * EFB REGISTER SET                                                    *
 *                                                                     *
 ***********************************************************************/

 
`define MICO_EFB_I2C_CR					   8'h40 //4a
`define MICO_EFB_I2C_CMDR					   8'h41 //4b
`define MICO_EFB_I2C_BLOR					   8'h42 //4c
`define MICO_EFB_I2C_BHIR					   8'h43 //4d
`define MICO_EFB_I2C_TXDR					   8'h44 //4e
`define MICO_EFB_I2C_SR					   8'h45 //4f
`define MICO_EFB_I2C_GCDR					   8'h46 //50
`define MICO_EFB_I2C_RXDR					   8'h47 //51
`define MICO_EFB_I2C_IRQSR				   8'h48 //52
`define MICO_EFB_I2C_IRQENR				   8'h49 //53

`define MICO_EFB_SPI_CR0					   8'h54 
`define MICO_EFB_SPI_CR1					   8'h55 
`define MICO_EFB_SPI_CR2					   8'h56 
`define MICO_EFB_SPI_BR					   8'h57 
`define MICO_EFB_SPI_CSR					   8'h58 
`define MICO_EFB_SPI_TXDR					   8'h59 
`define MICO_EFB_SPI_SR					   8'h5a 
`define MICO_EFB_SPI_RXDR					   8'h5b 
`define MICO_EFB_SPI_IRQSR				   8'h5c 
`define MICO_EFB_SPI_IRQENR				   8'h5d 


`define MICO_EFB_TIMER_CR0				   8'h5E 
`define MICO_EFB_TIMER_CR1				   8'h5F 
`define MICO_EFB_TIMER_TOP_SET_LO			   8'h60 
`define MICO_EFB_TIMER_TOP_SET_HI			   8'h61 
`define MICO_EFB_TIMER_OCR_SET_LO			   8'h62 
`define MICO_EFB_TIMER_OCR_SET_HI			   8'h63 
`define MICO_EFB_TIMER_CR2				   8'h64 
`define MICO_EFB_TIMER_CNT_SR_LO			   8'h65 
`define MICO_EFB_TIMER_CNT_SR_HI			   8'h66 
`define MICO_EFB_TIMER_TOP_SR_LO			   8'h67 
`define MICO_EFB_TIMER_TOP_SR_HI			   8'h68 
`define MICO_EFB_TIMER_OCR_SR_LO			   8'h69 
`define MICO_EFB_TIMER_OCR_SR_HI			   8'h6A 
`define MICO_EFB_TIMER_ICR_SR_LO			   8'h6B 
`define MICO_EFB_TIMER_ICR_SR_HI			   8'h6C 
`define MICO_EFB_TIMER_SR					   8'h6D 
`define MICO_EFB_TIMER_IRQSR				   8'h6E 
`define MICO_EFB_TIMER_IRQENR				   8'h6F 

 
/***********************************************************************
 *                                                                     *
 * EFB SPI CONTROLLER PHYSICAL DEVICE SPECIFIC INFORMATION             *
 *                                                                     *
 ***********************************************************************/




// Control Register 1 Bit Masks
`define MICO_EFB_SPI_CR1_SPE				   8'h80 
`define MICO_EFB_SPI_CR1_WKUPEN			   8'h40 
// Control Register 2 Bit Masks
`define MICO_EFB_SPI_CR2_LSBF				   8'h01 
`define MICO_EFB_SPI_CR2_CPHA				   8'h02 
`define MICO_EFB_SPI_CR2_CPOL				   8'h04 
`define MICO_EFB_SPI_CR2_SFSEL_NORMAL		   8'h00 
`define MICO_EFB_SPI_CR2_SFSEL_LATTICE	   8'h08 
`define MICO_EFB_SPI_CR2_SRME				   8'h20 
`define MICO_EFB_SPI_CR2_MCSH				   8'h40 
`define MICO_EFB_SPI_CR2_MSTR				   8'h80 
// Status Register Bit Masks
`define MICO_EFB_SPI_SR_TIP				   8'h80 
`define MICO_EFB_SPI_SR_TRDY				   8'h10 
`define MICO_EFB_SPI_SR_RRDY				   8'h08 
`define MICO_EFB_SPI_SR_TOE				   8'h04 
`define MICO_EFB_SPI_SR_ROE				   8'h02 
`define MICO_EFB_SPI_SR_MDF				   8'h01 

/***********************************************************************
 *                                                                     *
 * EFB I2C CONTROLLER PHYSICAL DEVICE SPECIFIC INFORMATION             *
 *                                                                     *
 ***********************************************************************/


// Control Register Bit Masks
`define MICO_EFB_I2C_CR_I2CEN				   8'h80 
`define MICO_EFB_I2C_CR_GCEN				   8'h40 
`define MICO_EFB_I2C_CR_WKUPEN			   8'h20 
// Status Register Bit Masks
`define MICO_EFB_I2C_SR_TIP				   8'h80 
`define MICO_EFB_I2C_SR_BUSY				   8'h40 
`define MICO_EFB_I2C_SR_RARC				   8'h20 
`define MICO_EFB_I2C_SR_SRW				   8'h10 
`define MICO_EFB_I2C_SR_ARBL				   8'h08 
`define MICO_EFB_I2C_SR_TRRDY				   8'h04 
`define MICO_EFB_I2C_SR_TROE				   8'h02 
`define MICO_EFB_I2C_SR_HGC				   8'h01 
// Command Register Bit Masks 
`define MICO_EFB_I2C_CMDR_STA				   8'h80 
`define MICO_EFB_I2C_CMDR_STO				   8'h40 
`define MICO_EFB_I2C_CMDR_RD				   8'h20 
`define MICO_EFB_I2C_CMDR_WR				   8'h10 
`define MICO_EFB_I2C_CMDR_NACK			   8'h08 
`define MICO_EFB_I2C_CMDR_CKSDIS			   8'h04 

/***********************************************************************
 *                                                                     *
 * EFB I2C USER DEFINE                                                 *
 *                                                                     *
 ***********************************************************************/
`define MICO_EFB_I2C_TRANSMISSION_DONE	     8'h00 
`define MICO_EFB_I2C_TRANSMISSION_ONGOING	     8'h80 
`define MICO_EFB_I2C_FREE                      8'h00 
`define MICO_EFB_I2C_BUSY                      8'h40 
`define MICO_EFB_I2C_ACK_NOT_RCVD			     8'h20 
`define MICO_EFB_I2C_ACK_RCVD				     8'h00 
`define MICO_EFB_I2C_ARB_LOST				     8'h08 
`define MICO_EFB_I2C_ARB_NOT_LOST			     8'h00 
`define MICO_EFB_I2C_DATA_READY			     8'h04 

/***********************************************************************
 *                                                                     *
 * EFB TIMER PHYSICAL DEVICE SPECIFIC INFORMATION                      *
 *                                                                     *
 ***********************************************************************/



// Control Register 0
`define MICO_EFB_TIMER_RSTN_MASK			   8'h80 
`define MICO_EFB_TIMER_GSRN_MASK			   8'h40 
`define MICO_EFB_TIMER_GSRN_ENABLE		   8'h40 
`define MICO_EFB_TIMER_GSRN_DISABLE		   8'h00 
`define MICO_EFB_TIMER_CCLK_MASK			   8'h38 
`define MICO_EFB_TIMER_CCLK_DIV_0			   8'h00 
`define MICO_EFB_TIMER_CCLK_DIV_1			   8'h08 
`define MICO_EFB_TIMER_CCLK_DIV_8			   8'h10 
`define MICO_EFB_TIMER_CCLK_DIV_64		   8'h18 
`define MICO_EFB_TIMER_CCLK_DIV_256		   8'h20 
`define MICO_EFB_TIMER_CCLK_DIV_1024		   8'h28 
`define MICO_EFB_TIMER_SCLK_MASK			   8'h07 
`define MICO_EFB_TIMER_SCLK_CIB_RE		   8'h00 
`define MICO_EFB_TIMER_SCLK_OSC_RE		   8'h02 
`define MICO_EFB_TIMER_SCLK_CIB_FE		   8'h04 
`define MICO_EFB_TIMER_SCLK_OSC_FE		   8'h06 
// Control Register 1
`define MICO_EFB_TIMER_TOP_SEL_MASK		   8'h80 
`define MICO_EFB_TIMER_TOP_MAX			   8'h00 
`define MICO_EFB_TIMER_TOP_USER_SELECT	   8'h10 
`define MICO_EFB_TIMER_OC_MODE_MASK		   8'h0C 
`define MICO_EFB_TIMER_OC_MODE_STATIC_ZERO   8'h00 
`define MICO_EFB_TIMER_OC_MODE_TOGGLE		   8'h04 
`define MICO_EFB_TIMER_OC_MODE_CLEAR		   8'h08 
`define MICO_EFB_TIMER_OC_MODE_SET		   8'h0C 
`define MICO_EFB_TIMER_MODE_MASK			   8'h03 
`define MICO_EFB_TIMER_MODE_WATCHDOG		   8'h00 
`define MICO_EFB_TIMER_MODE_CTC			   8'h01 
`define MICO_EFB_TIMER_MODE_FAST_PWM		   8'h02 
`define MICO_EFB_TIMER_MODE_TRUE_PWM		   8'h03 
// Control Register 2
`define MICO_EFB_TIMER_OC_FORCE			   8'h04 
`define MICO_EFB_TIMER_CNT_RESET			   8'h02 
`define MICO_EFB_TIMER_CNT_PAUSE			   8'h01 
// Status Register
`define MICO_EFB_TIMER_SR_OVERFLOW		   8'h01 
`define MICO_EFB_TIMER_SR_COMPARE_MATCH	   8'h02 
`define MICO_EFB_TIMER_SR_CAPTURE			   8'h04 



`define CFGCR    8'h70  
`define CFGTXDR  8'h71  
`define CFGSR    8'h72  
`define CFGRXDR  8'h73  
`define CFGIRQ   8'h74  
`define CFGIRQEN    8'h75 

/***********************************************************************
 *                                                                     *
 * PULI SPECIFIC                                                       *
 *                                                                     *
 ***********************************************************************/
 
 `define ALL_ZERO   8'h00 
 `define READ       1'b0  
 `define READ       1'b0  
 `define HIGH       1'b1  
 `define WRITE      1'b1  
 `define LOW        1'b0  
 `define READ_STATUS     1'b0  
 `define READ_DATA       1'b0  
 
/***********************************************************************
 *                                                                     *
 * State Machine Variables                                             *
 *                                                                     *
 ***********************************************************************/ 		
		

`define          state0             7'd00     
`define          state1	          	7'd01    
`define          state2	          	7'd02    
`define          state3	          	7'd03    
`define          state4             7'd04    
`define          state5	          	7'd05    
`define          state6	          	7'd06    
`define          state7	          	7'd07    
`define          state8	          	7'd08    
`define          state9	          	7'd09    
`define          state10  	      	7'd10    
`define          state11	        7'd11    
`define          state12            7'd12    
`define          state13            7'd13    
`define          state14            7'd14    
`define          state15            7'd15    
`define          state16            7'd16    
`define          state17            7'd17    
`define          state18            7'd18    
`define          state19            7'd19    
`define          state20            7'd20    
`define          state21            7'd21    
`define          state22            7'd22    
`define          state23            7'd23    
`define          state24            7'd24    
`define          state25            7'd25    
`define          state26            7'd26    
`define          state27            7'd27    
`define          state28            7'd28    
`define          state29            7'd29    
`define          state30            7'd30    
`define          state31            7'd31    
`define          state32            7'd32    
`define          state33            7'd33    
`define          state34            7'd34    
`define          state35            7'd35    
`define          state36            7'd36    
`define          state37            7'd37    
`define          state38            7'd38    
`define          state39            7'd39    
`define          state40            7'd40    
`define          state41            7'd41    
`define          state42            7'd42    
`define          state43            7'd43    
`define          state44            7'd44    
`define          state45            7'd45    
`define          state46            7'd46    
`define          state47            7'd47    
`define          state48            7'd48    
`define          state49            7'd49    
`define          state50            7'd50    
`define          state51            7'd51    
`define          state52            7'd52    
`define          state53            7'd53    
`define          state54            7'd54    
`define          state55            7'd55    
`define          state56            7'd56    
`define          state57            7'd57    
`define          state58            7'd58    
`define          state59            7'd59    
`define          state60            7'd60    
`define          stateRD_delay      7'd61    
`define          state62            7'd62    
`define          state63            7'd63    
`define          state64            7'd64    
`define          state65            7'd65    
`define          state66	        7'd66  
`define          state67            7'd67  
`define          state68            7'd68  
`define          state69            7'd69  
`define          state70            7'd70  
`define          state71            7'd71  
`define          state72            7'd72  
`define          state73            7'd73  
`define          state74            7'd74  
`define          state75            7'd75  
`define          state76            7'd76  
`define          state77            7'd77  
`define          state78            7'd78  
`define          state79            7'd79  
`define          state80            7'd80  
`define          state81            7'd81  
`define          state82            7'd82  
`define          state83            7'd83  
`define          state84            7'd84  
`define          state85            7'd85  
`define          state86            7'd86  
`define          state87            7'd87  
`define          state88            7'd88  
`define          state89            7'd89  
`define          state90            7'd90  
`define          state91            7'd91  
`define          state92            7'd92  
`define          state93            7'd93  
`define          state94            7'd94  
`define          state95            7'd95  
`define          state96            7'd96  
`define          state97            7'd97  
`define          state98            7'd98  
`define          state99            7'd99  
`define          state100           7'd100   
`define          state101           7'd101   
`define          state102           7'd102   
`define          state103           7'd103   
`define          state104           7'd104   
`define          state105           7'd105   
`define          state106           7'd106   
`define          state107           7'd107   
`define          state108           7'd108   
`define          state109           7'd109   
`define          state110           7'd110   
`define          state111           7'd111   
`define          state112           7'd112   
`define          state113           7'd113   
`define          state114           7'd114   
`define          state115           7'd115   
`define          state116           7'd116   
`define          state117           7'd117   
`define          state118           7'd118   
`define          state119           7'd119   
`define          state120           7'd120   
`define          state121	        7'd121   
`define          state122	        7'd122   
`define          state123	        7'd123   
`define          state124	        7'd124   
`define          state125	        7'd125   
`define          state126	        7'd126   
`define          state127	        7'd127