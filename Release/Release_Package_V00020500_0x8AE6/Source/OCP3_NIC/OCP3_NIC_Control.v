
module OCP3_NIC_Control
(
	//	Input reference signal
	input	wire	iClk,		//Moudle reference clock: 2MHz.
	input	wire	iClk_1ms,	//Delay timer reference clock: 1MHz.
	input	wire	iRst_n,		//System asynchronous reset.
	
	//	Device sideband control
	input	wire	iPWR_EN_DEV,
	input	wire	iPWRGD_P3V3_AUX,

	//	NIC power OK
	output	wire	oNIC_STBY_PWR_OK,
	output	wire	oNIC_MAIN_PWR_OK,

	//	OCP3 NIC card sideband control
	input	wire	iPRSNT_NIC0_N,
	input	wire	iPWRGD_P12V_NIC0,
	input	wire	iPWRGD_P3V3_NIC0,
	output	wire	oNIC0_AUX_PWR_EN,
	input	wire	iPWRGD_NIC0_PWR_GOOD,
	output	wire	oNIC0_MAIN_PWR_EN,
	output	wire	oRST_NIC0_PERST_N,

	input	wire	iPRSNT_NIC1_N,
	input	wire	iPWRGD_P12V_NIC1,
	input	wire	iPWRGD_P3V3_NIC1,
	output	wire	oNIC1_AUX_PWR_EN,
	input	wire	iPWRGD_NIC1_PWR_GOOD,
	output	wire	oNIC1_MAIN_PWR_EN,
	output	wire	oRST_NIC1_PERST_N,
	
	output	wire	[7:0] oNICx_FSM_curr,

	output	wire	oAUX_SEQPWR_FLT_NIC0,
	output	wire	oP12V_SEQPWR_FLT_NIC0,
	output	wire	oAUX_SEQPWR_FLT_NIC1,
	output	wire	oP12V_SEQPWR_FLT_NIC1,

	output	wire	oAUX_RUNTIME_FLT_NIC0,
	output	wire	oP12V_RUNTIME_FLT_NIC0,
	output	wire	oAUX_RUNTIME_FLT_NIC1,
	output	wire	oP12V_RUNTIME_FLT_NIC1
);

wire 	wPWRGD_NIC0_EDGE;
wire 	wPWRGD_NIC1_EDGE;
wire 	[3:0] wDBG_OCP3_NIC0_FSM_curr;
wire 	[3:0] wDBG_OCP3_NIC1_FSM_curr;

assign	wPWRGD_NIC0_EDGE = iPWRGD_P12V_NIC0 && iPWRGD_P3V3_NIC0;
assign	wPWRGD_NIC1_EDGE = iPWRGD_P12V_NIC1 && iPWRGD_P3V3_NIC1;

//	Instances
assign	oNICx_FSM_curr[7] =	wDBG_OCP3_NIC0_FSM_curr[3];
assign	oNICx_FSM_curr[6] =	wDBG_OCP3_NIC0_FSM_curr[2];
assign	oNICx_FSM_curr[5] =	wDBG_OCP3_NIC0_FSM_curr[1];
assign	oNICx_FSM_curr[4] =	wDBG_OCP3_NIC0_FSM_curr[0];
assign	oNICx_FSM_curr[3] =	wDBG_OCP3_NIC1_FSM_curr[3];
assign	oNICx_FSM_curr[2] =	wDBG_OCP3_NIC1_FSM_curr[2];
assign	oNICx_FSM_curr[1] =	wDBG_OCP3_NIC1_FSM_curr[1];
assign	oNICx_FSM_curr[0] =	wDBG_OCP3_NIC1_FSM_curr[0];

assign	oNIC_STBY_PWR_OK = 
(
	(iPRSNT_NIC0_N ^ wPWRGD_NIC0_EDGE)	&&
	(iPRSNT_NIC1_N ^ wPWRGD_NIC1_EDGE)	
);
	
assign	oNIC_MAIN_PWR_OK = 
(
	(iPRSNT_NIC0_N ^ iPWRGD_NIC0_PWR_GOOD)	&&
	(iPRSNT_NIC1_N ^ iPWRGD_NIC1_PWR_GOOD)
);
	
OCP3_NIC_Sequence mOCP3_NIC0_Sequence
(
	.iClk   				(iClk),		
	.iClk_1ms   			(iClk_1ms),	
	.iRst_n 				(iRst_n),
	.iPRSNT_NIC_N   		(iPRSNT_NIC0_N),
	.iPG_P3V3_AUX			(iPWRGD_P3V3_AUX),
	.iPG_P12V_AUX			(iPWRGD_P12V_NIC0),
	.iPWRGD_NIC_EDGE    	(wPWRGD_NIC0_EDGE),
	.oNIC_AUX_PWR_EN    	(oNIC0_AUX_PWR_EN),
	.iPWRGD_NIC_PWR_GOOD    (iPWRGD_NIC0_PWR_GOOD),
	.oNIC_MAIN_PWR_EN   	(oNIC0_MAIN_PWR_EN),
	.oRST_NIC_PERST_N   	(oRST_NIC0_PERST_N),
	.iPWR_EN_DEV    		(iPWR_EN_DEV),
	.oDBG_OCP3_NIC_FSM_curr (wDBG_OCP3_NIC0_FSM_curr),
	.oAUX_SEQPWR_FLT		(oAUX_SEQPWR_FLT_NIC0),
	.oP12V_SEQPWR_FLT		(oP12V_SEQPWR_FLT_NIC0),
	.oAUX_RUNTIME_FLT		(oAUX_RUNTIME_FLT_NIC0),
	.oP12V_RUNTIME_FLT		(oP12V_RUNTIME_FLT_NIC0)
);

OCP3_NIC_Sequence mOCP3_NIC1_Sequence
(
	.iClk   				(iClk),		
	.iClk_1ms   			(iClk_1ms),	
	.iRst_n 				(iRst_n),
	.iPRSNT_NIC_N   		(iPRSNT_NIC1_N),
	.iPG_P3V3_AUX			(iPWRGD_P3V3_AUX),
	.iPG_P12V_AUX			(iPWRGD_P12V_NIC1),
	.iPWRGD_NIC_EDGE    	(wPWRGD_NIC1_EDGE),
	.oNIC_AUX_PWR_EN    	(oNIC1_AUX_PWR_EN),
	.iPWRGD_NIC_PWR_GOOD    (iPWRGD_NIC1_PWR_GOOD),
	.oNIC_MAIN_PWR_EN   	(oNIC1_MAIN_PWR_EN),
	.oRST_NIC_PERST_N   	(oRST_NIC1_PERST_N),
	.iPWR_EN_DEV    		(iPWR_EN_DEV),
	.oDBG_OCP3_NIC_FSM_curr (wDBG_OCP3_NIC1_FSM_curr),
	.oAUX_SEQPWR_FLT		(oAUX_SEQPWR_FLT_NIC1),
	.oP12V_SEQPWR_FLT		(oP12V_SEQPWR_FLT_NIC1),
	.oAUX_RUNTIME_FLT		(oAUX_RUNTIME_FLT_NIC1),
	.oP12V_RUNTIME_FLT		(oP12V_RUNTIME_FLT_NIC1)
);
	
endmodule
