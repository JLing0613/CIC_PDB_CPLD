
module MSTR_SEQ
(
	//	Input reference signal
	input	wire	iClk,		//Moudle reference clock: 2MHz.
	input	wire	iClk_1ms,	//Delay timer reference clock: 1MHz.
	input	wire	iClk_50ms,	//Delay timer reference clock: 200Hz.
	input	wire	iRst_n,		//System asynchronous reset.

	input	wire	iPWRGD_P3V3_AUX,
	input	wire	iPWRGD_P12V_AUX,
	input	wire	iRMC_PWR_Enable,
	input	wire	iLeak_Detect_Delay,
	input	wire	iLarge_Leak_Detect_N,
	input	wire	iSmall_Leak_Detect_N,
	input	wire	[3:0]	iPlatform_Config,
	input	wire	iBMC_Config,
	input	wire	iNIC0_PRSNT,
	input	wire	iNIC1_PRSNT,

	output	reg		oP12V_AUX_FAN_EN,
	input	wire	iPWRGD_P12V_AUX_FAN,

	input	wire	iDC_PWR_BTN_ON,
	output	reg		oPWR_EN_Devices,
	output	reg		oP12V_NODEx_EN,
	output	reg		oP12V_N1_EN,
	output	reg		oP12V_N2_EN,
	input	wire	iPWRGD_P12V_Nodex,
	input	wire	iHost_PERST_NIC0,
	input	wire	iHost_PERST_NIC1,
	
	input	wire	iPWR_P48V_FAULT,
	input	wire	iPWR_FAN_FAULT,
	input	wire	iPWR_NIC0_FAULT,
	input	wire 	iPWR_NIC1_FAULT,

	output	wire	[3:0] oDBG_MSTR_SEQ_FSM_curr,

	output	wire	oP12V_AUX_SEQPWR_FLT,
	output	wire	oP12V_FAN_SEQPWR_FLT,
	output	wire	oP12V_N1N2_SEQPWR_FLT,
	output	wire	oHost_PERST_SEQPWR_FLT,
	output	wire	oP12V_AUX_RUNTIME_FLT,
	output	wire	oP12V_FAN_RUNTIME_FLT,
	output	wire	oP12V_N1N2_RUNTIME_FLT,
	output	wire	oLargeLeak_Detect_delay,
	output	wire	oSmallLeak_Detect_delay

);

//	Parameter of state machine
localparam	St_9_IDLE			= 4'h9;		//	Idle
localparam	St_7_Standby_Ready	= 4'h7;		//	Standby Ready
localparam	St_5_FAN_on			= 4'h5;		//	FAN Power OK
localparam	St_3_Devices_on		= 4'h3;		//	N1 & N2 & NIC Power OK
localparam	St_1_HOST_Ready		= 4'h1;		//	Host Ready
localparam	St_0_S0				= 4'h0;		//	Done
localparam	St_2_DC_off			= 4'h2;		//	DC off standby
localparam	St_e_Leakage		= 4'he;		//	Leakage
localparam	St_f_Fault			= 4'hf;		//	Fault
	
//	Parameter of delay time
localparam	dly_0ms				= 16'd0;		// 1ms x 0    	= 0ms
localparam	dly_1ms				= 16'd1;		// 1ms x 1    	= 1ms
localparam	dly_10ms			= 16'd10;		// 1ms x 10   	= 10ms
localparam	dly_20ms			= 16'd20;		// 1ms x 20   	= 20ms
localparam	dly_150ms			= 16'd150;		// 1ms x 150   	= 150ms
localparam	dly_1s				= 16'd1000;		// 1ms x 1000	= 1s
localparam	dly_5s				= 16'd5000;		// 1ms x 5000	= 5s
localparam	dly_10s				= 16'd10000;	// 1ms x 10000	= 10s
	
//	Internal declarations
wire	wDLY_TIMEOUT;
wire	wUFM_DLY_TIMEOUT;
wire	wPWRGD_AUX;
wire	wRMC_Enable;
wire	wLeakage_N;
wire	wLargeLeakage_N;
wire	wSmallLeakage_N;
wire	wLeakage_delay_N;
wire	wLargeLeakage_delay_N;
wire	wSmallLeakage_delay_N;
reg		rLeakage_N;
reg		rLargeLeakage_N;
reg		rSmallLeakage_N;

wire	wFault_N;

wire	wUFM_P12V_AUX_PWRGD_constant_Edge_Detector;
wire	wUFM_FAN_PWRGD_constant_Edge_Detector;
wire	wUFM_N1N2_PWRGD_constant_Edge_Detector;

wire	wHost_PERST_NIC0;
wire	wHost_PERST_NIC1;

wire	wBMC_config_done;

reg		rDLY_TIMER_EN;
reg		rUFM_DLY_TIMER_EN;
reg		[15:0]	rDLY_TIME;
reg		[3:0] rDBG_MSTR_SEQ_FSM_curr;

//	Instances
assign	wPWRGD_AUX 				=	iPWRGD_P3V3_AUX & iPWRGD_P12V_AUX;
assign	wRMC_Enable				=	iRMC_PWR_Enable;
assign	wLargeLeakage_N			=	rLargeLeakage_N;
assign	wSmallLeakage_N			=	rSmallLeakage_N;

//assign	wFault_N				=	iPWR_P48V_FAULT & iPWR_FAN_FAULT;

assign	wBMC_config_done		=	(iBMC_Config && (iPlatform_Config == S1_Leading_POR || 
													 iPlatform_Config == S2_Initial_Bring_Up || 
													 iPlatform_Config == S4_Capacity_Driven || 
													 iPlatform_Config == S8_Safety_Driven)) ? 1 : 0;

assign	oDBG_MSTR_SEQ_FSM_curr	=	rDBG_MSTR_SEQ_FSM_curr;

assign	wHost_PERST_NIC0		=	(!iNIC0_PRSNT) ? iHost_PERST_NIC0 : 1;
assign	wHost_PERST_NIC1		=	(!iNIC1_PRSNT) ? iHost_PERST_NIC1 : 1;

assign	oP12V_AUX_SEQPWR_FLT	=	(wUFM_DLY_TIMEOUT && oDBG_MSTR_SEQ_FSM_curr == St_7_Standby_Ready) ? 0 : 1;
assign	oP12V_FAN_SEQPWR_FLT	=	1;//(wUFM_DLY_TIMEOUT && oDBG_MSTR_SEQ_FSM_curr == St_5_FAN_on) ? 0 : 1;
assign	oP12V_N1N2_SEQPWR_FLT	=	(wUFM_DLY_TIMEOUT && oDBG_MSTR_SEQ_FSM_curr == St_3_Devices_on) ? 0 : 1;
assign	oHost_PERST_SEQPWR_FLT	=	(wUFM_DLY_TIMEOUT && oDBG_MSTR_SEQ_FSM_curr == St_1_HOST_Ready) ? 0 : 1;
assign	oP12V_AUX_RUNTIME_FLT	=	(wUFM_P12V_AUX_PWRGD_constant_Edge_Detector) ? 0 : 1;
assign	oP12V_FAN_RUNTIME_FLT	=	(wUFM_FAN_PWRGD_constant_Edge_Detector) ? 0 : 1;
assign	oP12V_N1N2_RUNTIME_FLT	=	(wUFM_N1N2_PWRGD_constant_Edge_Detector) ? 0 : 1;
assign	oLargeLeak_Detect_delay	=	wLargeLeakage_delay_N;
assign	oSmallLeak_Detect_delay	=	wSmallLeakage_delay_N;

always @ (posedge iClk or negedge iRst_n) begin
	if(!iRst_n)	begin
		rDBG_MSTR_SEQ_FSM_curr	<=	St_9_IDLE;
		oP12V_AUX_FAN_EN		<= 	1'b0;
		oPWR_EN_Devices			<= 	1'b0;
		oP12V_NODEx_EN			<= 	1'b0;
		oP12V_N1_EN				<=	1'b0;
		oP12V_N2_EN				<=	1'b0;

		rDLY_TIMER_EN 			<= 	1'b0;
		rDLY_TIME 				<=	dly_0ms;
		rUFM_DLY_TIMER_EN		<=	1'b0;
	end
	else begin
		case (rDBG_MSTR_SEQ_FSM_curr)
			St_9_IDLE: begin
				if(iPWRGD_P3V3_AUX) begin
					if (wDLY_TIMEOUT) begin
						oP12V_AUX_FAN_EN		<= 	1'b0;
						oPWR_EN_Devices			<= 	1'b0;
						oP12V_NODEx_EN			<= 	1'b0;
						oP12V_N1_EN				<=	1'b0;
						oP12V_N2_EN				<=	1'b0;
						rDBG_MSTR_SEQ_FSM_curr	<=	St_7_Standby_Ready;

						rDLY_TIMER_EN			<=	1'b0;
					end
					else begin
						rDLY_TIMER_EN			<=	1'b1;
						rDLY_TIME				<=	dly_5s;
						rUFM_DLY_TIMER_EN		<=	1'b0;
					end
				end
				else begin
					rDBG_MSTR_SEQ_FSM_curr	<=	St_9_IDLE;
					rUFM_DLY_TIMER_EN		<=	1'b0;
				end
			end
			St_7_Standby_Ready: begin
				if (wPWRGD_AUX) begin
					if (wDLY_TIMEOUT) begin
						oP12V_AUX_FAN_EN		<= 	1'b1;
						oPWR_EN_Devices			<= 	1'b0;
						oP12V_NODEx_EN			<= 	1'b0;
						oP12V_N1_EN				<=	1'b0;
						oP12V_N2_EN				<=	1'b0;
						rDBG_MSTR_SEQ_FSM_curr	<=	St_5_FAN_on;
						
						rDLY_TIMER_EN			<=	1'b0;
					end
					else begin
						rDLY_TIMER_EN			<=	1'b1;
						rDLY_TIME				<=	dly_10ms;
						rUFM_DLY_TIMER_EN		<=	1'b0;
					end
				end
				else begin
				//	if(iPWR_P48V_FAULT) begin
						rDBG_MSTR_SEQ_FSM_curr	<=	St_7_Standby_Ready;
						rUFM_DLY_TIMER_EN		<=	1'b1;
				//	end
				//	else begin
				//		rDBG_MSTR_SEQ_FSM_curr	<=	St_f_Fault;
				//	end
				end
			end
			St_5_FAN_on: begin
				if (iPWRGD_P12V_AUX_FAN && !iDC_PWR_BTN_ON && wRMC_Enable) begin
					if (wDLY_TIMEOUT) begin
						oP12V_AUX_FAN_EN		<= 	1'b1;
						oPWR_EN_Devices			<= 	1'b1;
						oP12V_NODEx_EN			<= 	1'b1;
						oP12V_N1_EN				<=	1'b1;
						oP12V_N2_EN				<=	1'b1;
						rDBG_MSTR_SEQ_FSM_curr	<=	St_3_Devices_on;
					
						rDLY_TIMER_EN			<=	1'b0;
					end
					else begin
						rDLY_TIMER_EN			<=	1'b1;
						rDLY_TIME				<=	dly_10ms;
						rUFM_DLY_TIMER_EN		<=	1'b0;
					end
				end
				else if (!wLargeLeakage_N || !wSmallLeakage_N) begin
					rDBG_MSTR_SEQ_FSM_curr	<= St_e_Leakage;
				end
				else begin
					//if(iPWR_P48V_FAULT && iPWR_FAN_FAULT && oUFM_RUNTIME_FLT) begin
						rDBG_MSTR_SEQ_FSM_curr	<=	St_5_FAN_on;
						rUFM_DLY_TIMER_EN		<=	1'b1;
					//end
					//else begin
					//	rDBG_MSTR_SEQ_FSM_curr	<=	St_f_Fault;
					//end
				end
			end
			St_3_Devices_on: begin
				if (iPWRGD_P12V_Nodex) begin
					if (wDLY_TIMEOUT) begin
						oP12V_AUX_FAN_EN		<= 	1'b1;
						oPWR_EN_Devices			<= 	1'b1;
						oP12V_NODEx_EN			<= 	1'b1;
						oP12V_N1_EN				<=	1'b1;
						oP12V_N2_EN				<=	1'b1;
						rDBG_MSTR_SEQ_FSM_curr	<=	St_1_HOST_Ready;
					
						rDLY_TIMER_EN			<=	1'b0;
					end
					else begin
						rDLY_TIMER_EN			<=	1'b1;
						rDLY_TIME				<=	dly_150ms;
						rUFM_DLY_TIMER_EN		<=	1'b0;
					end
				end
				else if (!wLargeLeakage_N || !wSmallLeakage_N) begin
					rDBG_MSTR_SEQ_FSM_curr	<= St_e_Leakage;
				end
				else begin
					//if(wFault_N && oUFM_RUNTIME_FLT) begin
						rDBG_MSTR_SEQ_FSM_curr	<=	St_3_Devices_on;
						rUFM_DLY_TIMER_EN		<=	1'b1;
					//end
					//else begin
					//	rDBG_MSTR_SEQ_FSM_curr	<=	St_f_Fault;
					//end
				end
			end
			St_1_HOST_Ready: begin
				if ((wHost_PERST_NIC0 && wHost_PERST_NIC1 || iDC_PWR_BTN_ON || !wRMC_Enable)) begin
					if (wDLY_TIMEOUT) begin
						oP12V_AUX_FAN_EN		<= 	1'b1;
						oPWR_EN_Devices			<= 	1'b1;
						oP12V_NODEx_EN			<= 	1'b1;
						oP12V_N1_EN				<=	1'b1;
						oP12V_N2_EN				<=	1'b1;
						rDBG_MSTR_SEQ_FSM_curr	<=	St_0_S0;
					
						rDLY_TIMER_EN			<=	1'b0;
					end
					else begin
						rDLY_TIMER_EN			<=	1'b1;
						rDLY_TIME				<=	dly_0ms;
						rUFM_DLY_TIMER_EN		<=	1'b0;
					end
				end
				else if (!wLargeLeakage_N || !wSmallLeakage_N) begin
					rDBG_MSTR_SEQ_FSM_curr	<= St_e_Leakage;
				end
				else begin
					rDBG_MSTR_SEQ_FSM_curr	<=	St_1_HOST_Ready;
					rUFM_DLY_TIMER_EN		<=	1'b1;
				end
			end
			St_0_S0: begin
				if (iDC_PWR_BTN_ON || !wRMC_Enable) begin
					if (wDLY_TIMEOUT) begin
						oP12V_AUX_FAN_EN		<= 	1'b1;
						oPWR_EN_Devices			<= 	1'b0;
						oP12V_NODEx_EN			<= 	1'b0;
						oP12V_N1_EN				<=	1'b0;
						oP12V_N2_EN				<=	1'b0;
						rDBG_MSTR_SEQ_FSM_curr	<=	St_2_DC_off;
				
						rDLY_TIMER_EN			<=	1'b0;
					end
					else begin
						rDLY_TIMER_EN			<=	1'b1;
						rDLY_TIME				<=	dly_0ms;
						rUFM_DLY_TIMER_EN		<=	1'b0;
					end
				end
				else if (!wLargeLeakage_N || !wSmallLeakage_N) begin
					rDBG_MSTR_SEQ_FSM_curr	<= St_e_Leakage;
				end
				else begin
					//if(wFault_N && oUFM_RUNTIME_FLT) begin
						rDBG_MSTR_SEQ_FSM_curr	<=	St_0_S0;
						rUFM_DLY_TIMER_EN		<=	1'b0;
					//end
					//else begin
					//	rDBG_MSTR_SEQ_FSM_curr	<=	St_f_Fault;
					//end
				end
			end
			St_2_DC_off: begin
				if(!wLargeLeakage_N || !wSmallLeakage_N) begin
					rDBG_MSTR_SEQ_FSM_curr	<=	St_e_Leakage;
				end
				else if(!iDC_PWR_BTN_ON) begin
					rDBG_MSTR_SEQ_FSM_curr	<=	St_5_FAN_on;
				end
				else begin
					rDBG_MSTR_SEQ_FSM_curr	<=	St_2_DC_off;
				end
			end
			St_e_Leakage: begin
				oP12V_AUX_FAN_EN		<= 	1'b1;
				oPWR_EN_Devices			<= 	1'b0;
				oP12V_NODEx_EN			<= 	1'b0;
				oP12V_N1_EN				<=	1'b0;
				oP12V_N2_EN				<=	1'b0;
				rDBG_MSTR_SEQ_FSM_curr	<=	St_e_Leakage;
			end
			St_f_Fault: begin
				rDBG_MSTR_SEQ_FSM_curr	<= St_f_Fault;
			end
		endcase
	end
end

//	*********************************************************************
//	Platform Configuration
//	*********************************************************************
//	Configuration		| config[3] | config[2] | config[1] | config[0] |
//	--------------------|-----------|-----------|-----------|-----------|
//	Leading_POR			|     0     |     0     |     0     |     1     |
//	Initial_Bring_Up	|     0     |     0     |     1     |     0     |
//	Capacity_Driven		|     0     |     1     |     0     |     0     |
//	Safety_Driven		|     1     |     0     |     0     |     0     |

localparam	S1_Leading_POR		= 4'h1;
localparam	S2_Initial_Bring_Up	= 4'h2;
localparam	S4_Capacity_Driven	= 4'h4;
localparam	S8_Safety_Driven	= 4'h8;

dly_timer#
(
	.pulse_constant		(1'b1)	//1'b0 = pulse, 1'b1 = constant
)
mlargeleak_delay_timer
(
	.clk_in				(iClk_50ms),
	.iRst_n				(iRst_n),
	.iClear				(1'b1),
	.dly_timer_en		(iPWRGD_P12V_AUX && iLarge_Leak_Detect_N),
	.dly_timer_start	(1'b1),
	.dly_time			(16'd100),
	.dly_timeout		(wLargeLeakage_delay_N)
);

dly_timer#
(
	.pulse_constant		(1'b1)	//1'b0 = pulse, 1'b1 = constant
)
msmallleak_delay_timer
(
	.clk_in				(iClk_50ms),
	.iRst_n				(iRst_n),
	.iClear				(1'b1),
	.dly_timer_en		(iPWRGD_P12V_AUX && iSmall_Leak_Detect_N),
	.dly_timer_start	(1'b1),
	.dly_time			(16'd100),
	.dly_timeout		(wSmallLeakage_delay_N)
);

always @ (posedge iClk or negedge iRst_n) begin
	if(!iRst_n) begin
		rLargeLeakage_N			<=	~wLargeLeakage_delay_N;
		rSmallLeakage_N			<=	1'b1;
	end
	else begin
		case (iPlatform_Config)
			S1_Leading_POR: begin
				rLargeLeakage_N	<=	~wLargeLeakage_delay_N;
				rSmallLeakage_N	<=	1'b1;
			end
			S2_Initial_Bring_Up: begin
				rLargeLeakage_N	<=	1'b1;
				rSmallLeakage_N	<=	1'b1;
			end
			S4_Capacity_Driven: begin
				rLargeLeakage_N	<=	1'b1;
				rSmallLeakage_N	<=	1'b1;
			end
			S8_Safety_Driven: begin
				rLargeLeakage_N	<=	~wLargeLeakage_delay_N;
				rSmallLeakage_N	<=	~wSmallLeakage_delay_N;
			end
			default: begin
				rLargeLeakage_N	<=	~wLargeLeakage_delay_N;
				rSmallLeakage_N	<=	1'b1;
			end
		endcase
	end
end

dly_timer#
(
	.pulse_constant	(1'b0)	//1'b0 = pulse, 1'b1 = constant
)
mdly_timer
(
	.clk_in				(iClk_1ms),
	.iRst_n				(iRst_n),
	.iClear				(1'b1),
	.dly_timer_en		(rDLY_TIMER_EN),
	.dly_timer_start	(1'b1),
	.dly_time			(rDLY_TIME),
	.dly_timeout		(wDLY_TIMEOUT)
);

dly_timer#
(
	.pulse_constant		(1'b1)	//1'b0 = pulse, 1'b1 = constant
)
mufm_dly_timer
(
	.clk_in				(iClk_1ms),
	.iRst_n				(iRst_n),
	.iClear				(1'b1),
	.dly_timer_en		(rUFM_DLY_TIMER_EN),
	.dly_timer_start	(1'b1),
	.dly_time			(dly_10s),
	.dly_timeout		(wUFM_DLY_TIMEOUT)
);

Edge_Detector mufm_P12V_AUX_PWRGD_Edge_Detect
(
	.iClk					(iClk),
	.iClk_delay				(iClk_1ms),
	.iRst_n					(iRst_n),
	.iClear					(iPWRGD_P3V3_AUX),
	.iDelay_time			(16'd0),

	.pos_neg				(1'b0),
	.both					(1'b0),
	.input_sig				(iPWRGD_P12V_AUX),

	.output_pulse_sig		(),
	.output_constant_sig	(wUFM_P12V_AUX_PWRGD_constant_Edge_Detector)
);

Edge_Detector mufm_FAN_PWRGD_Edge_Detect
(
	.iClk					(iClk),
	.iClk_delay				(iClk_1ms),
	.iRst_n					(iRst_n),
	.iClear					(oP12V_AUX_FAN_EN),
	.iDelay_time			(16'd0),

	.pos_neg				(1'b0),
	.both					(1'b0),
	.input_sig				(iPWRGD_P12V_AUX_FAN),

	.output_pulse_sig		(),
	.output_constant_sig	(wUFM_FAN_PWRGD_constant_Edge_Detector)
);

Edge_Detector mufm_N1N2_PWRGD_Edge_Detect
(
	.iClk					(iClk),
	.iClk_delay				(iClk_1ms),
	.iRst_n					(iRst_n),
	.iClear					(!iDC_PWR_BTN_ON),
	.iDelay_time			(16'd0),

	.pos_neg				(1'b0),
	.both					(1'b0),
	.input_sig				(iPWRGD_P12V_Nodex),

	.output_pulse_sig		(),
	.output_constant_sig	(wUFM_N1N2_PWRGD_constant_Edge_Detector)
);

endmodule