
module MSTR_SEQ
	(
		//	Input reference signal
		input	wire	iClk,		//Moudle reference clock: 2MHz.
		input	wire	iClk_1ms,	//Delay timer reference clock: 1MHz.
		input	wire	iRst_n,		//System asynchronous reset.

		input	wire	iPWRGD_P3V3_AUX,
		input	wire	iPWRGD_P12V_AUX,
		input	wire	iRMC_PWR_Enable,
		input	wire	iLarge_Leak_Detect_N,
		input	wire	iSmall_Leak_Detect_N,
		input	wire	iLatch_Clear,
		input	wire	[3:0]	iPlaform_Config,

		output	reg		oP12V_AUX_FAN_EN,
		input	wire	iPWRGD_P12V_AUX_FAN,

		output	reg		oPWR_EN_Devices,
		input	wire	iNIC_STBY_PWR_OK,
		input	wire	iNIC_MAIN_PWR_OK,
		
		output	reg		oP12V_NODEx_EN,
		input	wire	iPWRGD_P12V_Nodex,
		
		input	wire	iDC_PWR_BTN_ON,
		input	wire	iPWR_P48V_FAULT,
		input	wire	iPWR_FAN_FAULT,
		input	wire	iPWR_NIC0_FAULT,
		input	wire 	iPWR_NIC1_FAULT,
		
		input	wire	iLeakage_BMC_ready,
		input	wire	iFault_BMC_ready,

		//	Debug state machine register
		output	wire	[3:0] oDBG_MSTR_SEQ_FSM_prev0,
		output	wire	[3:0] oDBG_MSTR_SEQ_FSM_prev1,
		output	wire	[3:0] oDBG_MSTR_SEQ_FSM_prev2,
		output	wire	[3:0] oDBG_MSTR_SEQ_FSM_curr
	);

	//	Parameter of state machine
	localparam	S0_IDLE				= 4'h0;		//	Idle
	localparam	S1_FAN_on			= 4'h1;		//	FAN on
	localparam	S2_N1_N2_NIC_on		= 4'h2;		//	N1 & N2 & NIC on
	localparam	S3_transition_on	= 4'h3;		//	N1 & N2 & NIC on
	localparam	S4_S0				= 4'h4;		//	Done
	localparam	S5_N1_N2_NIC_off	= 4'h5;		//	N1 & N2 & NIC off
	localparam	S6_DC_off			= 4'h6;		//	FAN off
	localparam	S7_Fault			= 4'h7;		//	Fault
	localparam	S8_Leakage			= 4'h8;		//	Leakage
	localparam	S9_PDB_Latch		= 4'h9;		//	RMC_Enable_loss_latch
	
	localparam	S0_Leading_POR		= 4'h0;
	localparam	S1_Initial_Bring_Up	= 4'h1;
	localparam	S2_Capacity_Driven	= 4'h2;
	localparam	S3_Safety_Driven	= 4'h3;
	
	//	Parameter of delay time
	localparam	dly_0ms				= 16'd0;		// 1ms x 0    	= 0ms
	localparam	dly_1ms				= 16'd1;		// 1ms x 1    	= 1ms
	localparam	dly_10ms			= 16'd10;		// 1ms x 10   	= 10ms
	localparam	dly_20ms			= 16'd20;		// 1ms x 20   	= 20ms
	localparam	dly_150ms			= 16'd150;		// 1ms x 150   	= 150ms
	localparam	dly_1s				= 16'd1000;		// 1ms x 1000	= 1s
	localparam	dly_5s				= 16'd5000;		// 1ms x 1000	= 5s
	localparam	dly_10s				= 16'd10000;	// 1ms x 1000	= 1min
	
	//	Internal declarations
	wire	wDLY_TIMEOUT;
	wire	wPWRGD_AUX;
	wire	wRackLeakage;
	wire	wLargeLeakage_N;
	wire	wSmallLeakage_N;
	reg		rLargeLeakage_N;
	reg		rSmallLeakage_N;
	wire	wFault_N;

	wire	[3:0] Mstr_prev_state_1;
	wire	[3:0] Mstr_prev_state_0;
	wire	[3:0] Mstr_prev_state_2;
	wire	[3:0] Mstr_current_state;

	reg		rFault_BMC_ready;
	reg		rLeakage_BMC_ready;
	reg		rDLY_TIMER_EN;
	reg		[15:0]	rDLY_TIME;
	reg		[3:0] rPlatform_Config;
	reg		[3:0] rDBG_MSTR_SEQ_FSM_curr;

	//	Instances
	assign	wPWRGD_AUX 		=	iPWRGD_P3V3_AUX & iPWRGD_P12V_AUX;
	assign	wRackLeakage	=	iRMC_PWR_Enable;// ~iLeakage_BMC_ready & iRMC_PWR_Enable;
	assign	wLargeLeakage_N =	rLargeLeakage_N;// ~iLeakage_BMC_ready & rLargeLeakage_N;
	assign	wSmallLeakage_N	=	rSmallLeakage_N;// ~iLeakage_BMC_ready & rSmallLeakage_N;
	assign	wFault_N		=	iPWR_P48V_FAULT & iPWR_FAN_FAULT & iPWR_NIC0_FAULT & iPWR_NIC1_FAULT;// ~iFault_BMC_ready & iPWR_P48V_FAULT & iPWR_FAN_FAULT & iPWR_NIC0_FAULT & iPWR_NIC1_FAULT;

	assign	oDBG_MSTR_SEQ_FSM_prev0	=	Mstr_prev_state_0;
	assign	oDBG_MSTR_SEQ_FSM_prev1	=	Mstr_prev_state_1;
	assign	oDBG_MSTR_SEQ_FSM_prev2	=	Mstr_prev_state_2;
	assign	oDBG_MSTR_SEQ_FSM_curr	=	Mstr_current_state;

	//always @ (posedge iLeakage_BMC_read_ready)
	//	begin
	//		rLeakage_BMC_ready <= 1'b1;
	//	end
	//
	//always @ (posedge iFault_BMC_read_ready)
	//	begin
	//		rFault_BMC_ready <= 1'b1;
	//	end

	always @ (posedge iClk or negedge iRst_n)
		begin
			if(!iRst_n)
				begin
					rDBG_MSTR_SEQ_FSM_curr	<=	S0_IDLE;
					oP12V_AUX_FAN_EN		<= 	1'b0;
					oPWR_EN_Devices			<= 	1'b0;
					oP12V_NODEx_EN			<= 	1'b0;
					rDLY_TIMER_EN 			<= 	1'b0;
					rDLY_TIME 				<=	dly_0ms;
				end
			else
				begin
					case (rDBG_MSTR_SEQ_FSM_curr)
						S0_IDLE:
							begin
								if (iPWRGD_P3V3_AUX)  
									begin
										if (wDLY_TIMEOUT)
											begin
												rDLY_TIMER_EN			<=	1'b0;
												oP12V_AUX_FAN_EN		<= 	1'b0;
												oPWR_EN_Devices			<= 	1'b0;
												oP12V_NODEx_EN			<= 	1'b0;
												rDBG_MSTR_SEQ_FSM_curr	<=	S1_FAN_on;
											end
										else
											begin
												rDLY_TIMER_EN			<=	1'b1;
												rDLY_TIME				<=	dly_5s;
											end
									end
								else
									begin
										rDBG_MSTR_SEQ_FSM_curr	<=	S0_IDLE;
									end
							end

						S1_FAN_on:
							begin
								if (wPWRGD_AUX && wLargeLeakage_N && wSmallLeakage_N && iPWR_P48V_FAULT)
									begin
										if (wDLY_TIMEOUT)
											begin
												rDLY_TIMER_EN			<=	1'b0;
												oP12V_AUX_FAN_EN		<= 	1'b1;
												oPWR_EN_Devices			<= 	1'b0;
												oP12V_NODEx_EN			<= 	1'b0;
												rDBG_MSTR_SEQ_FSM_curr	<=	S2_N1_N2_NIC_on;
											end
										else
											begin
												rDLY_TIMER_EN			<=	1'b1;
												rDLY_TIME				<=	dly_1ms;
											end
									end
								else if (!wLargeLeakage_N || !wSmallLeakage_N)
									begin
										oP12V_AUX_FAN_EN		<= 	1'b1;
										oPWR_EN_Devices			<= 	1'b0;
										oP12V_NODEx_EN			<= 	1'b0;
										rDBG_MSTR_SEQ_FSM_curr	<= S6_DC_off;
									end
								else
									begin
										if(iPWR_P48V_FAULT)
											begin
												rDBG_MSTR_SEQ_FSM_curr	<=	S1_FAN_on;
											end
										else
											begin
												rDBG_MSTR_SEQ_FSM_curr	<=	S7_Fault;
											end
									end
							end

						S2_N1_N2_NIC_on:
							begin
								if (iPWRGD_P12V_AUX_FAN /*&& !iDC_PWR_BTN_ON*/ && wLargeLeakage_N && wSmallLeakage_N && wRackLeakage)
									begin
										if (wDLY_TIMEOUT)
											begin
												rDLY_TIMER_EN			<=	1'b0;
												oP12V_AUX_FAN_EN		<= 	1'b1;
												oPWR_EN_Devices			<= 	1'b1;
												oP12V_NODEx_EN			<= 	1'b1;
												rDBG_MSTR_SEQ_FSM_curr	<=	S3_transition_on;
											end
										else
											begin
												rDLY_TIMER_EN			<=	1'b1;
												rDLY_TIME				<=	dly_10ms;
											end
									end
								else if (!wLargeLeakage_N || !wSmallLeakage_N)
									begin
										oP12V_AUX_FAN_EN		<= 	1'b1;
										oPWR_EN_Devices			<= 	1'b0;
										oP12V_NODEx_EN			<= 	1'b0;
										rDBG_MSTR_SEQ_FSM_curr	<= S6_DC_off;
									end
								else
									begin
										rDBG_MSTR_SEQ_FSM_curr	<=	S2_N1_N2_NIC_on;
									end
							end
						
						S3_transition_on:
							begin
								if (iPWRGD_P12V_Nodex && wLargeLeakage_N && wSmallLeakage_N)
									begin
										if (wDLY_TIMEOUT)
											begin
												rDLY_TIMER_EN			<=	1'b0;
												oP12V_AUX_FAN_EN		<= 	1'b1;
												oPWR_EN_Devices			<= 	1'b1;
												oP12V_NODEx_EN			<= 	1'b1;
												rDBG_MSTR_SEQ_FSM_curr	<=	S4_S0;
											end
										else
											begin
												rDLY_TIMER_EN			<=	1'b1;
												rDLY_TIME				<=	dly_150ms;
											end
									end
								else if (!wLargeLeakage_N || !wSmallLeakage_N)
									begin
										oP12V_AUX_FAN_EN		<= 	1'b1;
										oPWR_EN_Devices			<= 	1'b0;
										oP12V_NODEx_EN			<= 	1'b0;
										rDBG_MSTR_SEQ_FSM_curr	<= S6_DC_off;
									end
								else
									begin
										rDBG_MSTR_SEQ_FSM_curr	<=	S3_transition_on;
									end
							end
						
						S4_S0:
							begin
								if (/*iDC_PWR_BTN_ON || */!wLargeLeakage_N || !wSmallLeakage_N || !wRackLeakage)
									begin
										if (wDLY_TIMEOUT)
											begin
												rDLY_TIMER_EN			<=	1'b0;
												oP12V_AUX_FAN_EN		<= 	1'b1;
												oPWR_EN_Devices			<= 	1'b0;
												oP12V_NODEx_EN			<= 	1'b0;
												rDBG_MSTR_SEQ_FSM_curr	<=	S5_N1_N2_NIC_off;
											end
										else
											begin
												rDLY_TIMER_EN			<=	1'b1;
												rDLY_TIME				<=	dly_10ms;
											end
									end
								else
									begin
										//if(wFault_N)
										//	begin
												rDBG_MSTR_SEQ_FSM_curr	<=	S4_S0;
										//	end
										//else
										//	begin
										//		rDBG_MSTR_SEQ_FSM_curr	<=	S7_Fault;
										//	end
									end
							end
							
						S5_N1_N2_NIC_off:
							begin
								if (!iPWRGD_P12V_Nodex)
									begin
										if (wDLY_TIMEOUT)
											begin
												rDLY_TIMER_EN			<=	1'b0;
												oP12V_AUX_FAN_EN		<= 	1'b1;
												oPWR_EN_Devices			<= 	1'b0;
												oP12V_NODEx_EN			<= 	1'b0;
												rDBG_MSTR_SEQ_FSM_curr	<=	S6_DC_off;
											end
										else
											begin
												rDLY_TIMER_EN			<=	1'b1;
												rDLY_TIME				<=	dly_1ms;
											end
									end
								else
									begin
										//if(wFault_N)
										//	begin
												rDBG_MSTR_SEQ_FSM_curr	<=	S5_N1_N2_NIC_off;
										//	end
										//else
										//	begin
										//		rDBG_MSTR_SEQ_FSM_curr	<=	S7_Fault;
										//	end
									end
							end

						S6_DC_off:
							begin
								if(!wRackLeakage)
									begin
										rDBG_MSTR_SEQ_FSM_curr	<=	S9_PDB_Latch;
									end
								else if(!wLargeLeakage_N || !wSmallLeakage_N)
									begin
										rDBG_MSTR_SEQ_FSM_curr	<=	S8_Leakage;
									end
								//else if(!wFault_N)
								//	begin
								//		rDBG_MSTR_SEQ_FSM_curr	<=	S7_Fault;
								//	end
								else if(!iDC_PWR_BTN_ON)
									begin
										rDBG_MSTR_SEQ_FSM_curr	<=	S2_N1_N2_NIC_on;
									end
								else
									begin
										rDBG_MSTR_SEQ_FSM_curr	<=	S6_DC_off;
									end
							end
						
						S7_Fault:
							begin
								rDBG_MSTR_SEQ_FSM_curr	<= S7_Fault;
							end

						S8_Leakage:
							begin
								if (wLargeLeakage_N && wSmallLeakage_N)
									begin
										rDBG_MSTR_SEQ_FSM_curr	<=	S2_N1_N2_NIC_on;
									end
								else
									begin
										rDBG_MSTR_SEQ_FSM_curr	<=	S8_Leakage;
									end
							end

						S9_PDB_Latch:
							begin
								if(iLatch_Clear)
									begin
										rDBG_MSTR_SEQ_FSM_curr	<=	S2_N1_N2_NIC_on;
									end
								else
									begin
										rDBG_MSTR_SEQ_FSM_curr	<=	S9_PDB_Latch;
									end
							end
					endcase
				end
	end

	//	*********************************************************************
	//	Platform Configuration
	//	*********************************************************************
	//	Configuration		| config[3] | config[2] | config[1] | config[0] |
	//	--------------------|-----------|-----------|-----------|-----------|
	//	Leading_POR			|     0     |     0     |     0     |     0     |
	//	Initial_Bring_Up	|     0     |     0     |     0     |     1     |
	//	Capacity_Driven		|     0     |     0     |     1     |     0     |
	//	Safety_Driven		|     0     |     0     |     1     |     1     |

	always @ (posedge iClk or negedge iRst_n)
		begin
			if(!iRst_n)
				begin
					rPlatform_Config		<=	S0_Leading_POR;
					rLargeLeakage_N			<=	1'b1;
					rSmallLeakage_N			<=	1'b1;
				end
			else
				begin
					case (rPlatform_Config)
						S0_Leading_POR:
							begin
								rLargeLeakage_N	<=	iLarge_Leak_Detect_N;
								rSmallLeakage_N	<=	1'b1;
							end
						S1_Initial_Bring_Up:
							begin
								rLargeLeakage_N	<=	1'b1;
								rSmallLeakage_N	<=	1'b1;
							end
						S2_Capacity_Driven:
							begin
								rLargeLeakage_N	<=	1'b1;
								rSmallLeakage_N	<=	1'b1;
							end
						S3_Safety_Driven:
							begin
								rLargeLeakage_N	<=	iLarge_Leak_Detect_N;
								rSmallLeakage_N	<=	iSmall_Leak_Detect_N;
							end
					endcase
				end
		end

	State_Logger_4bit Mstr_Seq_State_Log
	(
		.iClk							(iClk),
		.iRst_n							(iRst_n),
		.iClear							(1'b0),

		.iDbgSt							(rDBG_MSTR_SEQ_FSM_curr),

		.prev_state_0					(Mstr_prev_state_0),
		.prev_state_1					(Mstr_prev_state_1),
		.prev_state_2					(Mstr_prev_state_2),
		.current_state					(Mstr_current_state)
	);

	dly_timer mdly_timer
	(
		.clk_in			(iClk_1ms),
		.iRst_n			(iRst_n),
		.dly_timer_en	(rDLY_TIMER_EN),
		.dly_time		(rDLY_TIME),
		.dly_timeout	(wDLY_TIMEOUT)
	);

endmodule