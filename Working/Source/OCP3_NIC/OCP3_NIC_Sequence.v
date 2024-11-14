
module OCP3_NIC_Sequence
(
	//	Input reference signal
	input	wire	iClk,		//Moudle reference clock: 2MHz.
	input	wire	iClk_1ms,	//Delay timer reference clock: 1MHz.
	input	wire	iRst_n,		//System asynchronous reset.
	
	//	OCP3 NIC card sideband control
	input	wire	iPRSNT_NIC_N,
	input	wire	iPG_P3V3_AUX,
	input	wire	iPG_P12V_AUX,
	input	wire	iPWRGD_NIC_EDGE,
	output	reg		oNIC_AUX_PWR_EN,
	input	wire	iPWRGD_NIC_PWR_GOOD,
	output	reg		oNIC_MAIN_PWR_EN,
	output	wire	oRST_NIC_PERST_N,
	
	//	Device sideband control
	input	wire	iPWR_EN_DEV,

	//	Debug state machine register
	output	wire	[3:0] oDBG_OCP3_NIC_FSM_curr,

	output	wire	oAUX_SEQPWR_FLT,
	output	wire	oP12V_SEQPWR_FLT,
	output	wire	oAUX_RUNTIME_FLT,
	output	wire	oP12V_RUNTIME_FLT
);
	
//	Parameter of state machine
localparam	St_0_IDLE							= 4'h7;
localparam	St_1_AUX_Power_Mode_Transition_ON	= 4'h5;
localparam	St_2_AUX_Power_Mode_ON				= 4'h3;
localparam	St_3_Main_Power_Mode_Transition_ON  = 4'h1;
localparam	St_4_Main_Power_Mode				= 4'h0;
localparam	St_5_Main_Power_Mode_Transition_OFF	= 4'h2;
localparam	St_6_AUX_Power_Mode_Transition_OFF	= 4'h4;
localparam	St_7_AUX_Power_Mode_OFF				= 4'h6;
localparam	St_8_NIC_Power_OFF					= 4'h8;
localparam	St_f_Fault							= 4'hf;

//	Parameter of delay time
localparam	dly_0ms			= 16'd0	;		// 1ms x 0    = 0ms
localparam	dly_1ms			= 16'd1	;		// 1ms x 1    = 1ms
localparam	dly_21ms		= 16'd21;		// 1ms x 21   = 21ms
localparam	dly_105ms		= 16'd105;		// 1ms x 105  = 105ms	
localparam	dly_1050ms		= 16'd1050;		// 1ms x 1050 = 1.050s
	
//	Internal declarations
wire	wDLY_TIMEOUT;
wire	wUFM_DLY_TIMEOUT;
wire 	wPWR_EN_NIC;

wire	wUFM_NIC_PWRGD_constant_Edge_Detector;
wire	wUFM_AUX_PWRGD_constant_Edge_Detector;

reg		rDLY_TIMER_EN;
reg		rUFM_DLY_TIMER_EN;
reg		[15:0]	rDLY_TIME;
reg 	rRST_NIC_PERST_N;

reg		[3:0] rDBG_OCP3_NIC_FSM_curr;

//	Instances
assign	oRST_NIC_PERST_N		=	rRST_NIC_PERST_N;
assign	wPWR_EN_NIC				=	iPWR_EN_DEV;

assign	oDBG_OCP3_NIC_FSM_curr	=	rDBG_OCP3_NIC_FSM_curr;

assign	oAUX_SEQPWR_FLT			=	(wUFM_DLY_TIMEOUT && oDBG_OCP3_NIC_FSM_curr == St_1_AUX_Power_Mode_Transition_ON) ? 0 : 1;
assign	oP12V_SEQPWR_FLT		=	(wUFM_DLY_TIMEOUT && oDBG_OCP3_NIC_FSM_curr == St_2_AUX_Power_Mode_ON) ? 0 : 1;
assign	oAUX_RUNTIME_FLT		=	(wUFM_AUX_PWRGD_constant_Edge_Detector) ? 0 : 1;
assign	oP12V_RUNTIME_FLT		=	(wUFM_NIC_PWRGD_constant_Edge_Detector) ? 0 : 1;

always @ (posedge iClk or negedge iRst_n) begin
	if(!iRst_n) begin
		rDBG_OCP3_NIC_FSM_curr	<=	St_0_IDLE;
		oNIC_AUX_PWR_EN			<=	1'b0;	
		oNIC_MAIN_PWR_EN		<=	1'b0;
		rRST_NIC_PERST_N		<=	1'b0;

		rDLY_TIMER_EN 			<= 	1'b0;
		rDLY_TIME 				<=	dly_0ms;
		rUFM_DLY_TIMER_EN		<=	1'b0;
	end

	else begin
		case (rDBG_OCP3_NIC_FSM_curr)
			St_0_IDLE: begin
				if (!iPRSNT_NIC_N && iPG_P3V3_AUX) begin
					if (wDLY_TIMEOUT) begin
						rDLY_TIMER_EN			<=	1'b0;
						rDBG_OCP3_NIC_FSM_curr	<=	St_1_AUX_Power_Mode_Transition_ON;
					end
					else begin
						rDLY_TIMER_EN			<=	1'b1;
						rDLY_TIME				<=	dly_105ms;
						rUFM_DLY_TIMER_EN		<=	1'b0;
					end
				end
				else begin
					oNIC_AUX_PWR_EN				<=	1'b0;		
					oNIC_MAIN_PWR_EN			<=	1'b0;	
					rRST_NIC_PERST_N			<=	1'b0;
					rDBG_OCP3_NIC_FSM_curr		<=	St_0_IDLE;
					rUFM_DLY_TIMER_EN			<=	1'b0;
				end
			end
			St_1_AUX_Power_Mode_Transition_ON: begin
				if (iPWRGD_NIC_EDGE) begin
					if (wDLY_TIMEOUT) begin
						oNIC_AUX_PWR_EN			<=	1'b1;
						rDLY_TIMER_EN			<=	1'b0;
						rDBG_OCP3_NIC_FSM_curr	<=	St_2_AUX_Power_Mode_ON;
					end
					else begin
						rDLY_TIMER_EN			<=	1'b1;
						rDLY_TIME				<=	dly_21ms;
						rUFM_DLY_TIMER_EN		<=	1'b0;
					end
				end
				else begin
					rDBG_OCP3_NIC_FSM_curr		<=	St_1_AUX_Power_Mode_Transition_ON;
					rUFM_DLY_TIMER_EN			<=	1'b1;
				end
			end
			St_2_AUX_Power_Mode_ON: begin
				if (iPWRGD_NIC_PWR_GOOD && wPWR_EN_NIC) begin
					if (wDLY_TIMEOUT) begin
						oNIC_MAIN_PWR_EN		<=	1'b1;
						rDLY_TIMER_EN			<=	1'b0;
						rDBG_OCP3_NIC_FSM_curr	<=	St_3_Main_Power_Mode_Transition_ON;
					end
					else begin
						rDLY_TIMER_EN			<=	1'b1;
						rDLY_TIME				<=	dly_0ms;
						rUFM_DLY_TIMER_EN		<=	1'b0;
					end
				end
				else begin
					rDBG_OCP3_NIC_FSM_curr		<=	St_2_AUX_Power_Mode_ON;
					rUFM_DLY_TIMER_EN			<=	1'b1;
				end
			end
			St_3_Main_Power_Mode_Transition_ON: begin
				if (wDLY_TIMEOUT) begin
					rRST_NIC_PERST_N 			<=	1'b1;
					rDLY_TIMER_EN				<=	1'b0;
					rDBG_OCP3_NIC_FSM_curr		<=	St_4_Main_Power_Mode;
				end
				else if(0/*!oP12V_RUNTIME_FLT || !oAUX_RUNTIME_FLT*/) begin
					rDBG_OCP3_NIC_FSM_curr		<=	St_f_Fault;
				end
				else begin
					rDLY_TIMER_EN				<=	1'b1;
					rDLY_TIME					<=	dly_1050ms;
					rUFM_DLY_TIMER_EN			<=	1'b0;
				end
			end
			St_4_Main_Power_Mode: begin
				if (!wPWR_EN_NIC) begin
					if (wDLY_TIMEOUT) begin
						rRST_NIC_PERST_N 		<=	1'b0;
						rDLY_TIMER_EN			<=	1'b0;
						rDBG_OCP3_NIC_FSM_curr	<=	St_5_Main_Power_Mode_Transition_OFF;
					end
					else begin
						rDLY_TIMER_EN			<=	1'b1;
						rDLY_TIME				<=	dly_0ms;
						rUFM_DLY_TIMER_EN		<=	1'b0;
					end
				end
				else begin
					if(oP12V_RUNTIME_FLT || oAUX_RUNTIME_FLT) begin
						rDLY_TIMER_EN			<=	1'b0;
						rDBG_OCP3_NIC_FSM_curr	<=	St_4_Main_Power_Mode;
						rUFM_DLY_TIMER_EN		<=	1'b1;
					end
					else begin
						rDBG_OCP3_NIC_FSM_curr	<=	St_f_Fault;
					end
				end
			end
			St_5_Main_Power_Mode_Transition_OFF: begin
				if (wDLY_TIMEOUT) begin
					oNIC_MAIN_PWR_EN 			<=	1'b0;
					rDLY_TIMER_EN				<=	1'b0;
					rDBG_OCP3_NIC_FSM_curr		<=	St_8_NIC_Power_OFF;
				end
				else if(0/*!oP12V_RUNTIME_FLT || !oAUX_RUNTIME_FLT*/) begin
					rDBG_OCP3_NIC_FSM_curr		<=	St_f_Fault;
				end
				else begin
					rDLY_TIMER_EN				<=	1'b1;
					rDLY_TIME					<=	dly_1ms;
					rUFM_DLY_TIMER_EN			<=	1'b0;
				end
			end
			St_6_AUX_Power_Mode_Transition_OFF: begin
				if (wDLY_TIMEOUT) begin
					oNIC_AUX_PWR_EN 			<=	1'b0;
					rDLY_TIMER_EN				<=	1'b0;
					rDBG_OCP3_NIC_FSM_curr		<=	St_7_AUX_Power_Mode_OFF;
				end
				else if(0/*!oP12V_RUNTIME_FLT || !oAUX_RUNTIME_FLT*/) begin
					rDBG_OCP3_NIC_FSM_curr		<=	St_f_Fault;
				end
				else begin
					rDLY_TIMER_EN				<=	1'b1;
					rDLY_TIME					<=	dly_1ms;
					rUFM_DLY_TIMER_EN			<=	1'b0;
				end
			end
			St_7_AUX_Power_Mode_OFF: begin
				if ( !iPWRGD_NIC_PWR_GOOD ) begin
					rDBG_OCP3_NIC_FSM_curr		<=	St_8_NIC_Power_OFF;
				end		
				else begin
					rDBG_OCP3_NIC_FSM_curr		<=	St_7_AUX_Power_Mode_OFF;
				end
			end
			St_8_NIC_Power_OFF: begin
				if ( wPWR_EN_NIC ) begin
					rDBG_OCP3_NIC_FSM_curr		<=	St_2_AUX_Power_Mode_ON;
				end
				else begin
					rDBG_OCP3_NIC_FSM_curr		<=	St_8_NIC_Power_OFF;
				end
			end
			St_f_Fault: begin
				rDBG_OCP3_NIC_FSM_curr			<= St_f_Fault;
			end
			
		endcase
	end

	if (iPRSNT_NIC_N) begin
		rDBG_OCP3_NIC_FSM_curr	<=	St_0_IDLE;
	end
end

dly_timer#
(
	.pulse_constant	(1'b0)	//1'b0 = pulse, 1'b1 = constant
)
mdly_timer
(
	.clk_in			(iClk_1ms),
	.iRst_n			(iRst_n),
	.iClear			(1'b1),
	.dly_timer_en	(rDLY_TIMER_EN),
	.dly_time		(rDLY_TIME),
	.dly_timeout	(wDLY_TIMEOUT)
);

dly_timer#
(
	.pulse_constant	(1'b1)	//1'b0 = pulse, 1'b1 = constant
)
mufm_dly_timer
(
	.clk_in			(iClk_1ms),
	.iRst_n			(iRst_n),
	.iClear			(1'b1),
	.dly_timer_en	(rUFM_DLY_TIMER_EN),
	.dly_time		(dly_10s),
	.dly_timeout	(wUFM_DLY_TIMEOUT)
);

Edge_Detector mufm_AUX_PWRGD_Edge_Detect
(
	.iClk					(iClk),
	.iClk_1ms				(iClk_1ms),
	.iRst_n					(iRst_n),
	.iClear					(iPG_P3V3_AUX),

	.pos_neg				(1'b0),
	.both					(1'b0),
	.input_sig				(iPG_P12V_AUX),

	.output_pulse_sig		(),
	.output_constant_sig	(wUFM_AUX_PWRGD_constant_Edge_Detector)
);

Edge_Detector mufm_NIC_PWRGD_Edge_Detect
(
	.iClk					(iClk),
	.iClk_1ms				(iClk_1ms),
	.iRst_n					(iRst_n),
	.iClear					(oNIC_AUX_PWR_EN),

	.pos_neg				(1'b0),
	.both					(1'b0),
	.input_sig				(iPWRGD_NIC_PWR_GOOD),

	.output_pulse_sig		(),
	.output_constant_sig	(wUFM_NIC_PWRGD_constant_Edge_Detector)
);

endmodule