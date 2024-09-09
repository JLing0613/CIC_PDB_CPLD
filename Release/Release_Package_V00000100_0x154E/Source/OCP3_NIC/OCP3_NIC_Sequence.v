
module OCP3_NIC_Sequence
	(
	//	Input reference signal
	input	wire	iClk,		//Moudle reference clock: 2MHz.
	input	wire	iClk_1ms,	//Delay timer reference clock: 1MHz.
	input	wire	iRst_n,		//System asynchronous reset.

	//	OCP3 NIC card sideband control
	input	wire	iPRSNT_NIC_N,
	input	wire	iPWRGD_NIC_EDGE,
	output	reg		oNIC_AUX_PWR_EN,
	input	wire	iPWRGD_NIC_PWR_GOOD,
	output	reg		oNIC_MAIN_PWR_EN,
	output	wire	oRST_NIC_PERST_N,

	//	Device sideband control
	input	wire	iPWR_EN_DEV,

	//	Debug state machine register
	output	wire	[3:0] oDBG_OCP3_NIC_FSM_curr,
	output	wire	[3:0] oDBG_OCP3_NIC_FSM_prev
	
	);

	//	Parameter of state machine
	localparam	S0_IDLE								= 4'b0000;
	localparam	S1_AUX_Power_Mode_Transition_ON		= 4'b0001;
	localparam	S2_AUX_Power_Mode_ON				= 4'b0010;
	localparam	S3_Main_Power_Mode_Transition_ON    = 4'b0011;
	localparam	S4_Main_Power_Mode					= 4'b0100;
	localparam	S5_Main_Power_Mode_Transition_OFF	= 4'b0101;
	localparam	S6_AUX_Power_Mode_Transition_OFF	= 4'b0110;
	localparam	S7_AUX_Power_Mode_OFF				= 4'b0111;
	localparam	S8_NIC_Power_OFF					= 4'b1000;

	//	Parameter of delay time
	localparam	dly_0ms			= 16'd0	;		// 1ms x 0    = 0ms
	localparam	dly_1ms			= 16'd1	;		// 1ms x 1    = 1ms
	localparam	dly_21ms		= 16'd21;		// 1ms x 21   = 21ms
	localparam	dly_105ms		= 16'd105;		// 1ms x 105  = 105ms	
	localparam	dly_1050ms		= 16'd1050;		// 1ms x 1050 = 1.050s
	
	//	Internal declarations
	wire	wDLY_TIMEOUT;
	wire 	wPWR_EN_NIC;

	//wire [3:0] NIC_prev_state_0;
	//wire [3:0] NIC_prev_state_1;
	wire [3:0] NIC_prev_state_2;
	wire [3:0] NIC_current_state;

	reg		state_change;

	reg		rDLY_TIMER_EN;
	reg		[15:0]	rDLY_TIME;
	reg 	rRST_NIC_PERST_N;

	reg		[3:0] rDBG_OCP3_NIC_FSM_curr;
	reg		[3:0] rDBG_OCP3_NIC_FSM_prev;

	//	Instances
	assign	oRST_NIC_PERST_N = rRST_NIC_PERST_N;
	assign	wPWR_EN_NIC = iPWR_EN_DEV;

	assign	oDBG_OCP3_NIC_FSM_curr = NIC_current_state;
	assign	oDBG_OCP3_NIC_FSM_prev = NIC_prev_state_2;

	always @ (posedge iClk or negedge iRst_n)
		begin
			if(!iRst_n)
				begin
					rDBG_OCP3_NIC_FSM_curr	<=	S0_IDLE;
					oNIC_AUX_PWR_EN			<=	1'b0;	
					oNIC_MAIN_PWR_EN		<=	1'b0;
					rRST_NIC_PERST_N		<=	1'b0;
					rDLY_TIMER_EN 			<= 	1'b0;
					rDLY_TIME 				<=	dly_0ms;
					state_change			<=	1'b1;
				end
			else
				begin
					case (rDBG_OCP3_NIC_FSM_curr)
						S0_IDLE:
							begin
								if (!iPRSNT_NIC_N) 
									begin
										if (wDLY_TIMEOUT)
											begin
												rDLY_TIMER_EN			<=	1'b0;
												rDBG_OCP3_NIC_FSM_curr	<=	S1_AUX_Power_Mode_Transition_ON;
											end
										else
											begin
												rDLY_TIMER_EN			<=	1'b1;
												rDLY_TIME				<=	dly_105ms;
											end
									end
								else
									begin
										oNIC_AUX_PWR_EN					<=	1'b0;		
										oNIC_MAIN_PWR_EN				<=	1'b0;	
										rRST_NIC_PERST_N				<=	1'b0;
										rDBG_OCP3_NIC_FSM_curr			<=	S0_IDLE;
									end
							end

						S1_AUX_Power_Mode_Transition_ON:
							begin
								if (iPWRGD_NIC_EDGE)
									begin
										if (wDLY_TIMEOUT)
											begin
												oNIC_AUX_PWR_EN			<=	1'b1;
												rDLY_TIMER_EN			<=	1'b0;
												rDBG_OCP3_NIC_FSM_curr	<=	S2_AUX_Power_Mode_ON;
											end
										else
											begin
												rDLY_TIMER_EN			<=	1'b1;
												rDLY_TIME				<=	dly_21ms;
											end
									end
								else
									begin
										rDBG_OCP3_NIC_FSM_curr			<=	S1_AUX_Power_Mode_Transition_ON;
									end
							end
							
						S2_AUX_Power_Mode_ON:
							begin
								if (iPWRGD_NIC_PWR_GOOD && wPWR_EN_NIC)
									begin
										if (wDLY_TIMEOUT)
											begin
												oNIC_MAIN_PWR_EN		<=	1'b1;
												rDLY_TIMER_EN			<=	1'b0;
												rDBG_OCP3_NIC_FSM_curr	<=	S3_Main_Power_Mode_Transition_ON;
											end
										else
											begin
												rDLY_TIMER_EN			<=	1'b1;
												rDLY_TIME				<=	dly_0ms;
											end
									end
								else
									begin
										rDBG_OCP3_NIC_FSM_curr			<=	S2_AUX_Power_Mode_ON;
									end
							end
							
						S3_Main_Power_Mode_Transition_ON:
							begin
								if (wDLY_TIMEOUT)
									begin
										rRST_NIC_PERST_N 				<=	1'b1;
										rDLY_TIMER_EN					<=	1'b0;
										rDBG_OCP3_NIC_FSM_curr			<=	S4_Main_Power_Mode;
									end
								else
									begin
										rDLY_TIMER_EN					<=	1'b1;
										rDLY_TIME						<=	dly_1050ms;
									end
							end
							
						S4_Main_Power_Mode:
							begin
								if ( !wPWR_EN_NIC )	
									begin
										if (wDLY_TIMEOUT)
											begin
												rRST_NIC_PERST_N 		<=	1'b0;
												rDLY_TIMER_EN			<=	1'b0;
												rDBG_OCP3_NIC_FSM_curr	<=	S5_Main_Power_Mode_Transition_OFF;
											end
										else
											begin
												rDLY_TIMER_EN			<=	1'b1;
												rDLY_TIME				<=	dly_0ms;
											end
									end
								else
									begin
										rDLY_TIMER_EN					<=	1'b0;
										rDBG_OCP3_NIC_FSM_curr			<=	S4_Main_Power_Mode;
									end
							end
						
						S5_Main_Power_Mode_Transition_OFF:
							begin
								if (wDLY_TIMEOUT)
									begin
										oNIC_MAIN_PWR_EN 				<=	1'b0;
										rDLY_TIMER_EN					<=	1'b0;
										rDBG_OCP3_NIC_FSM_curr			<=	S8_NIC_Power_OFF;
									end
								else
									begin
										rDLY_TIMER_EN					<=	1'b1;
										rDLY_TIME						<=	dly_1ms;
									end
							end
						
						S6_AUX_Power_Mode_Transition_OFF:
							begin
								if (wDLY_TIMEOUT)
									begin
										oNIC_AUX_PWR_EN 				<=	1'b0;
										rDLY_TIMER_EN					<=	1'b0;
										rDBG_OCP3_NIC_FSM_curr			<=	S7_AUX_Power_Mode_OFF;
									end
								else
									begin
										rDLY_TIMER_EN					<=	1'b1;
										rDLY_TIME						<=	dly_1ms;
									end
							end
						
						S7_AUX_Power_Mode_OFF:
							begin
								if ( !iPWRGD_NIC_PWR_GOOD ) 
									begin
										rDBG_OCP3_NIC_FSM_curr			<=	S8_NIC_Power_OFF;
									end		
								else
									begin
										rDBG_OCP3_NIC_FSM_curr			<=	S7_AUX_Power_Mode_OFF;
									end
							end
						
						S8_NIC_Power_OFF:
							begin
								if ( wPWR_EN_NIC )
									begin
										rDBG_OCP3_NIC_FSM_curr			<=	S2_AUX_Power_Mode_ON;
									end
								else
									begin
										rDBG_OCP3_NIC_FSM_curr			<=	S8_NIC_Power_OFF;
									end
							end
						
					endcase
				end

			if (iPRSNT_NIC_N) 
				begin
					rDBG_OCP3_NIC_FSM_curr	<=	S0_IDLE;
				end
	end

	State_Logger_4bit NIC_Seq_State_Log
	(
		.iClk							(iClk),
		.iRst_n							(iRst_n),

		.iDbgSt							(rDBG_OCP3_NIC_FSM_curr),

		.prev_state_0					(),
		.prev_state_1					(),
		.prev_state_2					(NIC_prev_state_2),
		.current_state					(NIC_current_state)
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