//`define SIM
//`define TEST
`define noUFM

module TopCICPDB
(
    //	CLK
	input wire CLK_25M_OSC_FPGA,	               	//  C8	25M CLK
    output wire FM_PLD_HEARTBEAT, 	                //  P4  CPLD Heartbeat LED 
    //	GB200
	input wire NODEA_PSU_SMB_ALERT_R_L,	        	//  F10	Node_A P12V VR alert
    input wire NODEB_PSU_SMB_ALERT_R_L,	        	//  D11 Node_B P12V VR alert
    input wire NODEA_NODEB_PWOK_PLD_ISO_R,	    	//  A15 PWROK indicator from Node_A & Node_B
    //	FAN
	output wire P12V_AUX_FAN_EN_PLD,	            //  M14 P12V FAN VR enable
    input wire P12V_AUX_FAN_FAULT_PLD_N,	        //  M15 P12V FAN VR fault
    input wire P12V_AUX_FAN_ALERT_PLD_N,	        //  K16 P12V FAN VR alert
    input wire P12V_AUX_FAN_OC_PLD_N,	            //  N16 P12V FAN VR OC
    input wire PWRGD_P12V_AUX_FAN_PLD,	        	//  N14 P12V FAN VR PWRGD
	input wire FAN_0_PRESENT_N,	                	//  C15	PRSNT of Internal FAN_0
    input wire FAN_1_PRESENT_N,	                	//  B16	PRSNT of Internal FAN_1
    input wire FAN_2_PRESENT_N,	                	//  C16	PRSNT of Internal FAN_2
    input wire FAN_3_PRESENT_N,	                	//  D15	PRSNT of Internal FAN_3
    input wire FAN_4_PRESENT_N,	                	//  F13	PRSNT of Internal FAN_4
    input wire FAN_5_PRESENT_N,	                	//  G12	PRSNT of Internal FAN_5
    input wire FAN_6_PRESENT_N,	                	//  F12	PRSNT of Internal FAN_6
    input wire FAN_7_PRESENT_N,	                	//  G13	PRSNT of Internal FAN_7
	//	Leak Cable
	input wire FM_PLD_LEAK_DETECT_PWM,	        	//  J16	Leak sensor PWM monitor input
    input wire PRSNT_CHASSIS0_LEAK_CABLE_R_N,		//  L14	PRSNT of Internal LEAK_0
    input wire CHASSIS0_LEAK_Q_N_PLD,	        	//  L13 Leak cable_0 flipflop Q
    input wire LEAK0_DETECT_R,	                	//  G11 Leak cable_0 flipflop Q_N
    input wire PRSNT_CHASSIS1_LEAK_CABLE_R_N,		//  K13	PRSNT of Internal LEAK_1
    input wire CHASSIS1_LEAK_Q_N_PLD,	        	//  N15 Leak cable_1 flipflop Q
    input wire LEAK1_DETECT_R,	                	//  H12 Leak cable_1 flipflop Q_N
    input wire PRSNT_CHASSIS2_LEAK_CABLE_R_N,		//  K12	PRSNT of Internal LEAK_2
    input wire CHASSIS2_LEAK_Q_N_PLD,	        	//  P16 Leak cable_2 flipflop Q
    input wire LEAK2_DETECT_R,	                	//  H13 Leak cable_2 flipflop Q_N
    input wire PRSNT_CHASSIS3_LEAK_CABLE_R_N,		//  L15	PRSNT of Internal LEAK_3
    input wire CHASSIS3_LEAK_Q_N_PLD,	        	//  J12 Leak cable_3 flipflop Q
	input wire LEAK3_DETECT_R,	                	//  K11 Leak cable_3 flipflop Q_N
	//	BOARD SKU/REV ID
	input wire FM_BOARD_BMC_SKU_ID0,	            //  A4	BOARD BOM SKU ID
    input wire FM_BOARD_BMC_SKU_ID1,	            //  B3	BOARD BOM SKU ID
    input wire FM_BOARD_BMC_SKU_ID2,	            //  B5	BOARD BOM SKU ID
    input wire FM_BOARD_BMC_SKU_ID3,	            //  C4	BOARD BOM SKU ID
    input wire FAB_BMC_REV_ID0,	                	//  B6	BOARD REV ID
    input wire FAB_BMC_REV_ID1,	                	//  A5	BOARD REV ID
    input wire FAB_BMC_REV_ID2,	                	//  C5	BOARD REV ID
    //	FIO & RMC
	input wire FM_MAIN_PWREN_RMC_EN_ISO_R,	    	//  J13	Enable power pin of PDB control by RMC
    input wire SMB_RJ45_FIO_TMP_ALERT,	        	//  G16	FIO temp alert
    input wire PRSNT_RJ45_FIO_N_R,	            	//  E16	FIO PRSNT
    output wire RSVD_RMC_GPIO3_R,	                //  J14 no function determined
    output wire LEAK_DETECT_RMC_N_R,	            //  H11 Leak detect indicator to RMC
    output wire FM_MAIN_PWREN_FROM_RMC_R,	        //  E14 CPLD control P12V N1 & N2 VR, determined by FM_MAIN_PWREN_RMC_EN_ISO_R
    output wire CPLD_READY_N,	                    //  J11	PDB PWRGD to RMC
    output wire SMB_RMC_BUF_EN,	                	//  L12	SMBus Repeater enable function, SMBus from RMC
    output wire LEAK_DETECT_LED1_ANODE_PLD,	    	//  G15 FIO LED Amber no use
    output wire LEAK_DETECT_LED1_BNODE_PLD,	    	//  G14 FIO LED Blue no use
    output wire LEAK_DETECT_LED2_ANODE_PLD,	    	//  K15 FIO LED Amber no use
    output wire LEAK_DETECT_LED2_BNODE_PLD,	    	//  L16 FIO LED Blue no use
    //	SMBus
	inout wire I2C_3V3_15_SCL_R,	                //  A9	SMBus CLK for update CPLD FW
    inout wire I2C_3V3_15_SDA_R,	                //  C9	SMBus DAT for update CPLD FW
    inout wire I2C_3V3_15_SCL_R2,	            	//  A11 SMBus CLK for read CPLD register
    inout wire I2C_3V3_15_SDA_R2,	            	//  C11	SMBus DAT for read CPLD register
    inout wire I2C_RMC_SCL_BUF,	                	//  H14	SMBus CLK for RMC
    inout wire I2C_RMC_SDA_BUF,	                	//  H16 SMBus DAT for RMC
	//	OCP NIC_0
	input wire HP_OCP_V3_1_HSC_PWRGD_PLD_R,			//  D6	NIC0 P12V PWRGD
    input wire FM_P3V3_NIC0_FAULT_R_N,	            //  F7	NIC0 P3V3 PWRGD/Fault
    input wire HP_LVC3_OCP_V3_1_PRSNT2_PLD_N,		//  A3	NIC0 PRSNT
    input wire HP_LVC3_OCP_V3_1_PWRGD_PLD,	    	//  B7	NIC0 P12V & P3V3 PWRGD
    input wire OCP_SFF_PERST_FROM_HOST_ISO_PLD_N,	//  F15	NIC0 PERST from N1 & N2
    input wire OCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N,	//  R16	NIC0 Throttle function
    input wire FM_P12V_NIC0_FLTB_R_N,	            //  E6	NIC0 P12V Fault
    input wire P12V_AUX_NIC0_SENSE_ALERT_R_N,	    //  D9	NIC0 P12V Sense Alert
    input wire FM_OCP_SFF_PWR_GOOD_PLD,	        	//  D8	NIC0 fully PWR ON PWRGD
    output wire OCP_SFF_AUX_PWR_PLD_EN_R,	        //  A12	NIC0 AUX PWR enable
    output wire OCP_SFF_MAIN_PWR_EN,	            //  B12	NIC0 Main PWR enable
    output wire RST_OCP_V3_1_R_N,	                //  A10	NIC0 RST
    //	OCP NIC_1
	input wire HP_OCP_V3_2_HSC_PWRGD_PLD_R,			//  E7	NIC1 P12V PWRGD
    input wire FM_P3V3_NIC1_FAULT_R_N,	            //  E8	NIC1 P3V3 PWRGD/Fault
    input wire HP_LVC3_OCP_V3_2_PRSNT2_PLD_N,		//  B4	NIC1 PRSNT
    input wire HP_LVC3_OCP_V3_2_PWRGD_PLD,	    	//  C7	NIC1 P12V & P3V3 PWRGD
    input wire OCP_V3_2_PERST_FROM_HOST_ISO_PLD_N,	//  F14	NIC1 PERST from N1 & N2
    input wire OCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N,	//  P15	NIC1 Throttle function
    input wire FM_P12V_NIC1_FLTB_R_N,	            //  D7	NIC1 P12V Fault
    input wire P12V_AUX_NIC1_SENSE_ALERT_R_N,	    //  B9	NIC1 P12V Sense Alert
    input wire FM_OCP_V3_2_PWR_GOOD_PLD,	        //  E9	NIC1 fully PWR ON PWRGD
    output wire OCP_V3_2_AUX_PWR_PLD_EN_R,	    	//  B13	NIC1 AUX PWR enable
    output wire OCP_V3_2_MAIN_PWR_EN,	            //  B14 NIC1 Main PWR enable
    output wire RST_OCP_V3_2_R_N,	                //  F9	NIC1 RST
    //	Rest
	input wire P12V_AUX_PSU_SMB_ALERT_R_L,	    	//  B11 PDB P12V VR alert
    input wire P52V_SENSE_ALERT_PLD_N,	            //  A8	P52V Sense alert
    input wire P48V_HS1_FAULT_N_PLD,	            //  D14	P48V HSC1 fault
    input wire P48V_HS2_FAULT_N_PLD,	            //  E15 P48V HSC2 fault
    input wire PWRGD_P3V3_AUX_PLD,	            	//  F16	PWRGD of P3V3_AUX on PDB
	input wire PWRGD_P12V_AUX_PLD_ISO_R, 	        //  N6  P12V_AUX PWRGD
    input wire PRSNT_OSFP0_POWER_CABLE_N,	    	//  J15 Cable PRSNT of OSFP
    input wire PRSNT_HDDBD_POWER_CABLE_N,	    	//  K14 Cable PRSNT of HDDBD
	input wire P12V_SCM_SENSE_ALERT_R_N,	        //  A13 Sense alert of P12V of SCM
	output wire HDD_LED_PLD_N,						//	L7	BMC indication of HDD activity
	output wire PSU_ALERT_N,                  		//  D16	PSU alert from CPLD to GB200 module_0
    output wire RST_USB_HUB_N,	                	//  M16	RST of USB HUB
	output wire RST_SMB_SWITCH_PLD_N,	            //  H15	RST of SMBus MUX
    output wire FM_PDB_HEALTH_R_N,	            	//  E10	no function determined
    output wire FM_SYS_THROTTLE_N,	            	//  E11 System throttle for NIC_0 & NIC_1
    output wire FM_NCSI_OCP_V3_1_OE,	            //  D10 NCSI enable pin for BMC and NIC_0
	output wire FM_NCSI_OCP_V3_2_OE,				//	A14 NCSI enable pin for BMC and NIC_1
    
	input wire PDB_P12V_EN_N_ISO_PLD_R,				//	R7 GB200 PWR Enable function(low active)
    input wire PWR_BTN_BMC_R_N,						//	P7 FP PWR BTN
    input wire P12V_N1_ENABLE_PLD_R,				//	T7 N1 P12V VR Enable
	input wire P12V_N2_ENABLE_PLD_R,				//	R8 N2 P12V VR Enable
	output wire FM_HDD_PWR_CTRL,					//	L8 HDD DC ON/OFF
    output wire P12V_N1_ENABLE_R,					//	M7 N1 P12V Enable Ctrl
    output wire P12V_N2_ENABLE_R,					//	M6 N2 P12V Enable Ctrl
    // Test Point
	output wire TP_U21_PB3C, 	                    //  T2  Debug use
    output wire TP_U21_PB3D, 	                    //  R3  Debug use
    output wire TP_U21_PB5A, 	                    //  R5  Debug use
    output wire TP_U21_PB5B, 	                    //  P5  Debug use
    output wire TP_U21_PB6C, 	                    //  T3  Debug use
    output wire TP_U21_PB6D, 	                    //  R4  Debug use
    output wire TP_U21_PB6A, 	                    //  T5  Debug use
	output wire TP_U21_PB6B 	                    //  R6  Debug use
);

wire	wOSC;
wire	wRST_N;
wire	wCLK_38M;
wire	wCLK_2M;
wire	wCLK_50M;
wire	wCLK_10M;
wire	wPLL_LOCK_i;
wire	wPLL_LOCK_e;

wire 	wCLK_EN_O0;
wire 	wCLK_EN_O1;
wire 	wCLK_EN_O2;
wire 	wCLK_EN_O3;
wire	wCLK_EN_O4;
wire	wCLK_EN_O5;
wire 	wCLK_1ms;
wire	wCLK_1us;
wire	wCLK_10us;
wire	wCLK_50ms;
wire	wCLK_1s;
wire	wCLK_250ms;
wire	wCLK_200us;

wire	wNIC0_PERST_N;
wire	wNIC1_PERST_N;

wire    wPWR_EN_Devices;
wire	wPWR_P48V_FAULT;
wire	wPWR_FAN_FAULT;
wire	wPWR_NIC0_FAULT;
wire	wPWR_NIC1_FAULT;

wire	wSmall_Leakage_N;
wire	wLarge_Leakage_N;

wire	wUFM_LEAK_FLT;
wire	wUFM_VR_FLT;
wire	wUFM_PRSNT_FLT;
wire	wUFM_SEQPWR_FLT;
wire	wUFM_RUNTIME_FLT;

wire	[3:0] wPlatform_Config;
wire	wLeak_ConfigDone;

wire	wP12V_AUX_SEQPWR_FLT_N;
wire	wP12V_FAN_SEQPWR_FLT_N;
wire	wP12V_N1N2_SEQPWR_FLT_N;
wire	wHost_PERST_SEQPWR_FLT_N;
wire	wAUX_SEQPWR_FLT_NIC0_N;
wire	wP12V_SEQPWR_FLT_NIC0_N;
wire	wAUX_SEQPWR_FLT_NIC1_N;
wire	wP12V_SEQPWR_FLT_NIC1_N;

wire	wP12V_AUX_RUNTIME_FLT_N;
wire	wP12V_FAN_RUNTIME_FLT_N;
wire	wP12V_N1N2_RUNTIME_FLT_N;
wire	wAUX_RUNTIME_FLT_NIC0_N;
wire	wP12V_RUNTIME_FLT_NIC0_N;
wire	wAUX_RUNTIME_FLT_NIC1_N;
wire	wP12V_RUNTIME_FLT_NIC1_N;

wire	wLargeLeak_Detect_delay;
wire	wSmallLeak_Detect_delay;

wire    wNIC_STBY_PWR_OK;
wire    wNIC_MAIN_PWR_OK;

wire	wCPLD_Existence_Error_Injection;

wire 	wNIC0_PWRBRK_N;
wire 	wNIC1_PWRBRK_N;

wire 	[3:0] wDBG_MSTR_SEQ_FSM_curr;
wire	[7:0] wDBG_NICx_SEQ_FSM_curr;

wire	wFM_MAIN_PWREN_RMC_EN_ISO_R;
wire	wFM_MAIN_PWREN_RMC_EN_ISO_R_db;
wire	wFM_MAIN_PWREN_RMC_EN_ISO_R_edge;
wire	wFM_MAIN_PWREN_RMC_EN_ISO_R_delay;
wire	wFM_MAIN_PWREN_RMC_EN_ISO_R_config;

wire	wNODEA_PSU_SMB_ALERT_R_L;
wire	wNODEB_PSU_SMB_ALERT_R_L;
wire	wNODEA_NODEB_PWOK_PLD_ISO_R;
wire	wP12V_AUX_FAN_FAULT_PLD_N;
wire	wP12V_AUX_FAN_ALERT_PLD_N;
wire	wP12V_AUX_FAN_OC_PLD_N;
wire	wPWRGD_P12V_AUX_FAN_PLD;

wire	wFAN_0_PRESENT_N;
wire	wFAN_1_PRESENT_N;
wire	wFAN_2_PRESENT_N;
wire	wFAN_3_PRESENT_N;
wire	wFAN_4_PRESENT_N;
wire	wFAN_5_PRESENT_N;
wire	wFAN_6_PRESENT_N;
wire	wFAN_7_PRESENT_N;

wire	wFM_PLD_LEAK_DETECT_PWM;
wire 	wLeak_recover;

wire	wPRSNT_CHASSIS0_LEAK_CABLE_R_N;
wire	wPRSNT_CHASSIS1_LEAK_CABLE_R_N;
wire	wPRSNT_CHASSIS2_LEAK_CABLE_R_N;
wire	wPRSNT_CHASSIS3_LEAK_CABLE_R_N;

wire	wCHASSIS0_LEAK_Q_N_PLD;
wire	wCHASSIS1_LEAK_Q_N_PLD;
wire	wCHASSIS2_LEAK_Q_N_PLD;
wire	wCHASSIS3_LEAK_Q_N_PLD;

wire	wCHASSIS0_LEAK_Q_N_PLD_db;
wire	wCHASSIS1_LEAK_Q_N_PLD_db;
wire	wCHASSIS2_LEAK_Q_N_PLD_db;
wire	wCHASSIS3_LEAK_Q_N_PLD_db;

wire	wCHASSIS0_LEAK_Q_N_db_init;
wire	wCHASSIS1_LEAK_Q_N_db_init;
wire	wCHASSIS2_LEAK_Q_N_db_init;
wire	wCHASSIS3_LEAK_Q_N_db_init;

wire	wCHASSIS0_LEAK_Q_N_db_init_bmc;
wire	wCHASSIS1_LEAK_Q_N_db_init_bmc;
wire	wCHASSIS2_LEAK_Q_N_db_init_bmc;
wire	wCHASSIS3_LEAK_Q_N_db_init_bmc;

wire	wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N_db;
wire	wOCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N_db;

wire	wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N_dly;
wire	wOCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N_dly;

wire	wLEAK0_DETECT_R;
wire	wLEAK1_DETECT_R;
wire	wLEAK2_DETECT_R;
wire	wLEAK3_DETECT_R;

wire	wFM_BOARD_BMC_SKU_ID0;
wire	wFM_BOARD_BMC_SKU_ID1;
wire	wFM_BOARD_BMC_SKU_ID2;
wire	wFM_BOARD_BMC_SKU_ID3;
wire	wFAB_BMC_REV_ID0;
wire	wFAB_BMC_REV_ID1;
wire	wFAB_BMC_REV_ID2;

wire	wSMB_RJ45_FIO_TMP_ALERT;
wire	wPRSNT_RJ45_FIO_N_R;

wire	wHP_OCP_V3_1_HSC_PWRGD_PLD_R;
wire	wHP_LVC3_OCP_V3_1_PRSNT2_PLD_N;
wire	wHP_LVC3_OCP_V3_1_PWRGD_PLD;
wire	wOCP_SFF_PERST_FROM_HOST_ISO_PLD_N;
wire	wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N;
wire	wFM_P3V3_NIC0_FAULT_R_N;
wire	wFM_P12V_NIC0_FLTB_R_N;
wire	wP12V_AUX_NIC0_SENSE_ALERT_R_N;
wire	wFM_OCP_SFF_PWR_GOOD_PLD;

wire	wHP_OCP_V3_2_HSC_PWRGD_PLD_R;
wire	wHP_LVC3_OCP_V3_2_PRSNT2_PLD_N;
wire	wHP_LVC3_OCP_V3_2_PWRGD_PLD;
wire	wOCP_V3_2_PERST_FROM_HOST_ISO_PLD_N;
wire	wOCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N;
wire	wFM_P3V3_NIC1_FAULT_R_N;
wire	wFM_P12V_NIC1_FLTB_R_N;
wire	wP12V_AUX_NIC1_SENSE_ALERT_R_N;
wire	wFM_OCP_V3_2_PWR_GOOD_PLD;

wire	wP12V_AUX_PSU_SMB_ALERT_R_L;
wire	wP52V_SENSE_ALERT_PLD_N;
wire	wP48V_HS1_FAULT_N_PLD;
wire	wP48V_HS2_FAULT_N_PLD;
wire	wPWRGD_P3V3_AUX_PLD;
wire	wPWRGD_P12V_AUX_PLD_ISO_R;
wire	wPRSNT_OSFP0_POWER_CABLE_N;
wire	wPRSNT_HDDBD_POWER_CABLE_N;
wire	wP12V_SCM_SENSE_ALERT_R_N;

wire	wPDB_P12V_EN_N_ISO_PLD_R;
wire	wPWR_BTN_BMC_R_N;
wire	wP12V_N1_ENABLE_PLD_R;
wire	wP12V_N2_ENABLE_PLD_R;

//	Instances
assign	wNIC0_PWRBRK_N						=	(wDBG_MSTR_SEQ_FSM_curr == 4'h0) ?  ~wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N_dly : 1;
assign	wNIC1_PWRBRK_N						=	(wDBG_MSTR_SEQ_FSM_curr == 4'h0) ?  ~wOCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N_dly : 1;
assign	FM_SYS_THROTTLE_N 					= 	(wNIC0_PWRBRK_N && wNIC1_PWRBRK_N) ? 1 : 0;

assign 	LEAK_DETECT_RMC_N_R 				= 	(!wPRSNT_RJ45_FIO_N_R) ? ~(~(wCHASSIS1_LEAK_Q_N_db_init_bmc & wCHASSIS3_LEAK_Q_N_db_init_bmc) & wLargeLeak_Detect_delay) : 1;
assign	RSVD_RMC_GPIO3_R 					= 	(!wPRSNT_RJ45_FIO_N_R) ? ~(~(wCHASSIS0_LEAK_Q_N_db_init_bmc & wCHASSIS2_LEAK_Q_N_db_init_bmc) & wSmallLeak_Detect_delay) : 1;
assign 	CPLD_READY_N						= 	(!wPRSNT_RJ45_FIO_N_R && wPWRGD_P3V3_AUX_PLD) ? 0 : 1;

assign	wPWR_P48V_FAULT 					=	(wP48V_HS1_FAULT_N_PLD && wP48V_HS2_FAULT_N_PLD) ? 1 : 0;
assign	wPWR_FAN_FAULT 						=	(wP12V_AUX_FAN_FAULT_PLD_N && wP12V_AUX_FAN_OC_PLD_N) ? 1 : 0;
assign	wPWR_NIC0_FAULT 					=	(wFM_P3V3_NIC0_FAULT_R_N && wFM_P12V_NIC0_FLTB_R_N) ? 1 : 0;
assign	wPWR_NIC1_FAULT 					=	(wFM_P3V3_NIC1_FAULT_R_N && wFM_P12V_NIC1_FLTB_R_N) ? 1 : 0;

assign	RST_OCP_V3_1_R_N 					=	(wNIC0_PERST_N && wOCP_SFF_PERST_FROM_HOST_ISO_PLD_N) ? 1 : 0;
assign	RST_OCP_V3_2_R_N 					=	(wNIC1_PERST_N && wOCP_V3_2_PERST_FROM_HOST_ISO_PLD_N) ? 1 : 0;
assign 	RST_SMB_SWITCH_PLD_N 				=	1'b1;
assign 	RST_USB_HUB_N 						=	(wNODEA_NODEB_PWOK_PLD_ISO_R) ? 1 : 0;

assign	LEAK_DETECT_LED2_ANODE_PLD			=	(~wCHASSIS1_LEAK_Q_N_db_init | ~wCHASSIS3_LEAK_Q_N_db_init);//(wLeak_1_status | wLeak_3_status);
assign	LEAK_DETECT_LED2_BNODE_PLD			=	(wCHASSIS1_LEAK_Q_N_db_init & wCHASSIS3_LEAK_Q_N_db_init);//(~wLeak_1_status & ~wLeak_3_status);
assign	LEAK_DETECT_LED1_ANODE_PLD			=	(~wCHASSIS0_LEAK_Q_N_db_init | ~wCHASSIS2_LEAK_Q_N_db_init);//(wLeak_0_status | wLeak_2_status);
assign	LEAK_DETECT_LED1_BNODE_PLD			=	(wCHASSIS0_LEAK_Q_N_db_init & wCHASSIS2_LEAK_Q_N_db_init);//(~wLeak_0_status & ~wLeak_2_status);

assign	FM_HDD_PWR_CTRL						= 	wPWR_EN_Devices;
assign	HDD_LED_PLD_N						=	~wPRSNT_HDDBD_POWER_CABLE_N;
assign	FM_PDB_HEALTH_R_N					=	(IOEXP4_INT_N) ? 1 : 0;
assign	wPlatform_Config					=	(wLeak_ConfigDone) ? wPlatform_Config : {IOEXP4_output[3],IOEXP4_output[2],IOEXP4_output[1],IOEXP4_output[0]};

assign	wCHASSIS0_LEAK_Q_N_db_init_bmc		=	(wBMC_ready) ? ((~wLeak_0_status/* && wCHASSIS0_LEAK_Q_N_PLD_db*/) ? 1 : 0) : 1;
assign	wCHASSIS1_LEAK_Q_N_db_init_bmc		=	(wBMC_ready) ? ((~wLeak_1_status/* && wCHASSIS1_LEAK_Q_N_PLD_db*/) ? 1 : 0) : 1;
assign	wCHASSIS2_LEAK_Q_N_db_init_bmc		=	(wBMC_ready) ? ((~wLeak_2_status/* && wCHASSIS2_LEAK_Q_N_PLD_db*/) ? 1 : 0) : 1;
assign	wCHASSIS3_LEAK_Q_N_db_init_bmc		=	(wBMC_ready) ? ((~wLeak_3_status/* && wCHASSIS3_LEAK_Q_N_PLD_db*/) ? 1 : 0) : 1;

assign	wCHASSIS0_LEAK_Q_N_db_init			=	(~wLeak_0_status/* && wCHASSIS0_LEAK_Q_N_PLD_db*/) ? 1 : 0;
assign	wCHASSIS1_LEAK_Q_N_db_init			=	(~wLeak_1_status/* && wCHASSIS1_LEAK_Q_N_PLD_db*/) ? 1 : 0;
assign	wCHASSIS2_LEAK_Q_N_db_init			=	(~wLeak_2_status/* && wCHASSIS2_LEAK_Q_N_PLD_db*/) ? 1 : 0;
assign	wCHASSIS3_LEAK_Q_N_db_init			=	(~wLeak_3_status/* && wCHASSIS3_LEAK_Q_N_PLD_db*/) ? 1 : 0;

assign	I2C_RMC_SCL_BUF						=	1'bz;
assign	I2C_RMC_SDA_BUF						=	1'bz;

`ifdef TEST
	assign  TP_U21_PB3C							=	wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N_db;
	assign  TP_U21_PB3D							=	1'bz;
	assign  TP_U21_PB5A							=	1'bz;
	assign  TP_U21_PB5B							=	1'bz;
	assign  TP_U21_PB6C							=	~wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N_dly;
	assign  TP_U21_PB6D							=	1'bz;
	assign  TP_U21_PB6A							=	1'bz;
	assign  TP_U21_PB6B							=	1'bz;
`else
	assign	TP_U21_PB3C							=	CLK_25M_OSC_FPGA;
	assign	TP_U21_PB3D							=	wFM_PLD_LEAK_DETECT_PWM;
	assign  TP_U21_PB5A							=	wLEAK0_DETECT_R | wLEAK1_DETECT_R | wLEAK2_DETECT_R | wLEAK3_DETECT_R;
	assign  TP_U21_PB5B							=	wPWR_BTN_BMC_R_N;
	assign  TP_U21_PB6C							=	wP12V_N1_ENABLE_PLD_R;
	assign  TP_U21_PB6D							=	wP12V_N2_ENABLE_PLD_R;
	assign  TP_U21_PB6A							=	I2C_RMC_SCL_BUF;
	assign  TP_U21_PB6B							=	I2C_RMC_SDA_BUF;
`endif

//	OSC
OSCH #("19.00") OSCH_inst ( .OSC(wOSC),.SEDSTDBY(), .STDBY(1'b0));
	// 2.08 4.16 8.31 15.65
	// 2.15 4.29 8.58 16.63
	// 2.22 4.43 8.87 17.73
	// 2.29 4.59 9.17 19.00
	// 2.38 4.75 9.50 20.46
	// 2.46 4.93 9.85 22.17
	// 2.56 5.12 10.23 24.18
	// 2.66 5.32 10.64 26.60
	// 2.77 5.54 11.08 29.56
	// 2.89 5.78 11.57 33.25
	// 3.02 6.05 12.09 38.00
	// 3.17 6.33 12.67 44.33
	// 3.33 6.65 13.30 53.20
	// 3.50 7.00 14.00 66.50
	// 3.69 7.39 14.78 88.67
	// 3.91 7.82 15.65 133.00

//  Module

SYS_PLL mSYS_PLL
(
	.CLKI     				(wOSC),					//Moudle reference clock: 19.00 MHz.
	.RST      				(!wRST_N),
	.CLKOP    				(wCLK_38M),				//Moudle output clock: 38.00 MHz.
	.CLKOS    				(wCLK_2M),				//Moudle output clock: 2.00 MHz.
	.LOCK     				(wPLL_LOCK_i)
);

//ExtPLL mExtPLL
//(
//	.CLKI     				(CLK_25M_OSC_PLD),		//Moudle reference clock: 25.00 MHz.
//	.RST      				(!wRST_N),
//	.CLKOP    				(wCLK_50M),				//Moudle output clock: 50.00 MHz.
//	.CLKOS    				(wCLK_10M),				//Moudle output clock: 10.00 MHz.
//	.LOCK     				(wPLL_LOCK_e)
//);

Clock_Generator #
(
	.DivCnt0Width			(8),
	.DivCnt1Width			(4),
	.DivCnt2Width			(8),
	.DivCnt3Width			(12),
	.DivCnt4Width			(12),
	.DivCnt5Width			(12),
	.DivCnt6Width			(8),
	.DivValue0				(8'd2),
	.DivValue1				(4'd10),
	.DivValue2				(8'd100),
	.DivValue3				(12'd50),
	.DivValue4				(12'd20),
	.DivValue5				(12'd250),
	.DivValue6				(8'd20)
)
Clock_Generator_inst
(
	.CLK_IN   				(wCLK_2M),
	.RESET_N  				(wRST_N),
	.CLK_EN_O0				(wCLK_EN_O0),	//	DivValue0    = 8'd2,    	(  2MHz/    2) =   1MHz :  1us
	.CLK_EN_O1				(wCLK_EN_O1),	//	DivValue1    = 4'd10,   	(  1MHz/   10) = 100KHz :  10us
	.CLK_EN_O2				(wCLK_EN_O2),	//	DivValue2    = 8'd100,  	(100KHz/  100) =   1KHz :  1ms
	.CLK_EN_O3				(wCLK_EN_O3),	//  DivValue3    = 12'd50,	    (   1KHz/  50) =  200Hz :  50ms
	.CLK_EN_O4				(wCLK_EN_O4),	//  DivValue4    = 12'd1000,	(   1KHz/1000) =  	1Hz :  1s
	.CLK_EN_O5				(wCLK_EN_O5),	//  DivValue4    = 12'd1000,	(   1KHz/1000) =  	1Hz :  1s
	.CLK_EN_O6				(wCLK_EN_O6)	//  DivValue4    = 12'd1000,	(   1KHz/1000) =  	1Hz :  1s
); 

`ifdef SIM
	assign wCLK_1ms = wCLK_EN_O0;
`else
	assign wCLK_1ms = wCLK_EN_O2;
`endif

`ifdef SIM
	assign wCLK_1us = wCLK_EN_O2;
`else
	assign wCLK_1us = wCLK_EN_O0;
`endif

assign	wCLK_10us	= wCLK_EN_O1;
assign 	wCLK_50ms	= wCLK_EN_O3;
assign 	wCLK_1s		= wCLK_EN_O4;
assign	wCLK_250ms	= wCLK_EN_O5;
assign	wCLK_200us	= wCLK_EN_O6;

Generator_reset mGenerator_reset
( 
	.iClk   (wOSC),
	.oReset (wRST_N)
);

// Blink Clock Generator //
Blink_Clock #
(
	.BlinkTimeValue(500) // @ 1ms = 500ms
)
blink_clock_inst
(
	.CLK_IN     			(wCLK_2M),
	.RESET_N    			(wRST_N),
	.CLK_EN     			(wCLK_1ms),
	.BLINK_CLK_O			(FM_PLD_HEARTBEAT)
);

debounce mRMC_enable_debounce
(
	.iCLK					(wCLK_50ms),
	.iRst_n					(wRST_N),
	.iClk_dly				(wCLK_1ms),
	.dly_time				(16'd0),
	.prsnt_in				(wFM_MAIN_PWREN_RMC_EN_ISO_R),
	.prsnt_out				(wFM_MAIN_PWREN_RMC_EN_ISO_R_db)
);

debounce mModule0_PWRBRK_debounce
(
	.iCLK					(wCLK_200us),
	.iRst_n					(wRST_N),
	.iClk_dly				(wCLK_1ms),
	.dly_time				(16'd0),
	.prsnt_in				(wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N),
	.prsnt_out				(wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N_db)
);

Edge_Detector mModule0_PWRBRK_delay
(
	.iClk					(wOSC),
	.iClk_delay				(wCLK_1ms),
	.iRst_n					(wRST_N),
	.iClear					(1'b1),
	.iDelay_time			(16'd4),

	.pos_neg				(1'b0),
	.both					(1'b0),
	.input_sig				(wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N_db),

	.output_ext_pulse_sig	(wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N_dly)
);

debounce mModule1_PWRBRK_debounce
(
	.iCLK					(wCLK_200us),
	.iRst_n					(wRST_N),
	.iClk_dly				(wCLK_1ms),
	.dly_time				(16'd0),
	.prsnt_in				(wOCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N),
	.prsnt_out				(wOCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N_db)
);

Edge_Detector mModule1_PWRBRK_delay
(
	.iClk					(wOSC),
	.iClk_delay				(wCLK_1ms),
	.iRst_n					(wRST_N),
	.iClear					(1'b1),
	.iDelay_time			(16'd4),

	.pos_neg				(1'b0),
	.both					(1'b0),
	.input_sig				(wOCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N_db),

	.output_ext_pulse_sig	(wOCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N_dly)
);

debounce mLeak_0_debounce
(
	.iCLK					(wCLK_250ms),
	.iRst_n					(wRST_N),
	.iClk_dly				(wCLK_1ms),
	.dly_time				(16'd0),
	.prsnt_in				(wCHASSIS0_LEAK_Q_N_PLD),
	.prsnt_out				(wCHASSIS0_LEAK_Q_N_PLD_db)
);

debounce mLeak_1_debounce
(
	.iCLK					(wCLK_250ms),
	.iRst_n					(wRST_N),
	.iClk_dly				(wCLK_1ms),
	.dly_time				(16'd0),
	.prsnt_in				(wCHASSIS1_LEAK_Q_N_PLD),
	.prsnt_out				(wCHASSIS1_LEAK_Q_N_PLD_db)
);

debounce mLeak_2_debounce
(
	.iCLK					(wCLK_250ms),
	.iRst_n					(wRST_N),
	.iClk_dly				(wCLK_1ms),
	.dly_time				(16'd0),
	.prsnt_in				(wCHASSIS2_LEAK_Q_N_PLD),
	.prsnt_out				(wCHASSIS2_LEAK_Q_N_PLD_db)
);

debounce mLeak_3_debounce
(
	.iCLK					(wCLK_250ms),
	.iRst_n					(wRST_N),
	.iClk_dly				(wCLK_1ms),
	.dly_time				(16'd0),
	.prsnt_in				(wCHASSIS3_LEAK_Q_N_PLD),
	.prsnt_out				(wCHASSIS3_LEAK_Q_N_PLD_db)
);

RMC_enable_control mRMC_enable
(
	.clk_in					(wOSC),
	.clk_delay				(wCLK_50ms),
	.iRst_n					(wRST_N),
	.iClear					(1'b1),

	.iRMC_enable_debounce	(wFM_MAIN_PWREN_RMC_EN_ISO_R_db),
	.iRMC_enable_config		(IOEXP4_output[7]),
	.oRMC_enable_delay		(wFM_MAIN_PWREN_RMC_EN_ISO_R_config)
);

Edge_Detector mCPLD_existence_detect
(
	.iClk					(wOSC),
	.iClk_delay				(wCLK_1ms),
	.iRst_n					(wRST_N),
	.iClear					(1'b1),
	.iDelay_time			(16'd0),

	.pos_neg				(1'b1),
	.both					(1'b0),
	.input_sig				((wPWRGD_P3V3_AUX_PLD) ? IOEXP4_output[4] & IOEXP4_output[5] : 1),

	.output_ext_pulse_sig	(wLeak_recover/*wCPLD_Existence_Error_Injection*/)
);

MSTR_SEQ mMSTR_SEQ
(
    .iClk                       (wOSC),
    .iClk_1ms                   (wCLK_1ms),
	.iClk_50ms                  (wCLK_50ms),
    .iRst_n                     (wRST_N),

	.iPWRGD_P3V3_AUX            (wPWRGD_P3V3_AUX_PLD),
    .iPWRGD_P12V_AUX            (wPWRGD_P12V_AUX_PLD_ISO_R),
	.iRMC_PWR_Enable			(wFM_MAIN_PWREN_RMC_EN_ISO_R_config),
	.iLarge_Leak_Detect_N		(~wCHASSIS1_LEAK_Q_N_db_init_bmc | ~wCHASSIS3_LEAK_Q_N_db_init_bmc),
	.iSmall_Leak_Detect_N		(~wCHASSIS0_LEAK_Q_N_db_init_bmc | ~wCHASSIS2_LEAK_Q_N_db_init_bmc),
	.iPlatform_Config			(wPlatform_Config),
	.iBMC_Config				(wLeak_ConfigDone),
	.iNIC0_PRSNT				(wHP_LVC3_OCP_V3_1_PRSNT2_PLD_N),
	.iNIC1_PRSNT				(wHP_LVC3_OCP_V3_2_PRSNT2_PLD_N),

	.oP12V_AUX_FAN_EN			(P12V_AUX_FAN_EN_PLD),
	.iPWRGD_P12V_AUX_FAN		(wPWRGD_P12V_AUX_FAN_PLD),

	.iDC_PWR_BTN_ON				(wPDB_P12V_EN_N_ISO_PLD_R),
	.oPWR_EN_Devices            (wPWR_EN_Devices),
	.oP12V_NODEx_EN				(FM_MAIN_PWREN_FROM_RMC_R),
	.oP12V_N1_EN				(P12V_N1_ENABLE_R),
	.oP12V_N2_EN				(P12V_N2_ENABLE_R),
	.iPWRGD_P12V_Nodex			(wNODEA_NODEB_PWOK_PLD_ISO_R),
	.iHost_PERST_NIC0			(wOCP_SFF_PERST_FROM_HOST_ISO_PLD_N),
	.iHost_PERST_NIC1			(wOCP_V3_2_PERST_FROM_HOST_ISO_PLD_N),

//	.iPWR_P48V_FAULT			(wPWR_P48V_FAULT),
//	.iPWR_FAN_FAULT				(wPWR_FAN_FAULT),
//	.iPWR_NIC0_FAULT			(wPWR_NIC0_FAULT),
//	.iPWR_NIC1_FAULT			(wPWR_NIC1_FAULT),

	.oDBG_MSTR_SEQ_FSM_curr     (wDBG_MSTR_SEQ_FSM_curr),

	.oP12V_AUX_SEQPWR_FLT		(wP12V_AUX_SEQPWR_FLT_N),
	.oP12V_FAN_SEQPWR_FLT		(wP12V_FAN_SEQPWR_FLT_N),
	.oP12V_N1N2_SEQPWR_FLT		(wP12V_N1N2_SEQPWR_FLT_N),
	.oHost_PERST_SEQPWR_FLT		(wHost_PERST_SEQPWR_FLT_N),
	.oP12V_AUX_RUNTIME_FLT		(wP12V_AUX_RUNTIME_FLT_N),
	.oP12V_FAN_RUNTIME_FLT		(wP12V_FAN_RUNTIME_FLT_N),
	.oP12V_N1N2_RUNTIME_FLT		(wP12V_N1N2_RUNTIME_FLT_N),
	.oLargeLeak_Detect_delay	(wLargeLeak_Detect_delay),
	.oSmallLeak_Detect_delay	(wSmallLeak_Detect_delay)
);

OCP3_NIC_Control mOCP3_NIC_Control 
(
    .iClk                   (wCLK_2M),
    .iClk_1ms               (wCLK_1ms),
    .iRst_n                 (wRST_N),
	
    .iPWR_EN_DEV            (wPWR_EN_Devices & wPWR_NIC0_FAULT & wPWR_NIC1_FAULT),
	.iPWRGD_P3V3_AUX        (wPWRGD_P3V3_AUX_PLD),
    .oNIC_STBY_PWR_OK       (wNIC_STBY_PWR_OK),
    .oNIC_MAIN_PWR_OK       (wNIC_MAIN_PWR_OK),
        
	.iPRSNT_NIC0_N          (wHP_LVC3_OCP_V3_1_PRSNT2_PLD_N),
	.iPWRGD_P12V_NIC0       (wHP_LVC3_OCP_V3_1_PWRGD_PLD),		// PWRGD of P12V and P3V3 tie together
    .iPWRGD_P3V3_NIC0       (wHP_LVC3_OCP_V3_1_PWRGD_PLD),		// PWRGD of P12V and P3V3 tie together
    .oNIC0_AUX_PWR_EN       (OCP_SFF_AUX_PWR_PLD_EN_R),
    .iPWRGD_NIC0_PWR_GOOD   (wFM_OCP_SFF_PWR_GOOD_PLD),
    .oNIC0_MAIN_PWR_EN      (OCP_SFF_MAIN_PWR_EN),
    .oRST_NIC0_PERST_N      (wNIC0_PERST_N),
        
	.iPRSNT_NIC1_N          (wHP_LVC3_OCP_V3_2_PRSNT2_PLD_N),
    .iPWRGD_P12V_NIC1       (wHP_LVC3_OCP_V3_2_PWRGD_PLD),		// PWRGD of P12V and P3V3 tie together
    .iPWRGD_P3V3_NIC1       (wHP_LVC3_OCP_V3_2_PWRGD_PLD),		// PWRGD of P12V and P3V3 tie together
    .oNIC1_AUX_PWR_EN       (OCP_V3_2_AUX_PWR_PLD_EN_R),
    .iPWRGD_NIC1_PWR_GOOD   (wFM_OCP_V3_2_PWR_GOOD_PLD),
    .oNIC1_MAIN_PWR_EN      (OCP_V3_2_MAIN_PWR_EN),
    .oRST_NIC1_PERST_N      (wNIC1_PERST_N),
	
	.oNICx_FSM_curr			(wDBG_NICx_SEQ_FSM_curr),

	.oAUX_SEQPWR_FLT_NIC0	(wAUX_SEQPWR_FLT_NIC0_N),
	.oP12V_SEQPWR_FLT_NIC0	(wP12V_SEQPWR_FLT_NIC0_N),
	.oAUX_SEQPWR_FLT_NIC1	(wAUX_SEQPWR_FLT_NIC1_N),
	.oP12V_SEQPWR_FLT_NIC1	(wP12V_SEQPWR_FLT_NIC1_N),

	.oAUX_RUNTIME_FLT_NIC0	(wAUX_RUNTIME_FLT_NIC0_N),
	.oP12V_RUNTIME_FLT_NIC0	(wP12V_RUNTIME_FLT_NIC0_N),
	.oAUX_RUNTIME_FLT_NIC1	(wAUX_RUNTIME_FLT_NIC1_N),
	.oP12V_RUNTIME_FLT_NIC1	(wP12V_RUNTIME_FLT_NIC1_N)
);

wire 	scl_in;
wire 	sda_in;

wire 	UFM_scl_oe;
wire 	UFM_sda_oe;
wire 	REGs_sda_oe;
wire 	IOEXP0_sda_oe;
wire 	IOEXP1_sda_oe;
wire 	IOEXP2_sda_oe;
wire 	IOEXP3_sda_oe;
wire 	IOEXP4_sda_oe;

assign 	scl_in = I2C_3V3_15_SCL_R2;
assign 	sda_in = I2C_3V3_15_SDA_R2;
`ifdef noUFM
	assign 	I2C_3V3_15_SCL_R2 = 1 ? 1'bz : 1'b0;
	assign 	I2C_3V3_15_SDA_R2 = //UFM_sda_oe &
								REGs_sda_oe &
								IOEXP4_sda_oe &
								IOEXP3_sda_oe &
								IOEXP2_sda_oe &
								IOEXP1_sda_oe &
								IOEXP0_sda_oe ? 1'bz : 1'b0; //&
//								~wCPLD_Existence_Error_Injection ? 1'bz : 1'b0;
`else
	assign 	I2C_3V3_15_SCL_R2 = UFM_scl_oe ? 1'bz : 1'b0;
	assign 	I2C_3V3_15_SDA_R2 = UFM_sda_oe &
								REGs_sda_oe &
								IOEXP4_sda_oe &
								IOEXP3_sda_oe &
								IOEXP2_sda_oe &
								IOEXP1_sda_oe &
								IOEXP0_sda_oe ? 1'bz : 1'b0; //&
//								~wCPLD_Existence_Error_Injection ? 1'bz : 1'b0;
`endif

wire	[15:0]	IOEXP0_output;
wire	IOEXP0_INT_N;

SMBusIOExp_Control#
(
	.i2c_slave_addr		(7'h10)
)I2C_Control_0
(
	.iClk				(wOSC),
	.iClk_1ms			(wCLK_1ms),
	.iRst_n				(wRST_N),
	.INT_N				(IOEXP0_INT_N),
	.INT_DISABLE_N		(1'b1),
	.scl_in             (scl_in),
	.sda_in             (sda_in),
	.sda_oe             (IOEXP0_sda_oe),
	.iI0				({
						wP12V_AUX_SEQPWR_FLT_N,
						wP12V_FAN_SEQPWR_FLT_N,
						wP12V_N1N2_SEQPWR_FLT_N,
						1'b1,//wHost_PERST_SEQPWR_FLT_N,
						wP12V_AUX_RUNTIME_FLT_N,
						wP12V_FAN_RUNTIME_FLT_N,
						wP12V_N1N2_RUNTIME_FLT_N,
						1'b1
						}),
	.iI1				({
						wAUX_SEQPWR_FLT_NIC0_N,
						wP12V_SEQPWR_FLT_NIC0_N,
						wAUX_RUNTIME_FLT_NIC0_N,
						wP12V_RUNTIME_FLT_NIC0_N,
						wAUX_SEQPWR_FLT_NIC1_N,
						wP12V_SEQPWR_FLT_NIC1_N,
						wAUX_RUNTIME_FLT_NIC1_N,
						wP12V_RUNTIME_FLT_NIC1_N
						}),
	.output_data		(),
	.iP0_inout_config	(1),
	.iP1_inout_config	(1)
);

wire	[15:0]	IOEXP1_output;
wire	IOEXP1_INT_N;

SMBusIOExp_Control#
(
	.i2c_slave_addr		(7'h11)
)I2C_Control_1
(
	.iClk				(wOSC),
	.iClk_1ms			(wCLK_1ms),
	.iRst_n				(wRST_N),
	.INT_N				(IOEXP1_INT_N),
	.INT_DISABLE_N		(1'b1),
	.scl_in             (scl_in),
	.sda_in             (sda_in),
	.sda_oe             (IOEXP1_sda_oe),
	.iI0				({
						wP12V_AUX_FAN_FAULT_PLD_N,
						wP12V_AUX_FAN_OC_PLD_N,
						wP48V_HS1_FAULT_N_PLD,
						wP48V_HS2_FAULT_N_PLD,
						wFM_P3V3_NIC0_FAULT_R_N,
						wFM_P12V_NIC0_FLTB_R_N,
						wFM_P3V3_NIC1_FAULT_R_N,
						wFM_P12V_NIC1_FLTB_R_N
						}),
	.iI1				({
						wNIC0_PWRBRK_N,
						wNIC1_PWRBRK_N,
						FM_SYS_THROTTLE_N,
						5'b11111
						}),
	.output_data		(),
	.iP0_inout_config	(1),
	.iP1_inout_config	(1)
);

wire	[15:0]	IOEXP2_output;
wire	IOEXP2_INT_N;

SMBusIOExp_Control#
(
	.i2c_slave_addr		(7'h12)
)I2C_Control_2
(
	.iClk				(wOSC),
	.iClk_1ms			(wCLK_1ms),
	.iRst_n				(wRST_N),
	.INT_N				(IOEXP2_INT_N),
	.INT_DISABLE_N		(1'b1),
	.scl_in             (scl_in),
	.sda_in             (sda_in),
	.sda_oe             (IOEXP2_sda_oe),
	.iI0				({
						wP52V_SENSE_ALERT_PLD_N,
						wP12V_AUX_FAN_ALERT_PLD_N,
						wNODEA_PSU_SMB_ALERT_R_L,
						wNODEB_PSU_SMB_ALERT_R_L,
						wP12V_AUX_NIC0_SENSE_ALERT_R_N,
						wP12V_AUX_NIC1_SENSE_ALERT_R_N,
						wP12V_SCM_SENSE_ALERT_R_N,
						wP12V_AUX_PSU_SMB_ALERT_R_L
						}),
	.iI1				({
						wSMB_RJ45_FIO_TMP_ALERT,
						1'b1,
						wCHASSIS0_LEAK_Q_N_db_init_bmc,//~wLeak_0_status,//wCHASSIS0_LEAK_Q_N_PLD_db & IOEXP4_output[4],
						wCHASSIS1_LEAK_Q_N_db_init_bmc,//~wLeak_1_status,//wCHASSIS1_LEAK_Q_N_PLD_db & IOEXP4_output[5],
						wCHASSIS2_LEAK_Q_N_db_init_bmc,//~wLeak_2_status,//wCHASSIS2_LEAK_Q_N_PLD_db & IOEXP4_output[4],
						wCHASSIS3_LEAK_Q_N_db_init_bmc,//~wLeak_3_status,//wCHASSIS3_LEAK_Q_N_PLD_db & IOEXP4_output[5],
						wFM_MAIN_PWREN_RMC_EN_ISO_R_config,
						wPRSNT_RJ45_FIO_N_R
						}),
	.output_data		(),
	.iP0_inout_config	(1),
	.iP1_inout_config	(1)
);

wire	[15:0]	IOEXP3_output;
wire	IOEXP3_INT_N;

SMBusIOExp_Control#
(
	.i2c_slave_addr		(7'h13)
)I2C_Control_3
(
	.iClk				(wOSC),
	.iClk_1ms			(wCLK_1ms),
	.iRst_n				(wRST_N),
	.INT_N				(IOEXP3_INT_N),
	.INT_DISABLE_N		(1'b1),
	.scl_in             (scl_in),
	.sda_in             (sda_in),
	.sda_oe             (IOEXP3_sda_oe),
	.iI0				({
						wFAN_0_PRESENT_N,
						wFAN_1_PRESENT_N,
						wFAN_2_PRESENT_N,
						wFAN_3_PRESENT_N,
						wFAN_4_PRESENT_N,
						wFAN_5_PRESENT_N,
						wFAN_6_PRESENT_N,
						wFAN_7_PRESENT_N
						}),
	.iI1				({
						wPRSNT_CHASSIS0_LEAK_CABLE_R_N,
						wPRSNT_CHASSIS1_LEAK_CABLE_R_N,
						wPRSNT_CHASSIS2_LEAK_CABLE_R_N,
						wPRSNT_CHASSIS3_LEAK_CABLE_R_N,
						wPRSNT_OSFP0_POWER_CABLE_N,
    					wPRSNT_HDDBD_POWER_CABLE_N,
						wHP_LVC3_OCP_V3_1_PRSNT2_PLD_N,
    					wHP_LVC3_OCP_V3_2_PRSNT2_PLD_N
						}),
	.output_data		(),
	.iP0_inout_config	(1),
	.iP1_inout_config	(1)
);

wire	[15:0]	IOEXP4_output;
wire	IOEXP4_INT_N;

SMBusIOExp_Control#
(
	.i2c_slave_addr		(7'h14)
)I2C_Control_4
(
	.iClk				(wOSC),
	.iClk_1ms			(wCLK_1ms),
	.iRst_n				(wRST_N),
	.INT_N				(IOEXP4_INT_N),
	.INT_DISABLE_N		(1'b1),
	.scl_in             (scl_in),
	.sda_in             (sda_in),
	.sda_oe             (IOEXP4_sda_oe),
	.iI0				({
						IOEXP3_INT_N,
						IOEXP2_INT_N,
						IOEXP1_INT_N,
						IOEXP0_INT_N,
						4'hf
						}),
	.iI1				({
						8'hff
						}),
	.output_data		({
						IOEXP4_output[15],
						IOEXP4_output[14],
						IOEXP4_output[13],
						IOEXP4_output[12],
						IOEXP4_output[11],			
						IOEXP4_output[10],
						IOEXP4_output[9],
						IOEXP4_output[8],
						IOEXP4_output[7],			//	RMC enable DC power on
						IOEXP4_output[6],			//	CPLD Existence Error injection / Recover Leak event
						IOEXP4_output[5],			//	Large Leak Error injection
						IOEXP4_output[4],			//	Small Leak Error injection
						IOEXP4_output[3],			//	platform config 3
						IOEXP4_output[2],			//	platform config 2
						IOEXP4_output[1],			//	platform config 1
						IOEXP4_output[0]			//	platform config 0
						}),
	.iP0_inout_config	(1),
	.iP1_inout_config	(0)
);

State_Single_Logger#
(
	.bits				(4)
)
Leak_Config_change
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b1),
	.iEnable			((IOEXP4_output[3:0] == 4'h8 || IOEXP4_output[3:0] == 4'h4 || IOEXP4_output[3:0] == 4'h2 || IOEXP4_output[3:0] == 4'h1) ? 1'b1 : 1'b0),

	.iDbgSt				({
						IOEXP4_output[3],
						IOEXP4_output[2],
						IOEXP4_output[1],
						IOEXP4_output[0]
						}),
	
	.ochange			(wLeak_ConfigDone)
);

wire	wBMC_ready;

dly_timer#
(
	.pulse_constant		(1'b1)
)
mInitial_Leak_detect_timer
(
	.clk_in				(wCLK_50ms),
	.iRst_n				(wRST_N),
	.iClear				(1'b1),
	.dly_timer_en		(wLeak_ConfigDone),
	.dly_timer_start	(1'b1),
	.dly_time			(16'd6000),
	.dly_timeout		(wBMC_ready)
);

wire	[3:0] 	leak_config_prev_state;
wire	[3:0] 	leak_config_prev_state_1;
wire	[3:0] 	leak_config_prev_state_2;
wire	[3:0] 	leak_config_curr_state;

State_Multiple_Logger#
(
	.bits				(4)
)
Leak_Config_Status
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b1),
	.iEnable			(1'b1),

	.iDbgSt				({
						IOEXP4_output[3],
						IOEXP4_output[2],
						IOEXP4_output[1],
						IOEXP4_output[0]
						}),

	.prev_state			(leak_config_prev_state),
	.prev_state_1		(leak_config_prev_state_1),
	.prev_state_2		(leak_config_prev_state_2),
	.current_state		(leak_config_curr_state)
);

wire  wLeak_0_status;
wire  wLeak_1_status;
wire  wLeak_2_status;
wire  wLeak_3_status;

State_Single_Ref_Logger#
(
	.bits					(4)
)
mLeak_status
(
	.iClk					(wOSC),
	.iRst_n					(wRST_N),
	.iClear					(wPWRGD_P12V_AUX_PLD_ISO_R & ~wLeak_recover),
	.iEnable				(1'b1),

	.iRef					({
							1'b1,
							1'b1,
							1'b1,
							1'b1
							}),
	.iDbgSt					({
							(wCHASSIS0_LEAK_Q_N_PLD_db & IOEXP4_output[4]),
							(wCHASSIS1_LEAK_Q_N_PLD_db & IOEXP4_output[5]),
							(wCHASSIS2_LEAK_Q_N_PLD_db & IOEXP4_output[4]),
							(wCHASSIS3_LEAK_Q_N_PLD_db & IOEXP4_output[5])
							}),

	.ochange				({
							wLeak_0_status,
							wLeak_1_status,
							wLeak_2_status,
							wLeak_3_status
							})
);
/*
wire  wLeak_0_status_edge;
wire  wLeak_1_status_edge;
wire  wLeak_2_status_edge;
wire  wLeak_3_status_edge; 

Edge_Detector mLeak_0_Status_edge
(
	.iClk					(wOSC),
	.iClk_delay				(wCLK_1ms),
	.iRst_n					(wRST_N),
	.iClear					(1'b1),
	.iDelay_time			(16'd0),

	.pos_neg				(1'b0),
	.both					(1'b0),
	.input_sig				(wCHASSIS0_LEAK_Q_N_PLD_db & IOEXP4_output[4]),

	.output_ext_pulse_sig	(wLeak_0_status_edge)
);

State_Single_Logger#
(
	.bits					(1)
)
Leak_0_Status
(
	.iClk					(wOSC),
	.iRst_n					(wRST_N),
	.iClear					(wPWRGD_P12V_AUX_PLD_ISO_R & ~wLeak_recover),
	.iEnable				(1'b1),

	.iDbgSt					({
							(wLeak_0_status_edge)
							}),

	.ochange				(wLeak_0_status)
);

Edge_Detector mLeak_1_Status_edge
(
	.iClk					(wOSC),
	.iClk_delay				(wCLK_1ms),
	.iRst_n					(wRST_N),
	.iClear					(1'b1),
	.iDelay_time			(16'd0),

	.pos_neg				(1'b0),
	.both					(1'b0),
	.input_sig				(wCHASSIS1_LEAK_Q_N_PLD_db & IOEXP4_output[5]),

	.output_ext_pulse_sig	(wLeak_1_status_edge)
);

State_Single_Logger#
(
	.bits					(1)
)
Leak_1_Status
(
	.iClk					(wOSC),
	.iRst_n					(wRST_N),
	.iClear					(wPWRGD_P12V_AUX_PLD_ISO_R & ~wLeak_recover),
	.iEnable				(1'b1),

	.iDbgSt					({
							(wLeak_1_status_edge)
							}),

	.ochange				(wLeak_1_status)
);

Edge_Detector mLeak_2_Status_edge
(
	.iClk					(wOSC),
	.iClk_delay				(wCLK_1ms),
	.iRst_n					(wRST_N),
	.iClear					(1'b1),
	.iDelay_time			(16'd0),

	.pos_neg				(1'b0),
	.both					(1'b0),
	.input_sig				(wCHASSIS2_LEAK_Q_N_PLD_db & IOEXP4_output[4]),

	.output_ext_pulse_sig	(wLeak_2_status_edge)
);

State_Single_Logger#
(
	.bits					(1)
)
Leak_2_Status
(
	.iClk					(wOSC),
	.iRst_n					(wRST_N),
	.iClear					(wPWRGD_P12V_AUX_PLD_ISO_R & ~wLeak_recover),
	.iEnable				(1'b1),

	.iDbgSt					({
							(wLeak_2_status_edge)
							}),

	.ochange				(wLeak_2_status)
);

Edge_Detector mLeak_3_Status_edge
(
	.iClk					(wOSC),
	.iClk_delay				(wCLK_1ms),
	.iRst_n					(wRST_N),
	.iClear					(1'b1),
	.iDelay_time			(16'd0),

	.pos_neg				(1'b0),
	.both					(1'b0),
	.input_sig				(wCHASSIS3_LEAK_Q_N_PLD_db & IOEXP4_output[5]),

	.output_ext_pulse_sig	(wLeak_3_status_edge)
);

State_Single_Logger#
(
	.bits					(1)
)
Leak_3_Status
(
	.iClk					(wOSC),
	.iRst_n					(wRST_N),
	.iClear					(wPWRGD_P12V_AUX_PLD_ISO_R & ~wLeak_recover),
	.iEnable				(1'b1),

	.iDbgSt					({
							(wLeak_3_status_edge)
							}),

	.ochange				(wLeak_3_status)
);
*/
wire	[94:0] 	Reg_prev_state;
wire	[94:0] 	Reg_prev_state_1;
wire	[94:0] 	Reg_prev_state_2;
wire	[94:0] 	Reg_curr_state;

State_Multiple_Logger#
(
	.bits				(95)
)
REGs_FLT_state_logger
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b1),
	.iEnable			(1'b1),
	
	.iDbgSt				({
						wFAN_0_PRESENT_N,
						wFAN_1_PRESENT_N,
						wFAN_2_PRESENT_N,
						wFAN_3_PRESENT_N,
						wFAN_4_PRESENT_N,
						wFAN_5_PRESENT_N,
						wFAN_6_PRESENT_N,
						wFAN_7_PRESENT_N,

						wPRSNT_CHASSIS0_LEAK_CABLE_R_N,
						wPRSNT_CHASSIS1_LEAK_CABLE_R_N,
						wPRSNT_CHASSIS2_LEAK_CABLE_R_N,
						wPRSNT_CHASSIS3_LEAK_CABLE_R_N,
						wPRSNT_OSFP0_POWER_CABLE_N,
    					wPRSNT_HDDBD_POWER_CABLE_N,
						wHP_LVC3_OCP_V3_1_PRSNT2_PLD_N,
    					wHP_LVC3_OCP_V3_2_PRSNT2_PLD_N,
						
						wPRSNT_RJ45_FIO_N_R,
						~(wCHASSIS0_LEAK_Q_N_PLD_db & IOEXP4_output[4]),
						~(wCHASSIS1_LEAK_Q_N_PLD_db & IOEXP4_output[5]),
						~(wCHASSIS2_LEAK_Q_N_PLD_db & IOEXP4_output[4]),
						~(wCHASSIS3_LEAK_Q_N_PLD_db & IOEXP4_output[5]),

						~wP12V_AUX_FAN_FAULT_PLD_N,
						~wP12V_AUX_FAN_OC_PLD_N,
						~wP48V_HS1_FAULT_N_PLD,
						~wP48V_HS2_FAULT_N_PLD,
						~wFM_P3V3_NIC0_FAULT_R_N,
						~wFM_P12V_NIC0_FLTB_R_N,
						~wFM_P3V3_NIC1_FAULT_R_N,
						~wFM_P12V_NIC1_FLTB_R_N,

						~wNIC0_PWRBRK_N,
						~wNIC1_PWRBRK_N,
						~wSMB_RJ45_FIO_TMP_ALERT,

						~wP52V_SENSE_ALERT_PLD_N,
						~wP12V_AUX_FAN_ALERT_PLD_N,
						~wNODEA_PSU_SMB_ALERT_R_L,
						~wNODEB_PSU_SMB_ALERT_R_L,
						~wP12V_AUX_NIC0_SENSE_ALERT_R_N,
						~wP12V_AUX_NIC1_SENSE_ALERT_R_N,
						~wP12V_SCM_SENSE_ALERT_R_N,
						~wP12V_AUX_PSU_SMB_ALERT_R_L,

						~wHP_OCP_V3_1_HSC_PWRGD_PLD_R,
						~wHP_LVC3_OCP_V3_1_PWRGD_PLD,
    					~OCP_SFF_AUX_PWR_PLD_EN_R,
						~wFM_OCP_SFF_PWR_GOOD_PLD,
						~OCP_SFF_MAIN_PWR_EN,
						~wNIC0_PERST_N,
						~wOCP_SFF_PERST_FROM_HOST_ISO_PLD_N,
    					~RST_OCP_V3_1_R_N,

						~wAUX_SEQPWR_FLT_NIC0_N,
						~wP12V_SEQPWR_FLT_NIC0_N,
						~wAUX_RUNTIME_FLT_NIC0_N,
						~wP12V_RUNTIME_FLT_NIC0_N,
						wDBG_NICx_SEQ_FSM_curr[7],
						wDBG_NICx_SEQ_FSM_curr[6],
						wDBG_NICx_SEQ_FSM_curr[5],
						wDBG_NICx_SEQ_FSM_curr[4],

						~wHP_OCP_V3_2_HSC_PWRGD_PLD_R,
						~wHP_LVC3_OCP_V3_2_PWRGD_PLD,
    					~OCP_V3_2_AUX_PWR_PLD_EN_R,
						~wFM_OCP_V3_2_PWR_GOOD_PLD,
						~OCP_V3_2_MAIN_PWR_EN,
						~wNIC1_PERST_N,
						~wOCP_V3_2_PERST_FROM_HOST_ISO_PLD_N,
    					~RST_OCP_V3_2_R_N,

						~wAUX_SEQPWR_FLT_NIC1_N,
						~wP12V_SEQPWR_FLT_NIC1_N,
						~wAUX_RUNTIME_FLT_NIC1_N,
						~wP12V_RUNTIME_FLT_NIC1_N,
						wDBG_NICx_SEQ_FSM_curr[3],
						wDBG_NICx_SEQ_FSM_curr[2],
						wDBG_NICx_SEQ_FSM_curr[1],
						wDBG_NICx_SEQ_FSM_curr[0],

						~wPWRGD_P3V3_AUX_PLD,
						~wPWRGD_P12V_AUX_PLD_ISO_R,
						~P12V_AUX_FAN_EN_PLD,
						~wPWRGD_P12V_AUX_FAN_PLD,
						~wFM_MAIN_PWREN_RMC_EN_ISO_R_config,
						wPDB_P12V_EN_N_ISO_PLD_R,
						~FM_MAIN_PWREN_FROM_RMC_R,
						~wPWR_EN_Devices,

						~P12V_N1_ENABLE_R,
						~P12V_N2_ENABLE_R,
						~wNODEA_NODEB_PWOK_PLD_ISO_R,
						CPLD_READY_N,
						~wP12V_AUX_SEQPWR_FLT_N,
						~wP12V_FAN_SEQPWR_FLT_N,
						~wP12V_N1N2_SEQPWR_FLT_N,
						1'b0,//~wHost_PERST_SEQPWR_FLT_N,

						~wP12V_AUX_RUNTIME_FLT_N,
						~wP12V_FAN_RUNTIME_FLT_N,
						~wP12V_N1N2_RUNTIME_FLT_N,
						wDBG_MSTR_SEQ_FSM_curr[3],
						wDBG_MSTR_SEQ_FSM_curr[2],
						wDBG_MSTR_SEQ_FSM_curr[1],
						wDBG_MSTR_SEQ_FSM_curr[0]
						}),

	.prev_state			(Reg_prev_state),
	.prev_state_1		(Reg_prev_state_1),
	.prev_state_2		(Reg_prev_state_2),
	.current_state		(Reg_curr_state)
);

wire	[3:0] NIC0_prev_state;
wire	[3:0] NIC0_prev_state_1;
wire	[3:0] NIC0_prev_state_2;
wire	[3:0] NIC0_curr_state;

State_Multiple_Logger#
(
	.bits				(4)
)
REGs_NIC0_state_Logger
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b1),
	.iEnable			(1'b1),
	
	.iDbgSt				({
						wDBG_NICx_SEQ_FSM_curr[7],
						wDBG_NICx_SEQ_FSM_curr[6],
						wDBG_NICx_SEQ_FSM_curr[5],
						wDBG_NICx_SEQ_FSM_curr[4]
						}),

	.prev_state			(NIC0_prev_state[3:0]),
	.prev_state_1		(NIC0_prev_state_1[3:0]),
	.prev_state_2		(NIC0_prev_state_2[3:0]),
	.current_state		(NIC0_curr_state[3:0])
);

wire	[3:0] NIC1_prev_state;
wire	[3:0] NIC1_prev_state_1;
wire	[3:0] NIC1_prev_state_2;
wire	[3:0] NIC1_curr_state;

State_Multiple_Logger#
(
	.bits				(4)
)
REGs_NIC1_state_Logger
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b1),
	.iEnable			(1'b1),
	
	.iDbgSt				({
						wDBG_NICx_SEQ_FSM_curr[3],
						wDBG_NICx_SEQ_FSM_curr[2],
						wDBG_NICx_SEQ_FSM_curr[1],
						wDBG_NICx_SEQ_FSM_curr[0]
						}),

	.prev_state			(NIC1_prev_state[3:0]),
	.prev_state_1		(NIC1_prev_state_1[3:0]),
	.prev_state_2		(NIC1_prev_state_2[3:0]),
	.current_state		(NIC1_curr_state[3:0])
);

wire	[3:0] Mstr_prev_state;
wire	[3:0] Mstr_prev_state_1;
wire	[3:0] Mstr_prev_state_2;
wire	[3:0] Mstr_curr_state;

State_Multiple_Logger#
(
	.bits				(4)
)
REGs_Mstr_state_Logger
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b1),
	.iEnable			(1'b1),
	
	.iDbgSt				({
						wDBG_MSTR_SEQ_FSM_curr[3],
						wDBG_MSTR_SEQ_FSM_curr[2],
						wDBG_MSTR_SEQ_FSM_curr[1],
						wDBG_MSTR_SEQ_FSM_curr[0]
						}),

	.prev_state			(Mstr_prev_state[3:0]),
	.prev_state_1		(Mstr_prev_state_1[3:0]),
	.prev_state_2		(Mstr_prev_state_2[3:0]),
	.current_state		(Mstr_curr_state[3:0])
);

SMBusRegs#
(
	.i2c_slave_addr		(7'h1e)
)mSMBusRegs_BMC
(
	.CLK_IN         (wOSC),
	.RESET_N        (wRST_N),
	.scl_in         (scl_in),
	.sda_in         (sda_in),
	.sda_oe         (REGs_sda_oe),

	.iFPGA_REG_00   ({
					~wCHASSIS0_LEAK_Q_N_db_init,//~(wCHASSIS0_LEAK_Q_N_PLD_db & IOEXP4_output[4]),
					~wCHASSIS1_LEAK_Q_N_db_init,//~(wCHASSIS1_LEAK_Q_N_PLD_db & IOEXP4_output[5]),
					~wCHASSIS2_LEAK_Q_N_db_init,//~(wCHASSIS2_LEAK_Q_N_PLD_db & IOEXP4_output[4]),
					~wCHASSIS3_LEAK_Q_N_db_init,//~(wCHASSIS3_LEAK_Q_N_PLD_db & IOEXP4_output[5]),
					wPlatform_Config
					}),
	.iFPGA_REG_01   ({
					Reg_curr_state[94],
					Reg_curr_state[93],
					Reg_curr_state[92],
					Reg_curr_state[91],
					Reg_curr_state[90],
					Reg_curr_state[89],
					Reg_curr_state[88],
					Reg_curr_state[87]
					}),
	.iFPGA_REG_02   ({
					Reg_curr_state[86],
					Reg_curr_state[85],
					Reg_curr_state[84],
					Reg_curr_state[83],
					Reg_curr_state[82],
					Reg_curr_state[81],
					Reg_curr_state[80],
					Reg_curr_state[79]
					}),
	.iFPGA_REG_03   ({
					Reg_curr_state[78],
					3'b000,
					Reg_curr_state[77],
					Reg_curr_state[76],
					Reg_curr_state[75],
					Reg_curr_state[74]
					}),
	.iFPGA_REG_04   ({
					Reg_curr_state[73],
					Reg_curr_state[72],
					Reg_curr_state[71],
					Reg_curr_state[70],
					Reg_curr_state[69],
					Reg_curr_state[68],
					Reg_curr_state[67],
					Reg_curr_state[66]
					}),
	.iFPGA_REG_05   ({
					Reg_curr_state[65],
					Reg_curr_state[64],
					5'b00000,
					Reg_curr_state[63]
					}),
	.iFPGA_REG_06   ({
					Reg_curr_state[62],
					Reg_curr_state[61],
					Reg_curr_state[60],
					Reg_curr_state[59],
					Reg_curr_state[58],
					Reg_curr_state[57],
					Reg_curr_state[56],
					Reg_curr_state[55]
					}),
	.iFPGA_REG_07   ({
					Reg_curr_state[54],
					Reg_curr_state[53],
					Reg_curr_state[52],
					Reg_curr_state[51],
					Reg_curr_state[50],
					Reg_curr_state[49],
					Reg_curr_state[48],
					Reg_curr_state[47]
					}),
	.iFPGA_REG_08   ({
					Reg_curr_state[46],
					Reg_curr_state[45],
					Reg_curr_state[44],
					Reg_curr_state[43],
					Reg_curr_state[42],
					Reg_curr_state[41],
					Reg_curr_state[40],
					Reg_curr_state[39]
					}),
	.iFPGA_REG_09   ({
					Reg_curr_state[38],
					Reg_curr_state[37],
					Reg_curr_state[36],
					Reg_curr_state[35],
					Reg_curr_state[34],
					Reg_curr_state[33],
					Reg_curr_state[32],
					Reg_curr_state[31]
					}),
	.iFPGA_REG_0A   ({
					Reg_curr_state[30],
					Reg_curr_state[29],
					Reg_curr_state[28],
					Reg_curr_state[27],
					Reg_curr_state[26],
					Reg_curr_state[25],
					Reg_curr_state[24],
					Reg_curr_state[23]
					}),
	.iFPGA_REG_0B   ({
					Reg_curr_state[22],
					Reg_curr_state[21],
					Reg_curr_state[20],
					Reg_curr_state[19],
					Reg_curr_state[18],
					Reg_curr_state[17],
					Reg_curr_state[16],
					Reg_curr_state[15]
					}),
	.iFPGA_REG_0C   ({
					Reg_curr_state[14],
					Reg_curr_state[13],
					Reg_curr_state[12],
					Reg_curr_state[11],
					Reg_curr_state[10],
					Reg_curr_state[9],
					Reg_curr_state[8],
					Reg_curr_state[7]
					}),
	.iFPGA_REG_0D   ({
					1'b0,
					Reg_curr_state[6],
					Reg_curr_state[5],
					Reg_curr_state[4],
					Reg_curr_state[3],
					Reg_curr_state[2],
					Reg_curr_state[1],
					Reg_curr_state[0]
					}),
	.iFPGA_REG_0E   ({
					NIC0_curr_state,
					NIC1_curr_state
					}),
	.iFPGA_REG_0F  	({
					1'b0,
					~RSVD_RMC_GPIO3_R,
					~LEAK_DETECT_RMC_N_R,
					~wLeak_ConfigDone,
					Mstr_curr_state
					}),
	.iFPGA_REG_10   ({
					~wCHASSIS0_LEAK_Q_N_db_init_bmc,
					~wCHASSIS1_LEAK_Q_N_db_init_bmc,
					~wCHASSIS2_LEAK_Q_N_db_init_bmc,
					~wCHASSIS3_LEAK_Q_N_db_init_bmc,
					leak_config_curr_state
					}),
	.iFPGA_REG_11   ({
					Reg_prev_state_2[94],
					Reg_prev_state_2[93],
					Reg_prev_state_2[92],
					Reg_prev_state_2[91],
					Reg_prev_state_2[90],
					Reg_prev_state_2[89],
					Reg_prev_state_2[88],
					Reg_prev_state_2[87]
					}),
	.iFPGA_REG_12   ({
					Reg_prev_state_2[86],
					Reg_prev_state_2[85],
					Reg_prev_state_2[84],
					Reg_prev_state_2[83],
					Reg_prev_state_2[82],
					Reg_prev_state_2[81],
					Reg_prev_state_2[80],
					Reg_prev_state_2[79]
					}),
	.iFPGA_REG_13   ({
					Reg_prev_state_2[78],
					3'b000,
					Reg_prev_state_2[77],
					Reg_prev_state_2[76],
					Reg_prev_state_2[75],
					Reg_prev_state_2[74]
					}),
	.iFPGA_REG_14   ({
					Reg_prev_state_2[73],
					Reg_prev_state_2[72],
					Reg_prev_state_2[71],
					Reg_prev_state_2[70],
					Reg_prev_state_2[69],
					Reg_prev_state_2[68],
					Reg_prev_state_2[67],
					Reg_prev_state_2[66]
					}),
	.iFPGA_REG_15   ({
					Reg_prev_state_2[65],
					Reg_prev_state_2[64],
					5'b00000,
					Reg_prev_state_2[63]
					}),
	.iFPGA_REG_16   ({
					Reg_prev_state_2[62],
					Reg_prev_state_2[61],
					Reg_prev_state_2[60],
					Reg_prev_state_2[59],
					Reg_prev_state_2[58],
					Reg_prev_state_2[57],
					Reg_prev_state_2[56],
					Reg_prev_state_2[55]
					}),
	.iFPGA_REG_17   ({
					Reg_prev_state_2[54],
					Reg_prev_state_2[53],
					Reg_prev_state_2[52],
					Reg_prev_state_2[51],
					Reg_prev_state_2[50],
					Reg_prev_state_2[49],
					Reg_prev_state_2[48],
					Reg_prev_state_2[47]
					}),
	.iFPGA_REG_18   ({
					Reg_prev_state_2[46],
					Reg_prev_state_2[45],
					Reg_prev_state_2[44],
					Reg_prev_state_2[43],
					Reg_prev_state_2[42],
					Reg_prev_state_2[41],
					Reg_prev_state_2[40],
					Reg_prev_state_2[39]
					}),
	.iFPGA_REG_19   ({
					Reg_prev_state_2[38],
					Reg_prev_state_2[37],
					Reg_prev_state_2[36],
					Reg_prev_state_2[35],
					Reg_prev_state_2[34],
					Reg_prev_state_2[33],
					Reg_prev_state_2[32],
					Reg_prev_state_2[31]
					}),
	.iFPGA_REG_1A   ({
					Reg_prev_state_2[30],
					Reg_prev_state_2[29],
					Reg_prev_state_2[28],
					Reg_prev_state_2[27],
					Reg_prev_state_2[26],
					Reg_prev_state_2[25],
					Reg_prev_state_2[24],
					Reg_prev_state_2[23]
					}),
	.iFPGA_REG_1B   ({
					Reg_prev_state_2[22],
					Reg_prev_state_2[21],
					Reg_prev_state_2[20],
					Reg_prev_state_2[19],
					Reg_prev_state_2[18],
					Reg_prev_state_2[17],
					Reg_prev_state_2[16],
					Reg_prev_state_2[15]
					}),
	.iFPGA_REG_1C   ({
					Reg_prev_state_2[14],
					Reg_prev_state_2[13],
					Reg_prev_state_2[12],
					Reg_prev_state_2[11],
					Reg_prev_state_2[10],
					Reg_prev_state_2[9],
					Reg_prev_state_2[8],
					Reg_prev_state_2[7]
					}),
	.iFPGA_REG_1D   ({
					1'b0,
					Reg_prev_state_2[6],
					Reg_prev_state_2[5],
					Reg_prev_state_2[4],
					Reg_prev_state_2[3],
					Reg_prev_state_2[2],
					Reg_prev_state_2[1],
					Reg_prev_state_2[0]
					}),
	.iFPGA_REG_1E   ({
					NIC0_prev_state_2,
					NIC1_prev_state_2
					}),
	.iFPGA_REG_1F   ({
					4'h0,
					Mstr_prev_state_2
					}),
	.iFPGA_REG_20   ({
					wFM_BOARD_BMC_SKU_ID3,
					wFM_BOARD_BMC_SKU_ID2,
					wFM_BOARD_BMC_SKU_ID1,
					wFM_BOARD_BMC_SKU_ID0,
					leak_config_prev_state_2
					}),
	.iFPGA_REG_21   ({
					Reg_prev_state_1[94],
					Reg_prev_state_1[93],
					Reg_prev_state_1[92],
					Reg_prev_state_1[91],
					Reg_prev_state_1[90],
					Reg_prev_state_1[89],
					Reg_prev_state_1[88],
					Reg_prev_state_1[87]
					}),
	.iFPGA_REG_22   ({
					Reg_prev_state_1[86],
					Reg_prev_state_1[85],
					Reg_prev_state_1[84],
					Reg_prev_state_1[83],
					Reg_prev_state_1[82],
					Reg_prev_state_1[81],
					Reg_prev_state_1[80],
					Reg_prev_state_1[79]
					}),
	.iFPGA_REG_23   ({
					Reg_prev_state_1[78],
					3'b000,
					Reg_prev_state_1[77],
					Reg_prev_state_1[76],
					Reg_prev_state_1[75],
					Reg_prev_state_1[74]
					}),
	.iFPGA_REG_24   ({
					Reg_prev_state_1[73],
					Reg_prev_state_1[72],
					Reg_prev_state_1[71],
					Reg_prev_state_1[70],
					Reg_prev_state_1[69],
					Reg_prev_state_1[68],
					Reg_prev_state_1[67],
					Reg_prev_state_1[66]
					}),
	.iFPGA_REG_25   ({
					Reg_prev_state_1[65],
					Reg_prev_state_1[64],
					5'b00000,
					Reg_prev_state_1[63]
					}),
	.iFPGA_REG_26   ({
					Reg_prev_state_1[62],
					Reg_prev_state_1[61],
					Reg_prev_state_1[60],
					Reg_prev_state_1[59],
					Reg_prev_state_1[58],
					Reg_prev_state_1[57],
					Reg_prev_state_1[56],
					Reg_prev_state_1[55]
					}),
	.iFPGA_REG_27   ({
					Reg_prev_state_1[54],
					Reg_prev_state_1[53],
					Reg_prev_state_1[52],
					Reg_prev_state_1[51],
					Reg_prev_state_1[50],
					Reg_prev_state_1[49],
					Reg_prev_state_1[48],
					Reg_prev_state_1[47]
					}),
	.iFPGA_REG_28   ({
					Reg_prev_state_1[46],
					Reg_prev_state_1[45],
					Reg_prev_state_1[44],
					Reg_prev_state_1[43],
					Reg_prev_state_1[42],
					Reg_prev_state_1[41],
					Reg_prev_state_1[40],
					Reg_prev_state_1[39]
					}),
	.iFPGA_REG_29   ({
					Reg_prev_state_1[38],
					Reg_prev_state_1[37],
					Reg_prev_state_1[36],
					Reg_prev_state_1[35],
					Reg_prev_state_1[34],
					Reg_prev_state_1[33],
					Reg_prev_state_1[32],
					Reg_prev_state_1[31]
					}),
	.iFPGA_REG_2A   ({
					Reg_prev_state_1[30],
					Reg_prev_state_1[29],
					Reg_prev_state_1[28],
					Reg_prev_state_1[27],
					Reg_prev_state_1[26],
					Reg_prev_state_1[25],
					Reg_prev_state_1[24],
					Reg_prev_state_1[23]
					}),
	.iFPGA_REG_2B   ({
					Reg_prev_state_1[22],
					Reg_prev_state_1[21],
					Reg_prev_state_1[20],
					Reg_prev_state_1[19],
					Reg_prev_state_1[18],
					Reg_prev_state_1[17],
					Reg_prev_state_1[16],
					Reg_prev_state_1[15]
					}),
	.iFPGA_REG_2C   ({
					Reg_prev_state_1[14],
					Reg_prev_state_1[13],
					Reg_prev_state_1[12],
					Reg_prev_state_1[11],
					Reg_prev_state_1[10],
					Reg_prev_state_1[9],
					Reg_prev_state_1[8],
					Reg_prev_state_1[7]
					}),
	.iFPGA_REG_2D   ({
					1'b0,
					Reg_prev_state_1[6],
					Reg_prev_state_1[5],
					Reg_prev_state_1[4],
					Reg_prev_state_1[3],
					Reg_prev_state_1[2],
					Reg_prev_state_1[1],
					Reg_prev_state_1[0]
					}),
	.iFPGA_REG_2E   ({
					NIC0_prev_state_1,
					NIC1_prev_state_1
					}),
	.iFPGA_REG_2F   ({
					4'h0,
					Mstr_prev_state_1
					}),
	.iFPGA_REG_30   ({
					1'b0,
					wFAB_BMC_REV_ID2,
					wFAB_BMC_REV_ID1,
					wFAB_BMC_REV_ID0,
					leak_config_prev_state_1
					}),
	.iFPGA_REG_31   ({
					Reg_prev_state[94],
					Reg_prev_state[93],
					Reg_prev_state[92],
					Reg_prev_state[91],
					Reg_prev_state[90],
					Reg_prev_state[89],
					Reg_prev_state[88],
					Reg_prev_state[87]
					}),
	.iFPGA_REG_32   ({
					Reg_prev_state[86],
					Reg_prev_state[85],
					Reg_prev_state[84],
					Reg_prev_state[83],
					Reg_prev_state[82],
					Reg_prev_state[81],
					Reg_prev_state[80],
					Reg_prev_state[79]
					}),
	.iFPGA_REG_33   ({
					Reg_prev_state[78],
					3'b000,
					Reg_prev_state[77],
					Reg_prev_state[76],
					Reg_prev_state[75],
					Reg_prev_state[74]
					}),
	.iFPGA_REG_34   ({
					Reg_prev_state[73],
					Reg_prev_state[72],
					Reg_prev_state[71],
					Reg_prev_state[70],
					Reg_prev_state[69],
					Reg_prev_state[68],
					Reg_prev_state[67],
					Reg_prev_state[66]
					}),
	.iFPGA_REG_35   ({
					Reg_prev_state[65],
					Reg_prev_state[64],
					5'b00000,
					Reg_prev_state[63]
					}),
	.iFPGA_REG_36   ({
					Reg_prev_state[62],
					Reg_prev_state[61],
					Reg_prev_state[60],
					Reg_prev_state[59],
					Reg_prev_state[58],
					Reg_prev_state[57],
					Reg_prev_state[56],
					Reg_prev_state[55]
					}),
	.iFPGA_REG_37   ({
					Reg_prev_state[54],
					Reg_prev_state[53],
					Reg_prev_state[52],
					Reg_prev_state[51],
					Reg_prev_state[50],
					Reg_prev_state[49],
					Reg_prev_state[48],
					Reg_prev_state[47]
					}),
	.iFPGA_REG_38   ({
					Reg_prev_state[46],
					Reg_prev_state[45],
					Reg_prev_state[44],
					Reg_prev_state[43],
					Reg_prev_state[42],
					Reg_prev_state[41],
					Reg_prev_state[40],
					Reg_prev_state[39]
					}),
	.iFPGA_REG_39   ({
					Reg_prev_state[38],
					Reg_prev_state[37],
					Reg_prev_state[36],
					Reg_prev_state[35],
					Reg_prev_state[34],
					Reg_prev_state[33],
					Reg_prev_state[32],
					Reg_prev_state[31]
					}),
	.iFPGA_REG_3A   ({
					Reg_prev_state[30],
					Reg_prev_state[29],
					Reg_prev_state[28],
					Reg_prev_state[27],
					Reg_prev_state[26],
					Reg_prev_state[25],
					Reg_prev_state[24],
					Reg_prev_state[23]
					}),
	.iFPGA_REG_3B   ({
					Reg_prev_state[22],
					Reg_prev_state[21],
					Reg_prev_state[20],
					Reg_prev_state[19],
					Reg_prev_state[18],
					Reg_prev_state[17],
					Reg_prev_state[16],
					Reg_prev_state[15]
					}),
	.iFPGA_REG_3C   ({
					Reg_prev_state[14],
					Reg_prev_state[13],
					Reg_prev_state[12],
					Reg_prev_state[11],
					Reg_prev_state[10],
					Reg_prev_state[9],
					Reg_prev_state[8],
					Reg_prev_state[7]
					}),
	.iFPGA_REG_3D   ({
					1'b0,
					Reg_prev_state[6],
					Reg_prev_state[5],
					Reg_prev_state[4],
					Reg_prev_state[3],
					Reg_prev_state[2],
					Reg_prev_state[1],
					Reg_prev_state[0]
					}),
	.iFPGA_REG_3E   ({
					NIC0_prev_state,
					NIC1_prev_state
					}),
	.iFPGA_REG_3F   ({
					4'h0,
					Mstr_prev_state
					})
);

GlitchFilter #
	(
		.NUMBER_OF_SIGNALS  (70)
	) 
	mGlitchFilter
	(
		.iClk               (wCLK_2M),
		.iARst_n            (wRST_N),
		.iSRst_n            (1'b1),
		.iEna               (1'b1),
		.iSignal            
			(
				{
					FM_MAIN_PWREN_RMC_EN_ISO_R,
					NODEA_PSU_SMB_ALERT_R_L,
					NODEB_PSU_SMB_ALERT_R_L,
					NODEA_NODEB_PWOK_PLD_ISO_R,
					P12V_AUX_FAN_FAULT_PLD_N,
					P12V_AUX_FAN_ALERT_PLD_N,
					P12V_AUX_FAN_OC_PLD_N,
					PWRGD_P12V_AUX_FAN_PLD,
					FAN_0_PRESENT_N,
					FAN_1_PRESENT_N,
					FAN_2_PRESENT_N,
					FAN_3_PRESENT_N,
					FAN_4_PRESENT_N,
					FAN_5_PRESENT_N,
					FAN_6_PRESENT_N,
					FAN_7_PRESENT_N,
					FM_PLD_LEAK_DETECT_PWM,
					PRSNT_CHASSIS0_LEAK_CABLE_R_N,
					CHASSIS0_LEAK_Q_N_PLD,
					LEAK0_DETECT_R,
					PRSNT_CHASSIS1_LEAK_CABLE_R_N,
					CHASSIS1_LEAK_Q_N_PLD,
					LEAK1_DETECT_R,
					PRSNT_CHASSIS2_LEAK_CABLE_R_N,
					CHASSIS2_LEAK_Q_N_PLD,
					LEAK2_DETECT_R,
					PRSNT_CHASSIS3_LEAK_CABLE_R_N,
					CHASSIS3_LEAK_Q_N_PLD,
					LEAK3_DETECT_R,
					FM_BOARD_BMC_SKU_ID0,
					FM_BOARD_BMC_SKU_ID1,
					FM_BOARD_BMC_SKU_ID2,
					FM_BOARD_BMC_SKU_ID3,
					FAB_BMC_REV_ID0,
					FAB_BMC_REV_ID1,
					FAB_BMC_REV_ID2,
					SMB_RJ45_FIO_TMP_ALERT,
					PRSNT_RJ45_FIO_N_R,
					RSVD_RMC_GPIO3_R,
					HP_OCP_V3_1_HSC_PWRGD_PLD_R,
					HP_LVC3_OCP_V3_1_PRSNT2_PLD_N,
					HP_LVC3_OCP_V3_1_PWRGD_PLD,
					OCP_SFF_PERST_FROM_HOST_ISO_PLD_N,
					OCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N,
					FM_P3V3_NIC0_FAULT_R_N,
					FM_P12V_NIC0_FLTB_R_N,
					P12V_AUX_NIC0_SENSE_ALERT_R_N,
					FM_OCP_SFF_PWR_GOOD_PLD,
					HP_OCP_V3_2_HSC_PWRGD_PLD_R,
					HP_LVC3_OCP_V3_2_PRSNT2_PLD_N,
					HP_LVC3_OCP_V3_2_PWRGD_PLD,
					OCP_V3_2_PERST_FROM_HOST_ISO_PLD_N,
					OCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N,
					FM_P3V3_NIC1_FAULT_R_N,
					FM_P12V_NIC1_FLTB_R_N,
					P12V_AUX_NIC1_SENSE_ALERT_R_N,
					FM_OCP_V3_2_PWR_GOOD_PLD,
					P12V_AUX_PSU_SMB_ALERT_R_L,
					P52V_SENSE_ALERT_PLD_N,
					P48V_HS1_FAULT_N_PLD,
					P48V_HS2_FAULT_N_PLD,
					PWRGD_P3V3_AUX_PLD,
					PWRGD_P12V_AUX_PLD_ISO_R,
					PRSNT_OSFP0_POWER_CABLE_N,
					PRSNT_HDDBD_POWER_CABLE_N,
					P12V_SCM_SENSE_ALERT_R_N,
					PDB_P12V_EN_N_ISO_PLD_R,
					PWR_BTN_BMC_R_N,
					P12V_N1_ENABLE_PLD_R,
					P12V_N2_ENABLE_PLD_R
				}
			),
		.oFilteredSignals       
			(
				{
					wFM_MAIN_PWREN_RMC_EN_ISO_R,
					wNODEA_PSU_SMB_ALERT_R_L,
					wNODEB_PSU_SMB_ALERT_R_L,
					wNODEA_NODEB_PWOK_PLD_ISO_R,
					wP12V_AUX_FAN_FAULT_PLD_N,
					wP12V_AUX_FAN_ALERT_PLD_N,
					wP12V_AUX_FAN_OC_PLD_N,
					wPWRGD_P12V_AUX_FAN_PLD,
					wFAN_0_PRESENT_N,
					wFAN_1_PRESENT_N,
					wFAN_2_PRESENT_N,
					wFAN_3_PRESENT_N,
					wFAN_4_PRESENT_N,
					wFAN_5_PRESENT_N,
					wFAN_6_PRESENT_N,
					wFAN_7_PRESENT_N,
					wFM_PLD_LEAK_DETECT_PWM,
					wPRSNT_CHASSIS0_LEAK_CABLE_R_N,
					wCHASSIS0_LEAK_Q_N_PLD,
					wLEAK0_DETECT_R,
					wPRSNT_CHASSIS1_LEAK_CABLE_R_N,
					wCHASSIS1_LEAK_Q_N_PLD,
					wLEAK1_DETECT_R,
					wPRSNT_CHASSIS2_LEAK_CABLE_R_N,
					wCHASSIS2_LEAK_Q_N_PLD,
					wLEAK2_DETECT_R,
					wPRSNT_CHASSIS3_LEAK_CABLE_R_N,
					wCHASSIS3_LEAK_Q_N_PLD,
					wLEAK3_DETECT_R,
					wFM_BOARD_BMC_SKU_ID0,
					wFM_BOARD_BMC_SKU_ID1,
					wFM_BOARD_BMC_SKU_ID2,
					wFM_BOARD_BMC_SKU_ID3,
					wFAB_BMC_REV_ID0,
					wFAB_BMC_REV_ID1,
					wFAB_BMC_REV_ID2,
					wSMB_RJ45_FIO_TMP_ALERT,
					wPRSNT_RJ45_FIO_N_R,
					wRSVD_RMC_GPIO3_R,
					wHP_OCP_V3_1_HSC_PWRGD_PLD_R,
					wHP_LVC3_OCP_V3_1_PRSNT2_PLD_N,
					wHP_LVC3_OCP_V3_1_PWRGD_PLD,
					wOCP_SFF_PERST_FROM_HOST_ISO_PLD_N,
					wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N,
					wFM_P3V3_NIC0_FAULT_R_N,
					wFM_P12V_NIC0_FLTB_R_N,
					wP12V_AUX_NIC0_SENSE_ALERT_R_N,
					wFM_OCP_SFF_PWR_GOOD_PLD,
					wHP_OCP_V3_2_HSC_PWRGD_PLD_R,
					wHP_LVC3_OCP_V3_2_PRSNT2_PLD_N,
					wHP_LVC3_OCP_V3_2_PWRGD_PLD,
					wOCP_V3_2_PERST_FROM_HOST_ISO_PLD_N,
					wOCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N,
					wFM_P3V3_NIC1_FAULT_R_N,
					wFM_P12V_NIC1_FLTB_R_N,
					wP12V_AUX_NIC1_SENSE_ALERT_R_N,
					wFM_OCP_V3_2_PWR_GOOD_PLD,
					wP12V_AUX_PSU_SMB_ALERT_R_L,
					wP52V_SENSE_ALERT_PLD_N,
					wP48V_HS1_FAULT_N_PLD,
					wP48V_HS2_FAULT_N_PLD,
					wPWRGD_P3V3_AUX_PLD,
					wPWRGD_P12V_AUX_PLD_ISO_R,
					wPRSNT_OSFP0_POWER_CABLE_N,
					wPRSNT_HDDBD_POWER_CABLE_N,
					wP12V_SCM_SENSE_ALERT_R_N,
					wPDB_P12V_EN_N_ISO_PLD_R,
					wPWR_BTN_BMC_R_N,
					wP12V_N1_ENABLE_PLD_R,
					wP12V_N2_ENABLE_PLD_R
				}
			)
	);
`ifdef noUFM
	//	SMBus CLk setting 100KHz
	SMBusFWUpdate mSMBusFWUpdate 
	(
		.wb_clk_i      (wOSC),
		.i2c1_scl      (I2C_3V3_15_SCL_R),
		.i2c1_sda      (I2C_3V3_15_SDA_R),
		.i2c1_irqo     ()
	);
`else
	wire	wFLT_Detect_status_change;
	wire	wFLT_Detect_timeout;
	wire	wFLT_Detect_full_rise_extend;

	//State_Single_Logger#
	//(
	//	.bits				(54)
	//)
	//FLT_Detect_status
	//(
	//	.iClk				(wCLK_2M),
	//	.iRst_n				(wRST_N),
	//	.iClear				(~wFLT_Detect_timeout),
	//	.iEnable			(1'b1),
	//
	//	.iDbgSt				({
	//						wP12V_AUX_SEQPWR_FLT_N,
	//						wP12V_FAN_SEQPWR_FLT_N,
	//						wP12V_N1N2_SEQPWR_FLT_N,
	//						wP12V_AUX_RUNTIME_FLT_N,
	//						wP12V_FAN_RUNTIME_FLT_N,
	//						wP12V_N1N2_RUNTIME_FLT_N,
	//						wAUX_SEQPWR_FLT_NIC0_N,
	//						wP12V_SEQPWR_FLT_NIC0_N,
	//						wAUX_RUNTIME_FLT_NIC0_N,
	//						wP12V_RUNTIME_FLT_NIC0_N,
	//						wAUX_SEQPWR_FLT_NIC1_N,
	//						wP12V_SEQPWR_FLT_NIC1_N,
	//						wAUX_RUNTIME_FLT_NIC1_N,
	//						wP12V_RUNTIME_FLT_NIC1_N,
	//						wP12V_AUX_FAN_FAULT_PLD_N,
	//						wP12V_AUX_FAN_OC_PLD_N,
	//						wP48V_HS1_FAULT_N_PLD,
	//						wP48V_HS2_FAULT_N_PLD,
	//						wFM_P3V3_NIC0_FAULT_R_N,
	//						wFM_P12V_NIC0_FLTB_R_N,
	//						wFM_P3V3_NIC1_FAULT_R_N,
	//						wFM_P12V_NIC1_FLTB_R_N,
	//						wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N,
	//						wOCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N,
	//						wP52V_SENSE_ALERT_PLD_N,
	//						wP12V_AUX_FAN_ALERT_PLD_N,
	//						wNODEA_PSU_SMB_ALERT_R_L,
	//						wNODEB_PSU_SMB_ALERT_R_L,
	//						wP12V_AUX_NIC0_SENSE_ALERT_R_N,
	//						wP12V_AUX_NIC1_SENSE_ALERT_R_N,
	//						wP12V_SCM_SENSE_ALERT_R_N,
	//						wP12V_AUX_PSU_SMB_ALERT_R_L,
	//						wSMB_RJ45_FIO_TMP_ALERT,
	//						wCHASSIS0_LEAK_Q_N_PLD,
	//						wCHASSIS1_LEAK_Q_N_PLD,
	//						wCHASSIS2_LEAK_Q_N_PLD,
	//						wCHASSIS3_LEAK_Q_N_PLD,
	//						wPRSNT_RJ45_FIO_N_R,
	//						wFAN_0_PRESENT_N,
	//						wFAN_1_PRESENT_N,
	//						wFAN_2_PRESENT_N,
	//						wFAN_3_PRESENT_N,
	//						wFAN_4_PRESENT_N,
	//						wFAN_5_PRESENT_N,
	//						wFAN_6_PRESENT_N,
	//						wFAN_7_PRESENT_N,
	//						wPRSNT_CHASSIS0_LEAK_CABLE_R_N,
	//						wPRSNT_CHASSIS1_LEAK_CABLE_R_N,
	//						wPRSNT_CHASSIS2_LEAK_CABLE_R_N,
	//						wPRSNT_CHASSIS3_LEAK_CABLE_R_N,
	//						wPRSNT_OSFP0_POWER_CABLE_N,
	//    					wPRSNT_HDDBD_POWER_CABLE_N,
	//						wHP_LVC3_OCP_V3_1_PRSNT2_PLD_N,
	//    					wHP_LVC3_OCP_V3_2_PRSNT2_PLD_N
	//						}),
	//
	//	.ochange			(wFLT_Detect_status_change)
	//);
	//
	//dly_timer#
	//(
	//	.pulse_constant		(1'b0)
	//)
	//mFLT_detect_dly_timer
	//(
	//	.clk_in				(wCLK_1us),
	//	.iRst_n				(wRST_N),
	//	.iClear				(1'b1),
	//	.dly_timer_en		(wFLT_Detect_status_change),
	//	.dly_timer_start	(1'b1),
	//	.dly_time			(16'd3),
	//	.dly_timeout		(wFLT_Detect_timeout)
	//);

	assign wFLT_Detect_status_change	= ~FM_PDB_HEALTH_R_N;

	Edge_Detector UFM_FLT_Fall_Detect
	(
		.iClk					(wOSC),
		.iClk_delay				(wCLK_1us),
		.iRst_n					(wRST_N),
		.iClear					(1'b1),
		.iDelay_time			(16'd1000),

		.pos_neg				(1'b0),
		.both					(1'b0),
		.input_sig				(wFLT_Detect_status_change),

		.output_ext_pulse_sig	(wFLT_Detect_full_rise_extend)
	);

	wire	wUFM_page_read;
	wire	wUFM_offset_read;
	wire	wUFM_erase_detect;

	reg	[93:0] 	UFM_FLT_prev_state;
	reg	[93:0] 	UFM_FLT_prev_state_1;
	reg	[93:0] 	UFM_FLT_prev_state_2;
	reg	[93:0] 	UFM_FLT_curr_state;
	reg	[2:0]	rCount;
	reg write;

	always @(posedge wOSC or negedge wRST_N or posedge wUFM_erase_detect) begin
		if(!wRST_N || wUFM_erase_detect) begin
			rCount						<=	3'b000;
			write						<=	1'b0;
		end
		else begin
			case(rCount)
				3'b000: begin
					if(wFLT_Detect_status_change && !write) begin
						UFM_FLT_prev_state		<=	0;
						UFM_FLT_prev_state_1	<=	0;
						UFM_FLT_prev_state_2	<=	0;
						UFM_FLT_curr_state		<=	Reg_curr_state;
						write					<=	1'b1;
					end
					else if(write && !wFLT_Detect_status_change)begin
						rCount					<=	3'b001;
						write					<=	1'b0;
					end
					else begin
						rCount					<=	3'b000;
						write					<=	1'b0;
					end
				end
				3'b001: begin
					if(wFLT_Detect_status_change && !write) begin
						UFM_FLT_prev_state_2	<=	UFM_FLT_curr_state;
						UFM_FLT_curr_state		<=	Reg_curr_state;
						write					<=	1'b1;
					end
					else if(write && !wFLT_Detect_status_change)begin
						rCount					<=	3'b010;
						write					<=	1'b0;
					end
					else begin
						rCount					<=	3'b001;
						write					<=	1'b0;
					end
				end
				3'b010: begin
					if(wFLT_Detect_status_change && !write) begin
						UFM_FLT_prev_state_1	<=	UFM_FLT_prev_state_2;
						UFM_FLT_prev_state_2	<=	UFM_FLT_curr_state;
						UFM_FLT_curr_state		<=	Reg_curr_state;
						write					<=	1'b1;
					end
					else if(write && !wFLT_Detect_status_change)begin
						rCount					<=	3'b011;
						write					<=	1'b0;
					end
					else begin
						rCount					<=	3'b010;
						write					<=	1'b0;
					end
				end
				3'b011: begin
					if(wFLT_Detect_status_change && !write) begin
						UFM_FLT_prev_state		<=	UFM_FLT_prev_state_1;
						UFM_FLT_prev_state_1	<=	UFM_FLT_prev_state_2;
						UFM_FLT_prev_state_2	<=	UFM_FLT_curr_state;
						UFM_FLT_curr_state		<=	Reg_curr_state;
						write					<=	1'b1;
					end
					else if(write && !wFLT_Detect_status_change)begin
						rCount					<=	3'b000;
						write					<=	1'b0;
					end
					else begin
						rCount					<=	3'b011;
						write					<=	1'b0;
					end
				end
			endcase
		end
	end

	Edge_Detector mUFM_page_read_detect
	(
		.iClk					(wOSC),
		.iClk_delay				(wCLK_1ms),
		.iRst_n					(wRST_N),
		.iClear					(1'b1),
		.iDelay_time			(16'd2000),

		.pos_neg				(1'b1),
		.both					(1'b0),
		.input_sig				(ufm_page[2:0] == 3'b100),

		.output_ext_pulse_sig	(wUFM_page_read)
	);

	Edge_Detector mUFM_offset_read_detect
	(
		.iClk					(wOSC),
		.iClk_delay				(wCLK_1ms),
		.iRst_n					(wRST_N),
		.iClear					(1'b1),
		.iDelay_time			(16'd2000),

		.pos_neg				(1'b1),
		.both					(1'b0),
		.input_sig				(mem_addr == 4'hf),

		.output_ext_pulse_sig	(wUFM_offset_read)
	);

	Edge_Detector mUFM_erase_detect
	(
		.iClk					(wOSC),
		.iClk_delay				(wCLK_1ms),
		.iRst_n					(wRST_N),
		.iClear					(1'b1),
		.iDelay_time			(16'd5),

		.pos_neg				(1'b0),
		.both					(1'b0),
		.input_sig				(wUFM_page_read & wUFM_offset_read),

		.output_ext_pulse_sig	(wUFM_erase_detect)
	);

	//////////////////////////////////////////////////////////////////////////////////
	//EVENT_SAVE_UFM with UFM Map//
	//////////////////////////////////////////////////////////////////////////////////
	parameter    UFM_Buf_address = 7'h1f;//This SAVE EVENT I2C ID
	wire [511:0] gpi;
	//ufm_wb_top
	wire [2:0] 	 cmd;
	wire [10:0]	 ufm_page;
	wire       	 GO;
	wire		 BUSY;
	wire		 ERR;			
	//////////////////// DPRAM port B signals ///////////////////////
	wire       	 mem_we;
	wire       	 mem_ce;
	wire [3:0] 	 mem_addr;
	wire [7:0] 	 mem_wr_data;
	wire [7:0] 	 mem_rd_data;
	wire 		 EFB_scl;
	wire 		 EFB_sda;

	wire		 buf_ready_o;					//UFM Module ready for action
	wire       	 En_UFM_SAVE_i;					//This Enable EVENT SAVE to UFM
	wire       	 enter_earse_i;					//This ERASE UFM

	assign     	 En_UFM_SAVE_i = wFLT_Detect_full_rise_extend;
	assign     	 enter_earse_i = wUFM_erase_detect;
	
	ufm_rw_top inst_URW
	(
		.bmc_DEV_ID				(UFM_Buf_address),
		//ufm flash erase
		.En_UFM_SAVE_i          (En_UFM_SAVE_i),
		.enter_earse_i          (enter_earse_i),
		//BMC
		.bmc_sda_oe			    (UFM_sda_oe),
		.bmc_scl_oe			    (UFM_scl_oe),
		.bmc_sda_in			    (sda_in),
		.bmc_scl_in			    (scl_in),
		//DETECT EFB ID Disable UFM Trigger
		.EFB_scl_i              (EFB_scl),
		.EFB_sda_i              (EFB_sda),
		//EVNT
		.gpi                    (gpi),
		//flag
		.write2ufm_o            (write2ufm_o),
		.buf_ready_o            (buf_ready_o),
		//ufm_command
		.cmd					(cmd),
		.ufm_page				(ufm_page),
		.GO						(GO),
		.BUSY					(BUSY),
		.ERR					(ERR),
		.mem_we					(mem_we),
		.mem_ce					(mem_ce),
		.mem_addr				(mem_addr),
		.mem_wr_data			(mem_wr_data),
		.mem_rd_data			(mem_rd_data),
		//System
		.clk_i                  (wOSC),
		.resetn_i               (wRST_N)
	);

	wire [2:0]	i2c_cs = 3'b000; //Config ation feature_row sletect	
	ufm_wb_top inst_EFB
	(
		.clk_i					(wOSC),
		.ext_rstn				(wRST_N),
		.cmd					(cmd),
		.ufm_page				(ufm_page),
		.GO						(GO),
		.BUSY					(BUSY),
		.ERR					(ERR),
		.mem_clk				(wOSC),
		.mem_we					(mem_we),
		.mem_ce					(mem_ce),
		.mem_addr				(mem_addr),
		.mem_wr_data			(mem_wr_data),
		.mem_rd_data			(mem_rd_data),
		//FWUpdate
		.i2c1_scl               (I2C_3V3_15_SCL_R),
		.i2c1_sda               (I2C_3V3_15_SDA_R),
		//DETECT EFB ID Disable UFM Trigger
		.EFB_scl_o              (EFB_scl),
		.EFB_sda_o              (EFB_sda),	
		.i2c1_irqo              (),
		.i2c_cs					(i2c_cs)
	);

	assign gpi[((1+ 0)*8)-1: 0*8] 	= 	{
										8'h00
										};
	assign gpi[((1+ 1)*8)-1: 1*8] 	= 	{
										UFM_FLT_curr_state[94],
										UFM_FLT_curr_state[93],
										UFM_FLT_curr_state[92],
										UFM_FLT_curr_state[91],
										UFM_FLT_curr_state[90],
										UFM_FLT_curr_state[89],
										UFM_FLT_curr_state[88],
										UFM_FLT_curr_state[87]
										};
	assign gpi[((1+ 2)*8)-1: 2*8] 	= 	{
										UFM_FLT_curr_state[86],
										UFM_FLT_curr_state[85],
										UFM_FLT_curr_state[84],
										UFM_FLT_curr_state[83],
										UFM_FLT_curr_state[82],
										UFM_FLT_curr_state[81],
										UFM_FLT_curr_state[80],
										UFM_FLT_curr_state[79]
										};
	assign gpi[((1+ 3)*8)-1: 3*8]	=	{
										UFM_FLT_curr_state[78],
										3'b000,
										UFM_FLT_curr_state[77],
										UFM_FLT_curr_state[76],
										UFM_FLT_curr_state[75],
										UFM_FLT_curr_state[74]
										};
	assign gpi[((1+ 4)*8)-1: 4*8] 	=	{
										UFM_FLT_curr_state[73],
										UFM_FLT_curr_state[72],
										UFM_FLT_curr_state[71],
										UFM_FLT_curr_state[70],
										UFM_FLT_curr_state[69],
										UFM_FLT_curr_state[68],
										UFM_FLT_curr_state[67],
										UFM_FLT_curr_state[66]
										};
	assign gpi[((1+ 5)*8)-1: 5*8] 	=	{
										UFM_FLT_curr_state[65],
										UFM_FLT_curr_state[64],
										5'b00000,
										UFM_FLT_curr_state[63]
										};
	assign gpi[((1+ 6)*8)-1: 6*8]	=	{
										UFM_FLT_curr_state[62],
										UFM_FLT_curr_state[61],
										UFM_FLT_curr_state[60],
										UFM_FLT_curr_state[59],
										UFM_FLT_curr_state[58],
										UFM_FLT_curr_state[57],
										UFM_FLT_curr_state[56],
										UFM_FLT_curr_state[55]
										};
	assign gpi[((1+ 7)*8)-1: 7*8]	=	{
										UFM_FLT_curr_state[54],
										UFM_FLT_curr_state[53],
										UFM_FLT_curr_state[52],
										UFM_FLT_curr_state[51],
										UFM_FLT_curr_state[50],
										UFM_FLT_curr_state[49],
										UFM_FLT_curr_state[48],
										UFM_FLT_curr_state[47]
										};
	assign gpi[((1+ 8)*8)-1: 8*8]	=	{
										UFM_FLT_curr_state[46],
										UFM_FLT_curr_state[45],
										UFM_FLT_curr_state[44],
										UFM_FLT_curr_state[43],
										UFM_FLT_curr_state[42],
										UFM_FLT_curr_state[41],
										UFM_FLT_curr_state[40],
										UFM_FLT_curr_state[39]
										};
	assign gpi[((1+ 9)*8)-1: 9*8] 	= 	{
										UFM_FLT_curr_state[38],
										UFM_FLT_curr_state[37],
										UFM_FLT_curr_state[36],
										UFM_FLT_curr_state[35],
										UFM_FLT_curr_state[34],
										UFM_FLT_curr_state[33],
										UFM_FLT_curr_state[32],
										UFM_FLT_curr_state[31]
										};
	assign gpi[((1+ 10)*8)-1: 10*8] = 	{
										UFM_FLT_curr_state[30],
										UFM_FLT_curr_state[29],
										UFM_FLT_curr_state[28],
										UFM_FLT_curr_state[27],
										UFM_FLT_curr_state[26],
										UFM_FLT_curr_state[25],
										UFM_FLT_curr_state[24],
										UFM_FLT_curr_state[23]
										};
	assign gpi[((1+ 11)*8)-1: 11*8] = 	{
										UFM_FLT_curr_state[22],
										UFM_FLT_curr_state[21],
										UFM_FLT_curr_state[20],
										UFM_FLT_curr_state[19],
										UFM_FLT_curr_state[18],
										UFM_FLT_curr_state[17],
										UFM_FLT_curr_state[16],
										UFM_FLT_curr_state[15]
										};
	assign gpi[((1+ 12)*8)-1: 12*8]	=	{
										UFM_FLT_curr_state[14],
										UFM_FLT_curr_state[13],
										UFM_FLT_curr_state[12],
										UFM_FLT_curr_state[11],
										UFM_FLT_curr_state[10],
										UFM_FLT_curr_state[9],
										UFM_FLT_curr_state[8],
										UFM_FLT_curr_state[7]
										};
	assign gpi[((1+ 13)*8)-1: 13*8]	=	{
										1'b0,
										UFM_FLT_curr_state[6],
										UFM_FLT_curr_state[5],
										UFM_FLT_curr_state[4],
										UFM_FLT_curr_state[3],
										UFM_FLT_curr_state[2],
										UFM_FLT_curr_state[1],
										UFM_FLT_curr_state[0]
										};
	assign gpi[((1+ 14)*8)-1: 14*8]	=	{
										8'h00
										};
	assign gpi[((1+ 15)*8)-1: 15*8]	=	{
										8'h00
										};
	assign gpi[((1+ 16)*8)-1: 16*8] = 	{
										8'h00
										};
	assign gpi[((1+ 17)*8)-1: 17*8] = 	{
										UFM_FLT_prev_state_2[94],
										UFM_FLT_prev_state_2[93],
										UFM_FLT_prev_state_2[92],
										UFM_FLT_prev_state_2[91],
										UFM_FLT_prev_state_2[90],
										UFM_FLT_prev_state_2[89],
										UFM_FLT_prev_state_2[88],
										UFM_FLT_prev_state_2[87]
										};
	assign gpi[((1+ 18)*8)-1: 18*8] = 	{
										UFM_FLT_prev_state_2[86],
										UFM_FLT_prev_state_2[85],
										UFM_FLT_prev_state_2[84],
										UFM_FLT_prev_state_2[83],
										UFM_FLT_prev_state_2[82],
										UFM_FLT_prev_state_2[81],
										UFM_FLT_prev_state_2[80],
										UFM_FLT_prev_state_2[79]
										};
	assign gpi[((1+ 19)*8)-1: 19*8] = 	{
										UFM_FLT_prev_state_2[78],
										3'b000,
										UFM_FLT_prev_state_2[77],
										UFM_FLT_prev_state_2[76],
										UFM_FLT_prev_state_2[75],
										UFM_FLT_prev_state_2[74]
										};
	assign gpi[((1+ 20)*8)-1: 20*8] = 	{
										UFM_FLT_prev_state_2[73],
										UFM_FLT_prev_state_2[72],
										UFM_FLT_prev_state_2[71],
										UFM_FLT_prev_state_2[70],
										UFM_FLT_prev_state_2[69],
										UFM_FLT_prev_state_2[68],
										UFM_FLT_prev_state_2[67],
										UFM_FLT_prev_state_2[66]
										};
	assign gpi[((1+ 21)*8)-1: 21*8] = 	{
										UFM_FLT_prev_state_2[65],
										UFM_FLT_prev_state_2[64],
										5'b00000,
										UFM_FLT_prev_state_2[63]
										};
	assign gpi[((1+ 22)*8)-1: 22*8] = 	{
										UFM_FLT_prev_state_2[62],
										UFM_FLT_prev_state_2[61],
										UFM_FLT_prev_state_2[60],
										UFM_FLT_prev_state_2[59],
										UFM_FLT_prev_state_2[58],
										UFM_FLT_prev_state_2[57],
										UFM_FLT_prev_state_2[56],
										UFM_FLT_prev_state_2[55]
										};
	assign gpi[((1+ 23)*8)-1: 23*8] = 	{
										UFM_FLT_prev_state_2[54],
										UFM_FLT_prev_state_2[53],
										UFM_FLT_prev_state_2[52],
										UFM_FLT_prev_state_2[51],
										UFM_FLT_prev_state_2[50],
										UFM_FLT_prev_state_2[49],
										UFM_FLT_prev_state_2[48],
										UFM_FLT_prev_state_2[47]
										};
	assign gpi[((1+ 24)*8)-1: 24*8] = 	{
										UFM_FLT_prev_state_2[46],
										UFM_FLT_prev_state_2[45],
										UFM_FLT_prev_state_2[44],
										UFM_FLT_prev_state_2[43],
										UFM_FLT_prev_state_2[42],
										UFM_FLT_prev_state_2[41],
										UFM_FLT_prev_state_2[40],
										UFM_FLT_prev_state_2[39]
										};
	assign gpi[((1+ 25)*8)-1: 25*8] = 	{
										UFM_FLT_prev_state_2[38],
										UFM_FLT_prev_state_2[37],
										UFM_FLT_prev_state_2[36],
										UFM_FLT_prev_state_2[35],
										UFM_FLT_prev_state_2[34],
										UFM_FLT_prev_state_2[33],
										UFM_FLT_prev_state_2[32],
										UFM_FLT_prev_state_2[31]
										};
	assign gpi[((1+ 26)*8)-1: 26*8] = 	{
										UFM_FLT_prev_state_2[30],
										UFM_FLT_prev_state_2[29],
										UFM_FLT_prev_state_2[28],
										UFM_FLT_prev_state_2[27],
										UFM_FLT_prev_state_2[26],
										UFM_FLT_prev_state_2[25],
										UFM_FLT_prev_state_2[24],
										UFM_FLT_prev_state_2[23]
										};
	assign gpi[((1+ 27)*8)-1: 27*8] = 	{
										UFM_FLT_prev_state_2[22],
										UFM_FLT_prev_state_2[21],
										UFM_FLT_prev_state_2[20],
										UFM_FLT_prev_state_2[19],
										UFM_FLT_prev_state_2[18],
										UFM_FLT_prev_state_2[17],
										UFM_FLT_prev_state_2[16],
										UFM_FLT_prev_state_2[15]
										};
	assign gpi[((1+ 28)*8)-1: 28*8] = 	{
										UFM_FLT_prev_state_2[14],
										UFM_FLT_prev_state_2[13],
										UFM_FLT_prev_state_2[12],
										UFM_FLT_prev_state_2[11],
										UFM_FLT_prev_state_2[10],
										UFM_FLT_prev_state_2[9],
										UFM_FLT_prev_state_2[8],
										UFM_FLT_prev_state_2[7]
										};
	assign gpi[((1+ 29)*8)-1: 29*8] = 	{
										1'b0,
										UFM_FLT_prev_state_2[6],
										UFM_FLT_prev_state_2[5],
										UFM_FLT_prev_state_2[4],
										UFM_FLT_prev_state_2[3],
										UFM_FLT_prev_state_2[2],
										UFM_FLT_prev_state_2[1],
										UFM_FLT_prev_state_2[0]
										};
	assign gpi[((1+ 30)*8)-1: 30*8] = 	{
										8'h00
										};
	assign gpi[((1+ 31)*8)-1: 31*8] = 	{
										8'h00
										};
	assign gpi[((1+ 32)*8)-1: 32*8] = 	{
										8'h00
										};
	assign gpi[((1+ 33)*8)-1: 33*8] = 	{
										UFM_FLT_prev_state_1[94],
										UFM_FLT_prev_state_1[93],
										UFM_FLT_prev_state_1[92],
										UFM_FLT_prev_state_1[91],
										UFM_FLT_prev_state_1[90],
										UFM_FLT_prev_state_1[89],
										UFM_FLT_prev_state_1[88],
										UFM_FLT_prev_state_1[87]
										};
	assign gpi[((1+ 34)*8)-1: 34*8] = 	{
										UFM_FLT_prev_state_1[86],
										UFM_FLT_prev_state_1[85],
										UFM_FLT_prev_state_1[84],
										UFM_FLT_prev_state_1[83],
										UFM_FLT_prev_state_1[82],
										UFM_FLT_prev_state_1[81],
										UFM_FLT_prev_state_1[80],
										UFM_FLT_prev_state_1[79]
										};
	assign gpi[((1+ 35)*8)-1: 35*8] = 	{
										UFM_FLT_prev_state_1[78],
										3'b000,
										UFM_FLT_prev_state_1[77],
										UFM_FLT_prev_state_1[76],
										UFM_FLT_prev_state_1[75],
										UFM_FLT_prev_state_1[74]
										};
	assign gpi[((1+ 36)*8)-1: 36*8] = 	{
										UFM_FLT_prev_state_1[73],
										UFM_FLT_prev_state_1[72],
										UFM_FLT_prev_state_1[71],
										UFM_FLT_prev_state_1[70],
										UFM_FLT_prev_state_1[69],
										UFM_FLT_prev_state_1[68],
										UFM_FLT_prev_state_1[67],
										UFM_FLT_prev_state_1[66]
										};
	assign gpi[((1+ 37)*8)-1: 37*8] = 	{
										UFM_FLT_prev_state_1[65],
										UFM_FLT_prev_state_1[64],
										5'b00000,
										UFM_FLT_prev_state_1[63]
										};
	assign gpi[((1+ 38)*8)-1: 38*8] = 	{
										UFM_FLT_prev_state_1[62],
										UFM_FLT_prev_state_1[61],
										UFM_FLT_prev_state_1[60],
										UFM_FLT_prev_state_1[59],
										UFM_FLT_prev_state_1[58],
										UFM_FLT_prev_state_1[57],
										UFM_FLT_prev_state_1[56],
										UFM_FLT_prev_state_1[55]
										};
	assign gpi[((1+ 39)*8)-1: 39*8] = 	{
										UFM_FLT_prev_state_1[54],
										UFM_FLT_prev_state_1[53],
										UFM_FLT_prev_state_1[52],
										UFM_FLT_prev_state_1[51],
										UFM_FLT_prev_state_1[50],
										UFM_FLT_prev_state_1[49],
										UFM_FLT_prev_state_1[48],
										UFM_FLT_prev_state_1[47]
										};
	assign gpi[((1+ 40)*8)-1: 40*8] = 	{
										UFM_FLT_prev_state_1[46],
										UFM_FLT_prev_state_1[45],
										UFM_FLT_prev_state_1[44],
										UFM_FLT_prev_state_1[43],
										UFM_FLT_prev_state_1[42],
										UFM_FLT_prev_state_1[41],
										UFM_FLT_prev_state_1[40],
										UFM_FLT_prev_state_1[39]
										};
	assign gpi[((1+ 41)*8)-1: 41*8] = 	{
										UFM_FLT_prev_state_1[38],
										UFM_FLT_prev_state_1[37],
										UFM_FLT_prev_state_1[36],
										UFM_FLT_prev_state_1[35],
										UFM_FLT_prev_state_1[34],
										UFM_FLT_prev_state_1[33],
										UFM_FLT_prev_state_1[32],
										UFM_FLT_prev_state_1[31]
										};
	assign gpi[((1+ 42)*8)-1: 42*8] = 	{
										UFM_FLT_prev_state_1[30],
										UFM_FLT_prev_state_1[29],
										UFM_FLT_prev_state_1[28],
										UFM_FLT_prev_state_1[27],
										UFM_FLT_prev_state_1[26],
										UFM_FLT_prev_state_1[25],
										UFM_FLT_prev_state_1[24],
										UFM_FLT_prev_state_1[23]
										};
	assign gpi[((1+ 43)*8)-1: 43*8] = 	{
										UFM_FLT_prev_state_1[22],
										UFM_FLT_prev_state_1[21],
										UFM_FLT_prev_state_1[20],
										UFM_FLT_prev_state_1[19],
										UFM_FLT_prev_state_1[18],
										UFM_FLT_prev_state_1[17],
										UFM_FLT_prev_state_1[16],
										UFM_FLT_prev_state_1[15]
										};
	assign gpi[((1+ 44)*8)-1: 44*8] = 	{
										UFM_FLT_prev_state_1[14],
										UFM_FLT_prev_state_1[13],
										UFM_FLT_prev_state_1[12],
										UFM_FLT_prev_state_1[11],
										UFM_FLT_prev_state_1[10],
										UFM_FLT_prev_state_1[9],
										UFM_FLT_prev_state_1[8],
										UFM_FLT_prev_state_1[7]
										};
	assign gpi[((1+ 45)*8)-1: 45*8] = 	{
										1'b0,
										UFM_FLT_prev_state_1[6],
										UFM_FLT_prev_state_1[5],
										UFM_FLT_prev_state_1[4],
										UFM_FLT_prev_state_1[3],
										UFM_FLT_prev_state_1[2],
										UFM_FLT_prev_state_1[1],
										UFM_FLT_prev_state_1[0]
										};
	assign gpi[((1+ 46)*8)-1: 46*8] = 	{
										8'h00
										};
	assign gpi[((1+ 47)*8)-1: 47*8] = 	{
										8'h00
										};
	assign gpi[((1+ 48)*8)-1: 48*8] = 	{
										8'h00
										};
	assign gpi[((1+ 49)*8)-1: 49*8] = 	{
										UFM_FLT_prev_state[94],
										UFM_FLT_prev_state[93],
										UFM_FLT_prev_state[92],
										UFM_FLT_prev_state[91],
										UFM_FLT_prev_state[90],
										UFM_FLT_prev_state[89],
										UFM_FLT_prev_state[88],
										UFM_FLT_prev_state[87]
										};
	assign gpi[((1+ 50)*8)-1: 50*8] = 	{
										UFM_FLT_prev_state[86],
										UFM_FLT_prev_state[85],
										UFM_FLT_prev_state[84],
										UFM_FLT_prev_state[83],
										UFM_FLT_prev_state[82],
										UFM_FLT_prev_state[81],
										UFM_FLT_prev_state[80],
										UFM_FLT_prev_state[79]
										};
	assign gpi[((1+ 51)*8)-1: 51*8] = 	{
										UFM_FLT_prev_state[78],
										3'b000,
										UFM_FLT_prev_state[77],
										UFM_FLT_prev_state[76],
										UFM_FLT_prev_state[75],
										UFM_FLT_prev_state[74]
										};
	assign gpi[((1+ 52)*8)-1: 52*8] = 	{
										UFM_FLT_prev_state[73],
										UFM_FLT_prev_state[72],
										UFM_FLT_prev_state[71],
										UFM_FLT_prev_state[70],
										UFM_FLT_prev_state[69],
										UFM_FLT_prev_state[68],
										UFM_FLT_prev_state[67],
										UFM_FLT_prev_state[66]
										};
	assign gpi[((1+ 53)*8)-1: 53*8] = 	{
										UFM_FLT_prev_state[65],
										UFM_FLT_prev_state[64],
										5'b00000,
										UFM_FLT_prev_state[63]
										};
	assign gpi[((1+ 54)*8)-1: 54*8] = 	{
										UFM_FLT_prev_state[62],
										UFM_FLT_prev_state[61],
										UFM_FLT_prev_state[60],
										UFM_FLT_prev_state[59],
										UFM_FLT_prev_state[58],
										UFM_FLT_prev_state[57],
										UFM_FLT_prev_state[56],
										UFM_FLT_prev_state[55]
										};
	assign gpi[((1+ 55)*8)-1: 55*8] = 	{
										UFM_FLT_prev_state[54],
										UFM_FLT_prev_state[53],
										UFM_FLT_prev_state[52],
										UFM_FLT_prev_state[51],
										UFM_FLT_prev_state[50],
										UFM_FLT_prev_state[49],
										UFM_FLT_prev_state[48],
										UFM_FLT_prev_state[47]
										};
	assign gpi[((1+ 56)*8)-1: 56*8] = 	{
										UFM_FLT_prev_state[46],
										UFM_FLT_prev_state[45],
										UFM_FLT_prev_state[44],
										UFM_FLT_prev_state[43],
										UFM_FLT_prev_state[42],
										UFM_FLT_prev_state[41],
										UFM_FLT_prev_state[40],
										UFM_FLT_prev_state[39]
										};
	assign gpi[((1+ 57)*8)-1: 57*8] = 	{
										UFM_FLT_prev_state[38],
										UFM_FLT_prev_state[37],
										UFM_FLT_prev_state[36],
										UFM_FLT_prev_state[35],
										UFM_FLT_prev_state[34],
										UFM_FLT_prev_state[33],
										UFM_FLT_prev_state[32],
										UFM_FLT_prev_state[31]
										};
	assign gpi[((1+ 58)*8)-1: 58*8] = 	{
										UFM_FLT_prev_state[30],
										UFM_FLT_prev_state[29],
										UFM_FLT_prev_state[28],
										UFM_FLT_prev_state[27],
										UFM_FLT_prev_state[26],
										UFM_FLT_prev_state[25],
										UFM_FLT_prev_state[24],
										UFM_FLT_prev_state[23]
										};
	assign gpi[((1+ 59)*8)-1: 59*8] = 	{
										UFM_FLT_prev_state[22],
										UFM_FLT_prev_state[21],
										UFM_FLT_prev_state[20],
										UFM_FLT_prev_state[19],
										UFM_FLT_prev_state[18],
										UFM_FLT_prev_state[17],
										UFM_FLT_prev_state[16],
										UFM_FLT_prev_state[15]
										};
	assign gpi[((1+ 60)*8)-1: 60*8] = 	{
										UFM_FLT_prev_state[14],
										UFM_FLT_prev_state[13],
										UFM_FLT_prev_state[12],
										UFM_FLT_prev_state[11],
										UFM_FLT_prev_state[10],
										UFM_FLT_prev_state[9],
										UFM_FLT_prev_state[8],
										UFM_FLT_prev_state[7]
										};
	assign gpi[((1+ 61)*8)-1: 61*8] = 	{
										1'b0,
										UFM_FLT_prev_state[6],
										UFM_FLT_prev_state[5],
										UFM_FLT_prev_state[4],
										UFM_FLT_prev_state[3],
										UFM_FLT_prev_state[2],
										UFM_FLT_prev_state[1],
										UFM_FLT_prev_state[0]
										};
	assign gpi[((1+ 62)*8)-1: 62*8] = 	{
										8'h00
										};
	assign gpi[((1+ 63)*8)-1: 63*8] = 	{
										8'h00
										};
`endif

endmodule