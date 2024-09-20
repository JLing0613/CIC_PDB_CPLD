//`define SIM

module TopCICPDB
(
    // CLK
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
    output wire PWRGD_RMC_R,	                    //  J11	PDB PWRGD to RMC
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
	input wire HDD_LED_PLD_N,						//	L7	BMC indication of HDD activity
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
	input wire TP_U21_PB3C, 	                    //  T2  Debug use
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
wire 	wCLK_1ms;

wire	wFault;
wire	wFan_PRSNT_N;
wire	wNIC0_PERST_N;
wire	wNIC1_PERST_N;

wire    wPWR_EN_Devices;
wire	wPWR_P48V_FAULT;
wire	wPWR_FAN_FAULT;
wire	wPWR_NIC0_FAULT;
wire	wPWR_NIC1_FAULT;

wire	wPWR_VR_Alert;
wire	wPWR_Sense_Alert;

wire	wRackLeakage;
wire	wLarge_Leakage;
wire	wSmall_Leakage;

wire	wLarge_Leakage_N;
wire	wSmall_Leakage_N;

wire	wUFM_LEAK_FLT;
wire	wUFM_VR_FLT;
wire	wUFM_PRSNT_FLT;
wire	wUFM_SEQPWR_FLT;
wire	wUFM_RUNTIME_FLT;

wire    wNIC_STBY_PWR_OK;
wire    wNIC_MAIN_PWR_OK;

wire	wCHASSIS0_LEAK_Q_N_PLD_db;
wire	wCHASSIS1_LEAK_Q_N_PLD_db;
wire	wCHASSIS2_LEAK_Q_N_PLD_db;
wire	wCHASSIS3_LEAK_Q_N_PLD_db;

wire	wLEAK0_DETECT_R_db;
wire	wLEAK1_DETECT_R_db;
wire	wLEAK2_DETECT_R_db;
wire	wLEAK3_DETECT_R_db;

wire	wBMC_Latch_Clear;
wire	[3:0] wPlatform_Config;

wire 	[3:0] wDBG_MSTR_SEQ_FSM_curr;
wire	[7:0] wDBG_NICx_SEQ_FSM_curr;

wire	wFM_MAIN_PWREN_RMC_EN_ISO_R;
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

wire	wPRSNT_CHASSIS0_LEAK_CABLE_R_N;
wire	wPRSNT_CHASSIS1_LEAK_CABLE_R_N;
wire	wPRSNT_CHASSIS2_LEAK_CABLE_R_N;
wire	wPRSNT_CHASSIS3_LEAK_CABLE_R_N;

wire	wCHASSIS0_LEAK_Q_N_PLD;
wire	wCHASSIS1_LEAK_Q_N_PLD;
wire	wCHASSIS2_LEAK_Q_N_PLD;
wire	wCHASSIS3_LEAK_Q_N_PLD;

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
wire	wHDD_LED_PLD_N;

wire	wPDB_P12V_EN_N_ISO_PLD_R;
wire	wPWR_BTN_BMC_R_N;
wire	wP12V_N1_ENABLE_PLD_R;
wire	wP12V_N2_ENABLE_PLD_R;
	
//	Instances
assign	FM_SYS_THROTTLE_N 				= 	(wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N && wOCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N) ? 1 : 0;

assign	wSmall_Leakage_N 				= 	((!wPRSNT_CHASSIS0_LEAK_CABLE_R_N) ? wCHASSIS0_LEAK_Q_N_PLD_db : 1) | 
											((!wPRSNT_CHASSIS2_LEAK_CABLE_R_N) ? wCHASSIS2_LEAK_Q_N_PLD_db : 1);
assign	wLarge_Leakage_N 				= 	((!wPRSNT_CHASSIS1_LEAK_CABLE_R_N) ? wCHASSIS1_LEAK_Q_N_PLD_db : 1) | 
											((!wPRSNT_CHASSIS3_LEAK_CABLE_R_N) ? wCHASSIS3_LEAK_Q_N_PLD_db : 1);

assign	wRackLeakage					=	(!wPRSNT_RJ45_FIO_N_R) ? FM_MAIN_PWREN_RMC_EN_ISO_R : 1;
	
assign	wSmall_Leakage 					= 	((!wPRSNT_CHASSIS0_LEAK_CABLE_R_N) ? wLEAK0_DETECT_R_db : 0) &
											((!wPRSNT_CHASSIS2_LEAK_CABLE_R_N) ? wLEAK2_DETECT_R_db : 0);
assign	wLarge_Leakage 					= 	((!wPRSNT_CHASSIS1_LEAK_CABLE_R_N) ? wLEAK1_DETECT_R_db : 0) &
											((!wPRSNT_CHASSIS3_LEAK_CABLE_R_N) ? wLEAK3_DETECT_R_db : 0);

assign	RSVD_RMC_GPIO3_R 				= 	(!wPRSNT_RJ45_FIO_N_R) ? wSmall_Leakage_N : 1;
assign 	LEAK_DETECT_RMC_N_R 			= 	(!wPRSNT_RJ45_FIO_N_R) ? wLarge_Leakage_N : 1;
assign 	PWRGD_RMC_R						= 	(!wPRSNT_RJ45_FIO_N_R && !wDBG_MSTR_SEQ_FSM_curr[3] && wDBG_MSTR_SEQ_FSM_curr[2] && !wDBG_MSTR_SEQ_FSM_curr[1] && !wDBG_MSTR_SEQ_FSM_curr[0]) ? 0 : 1;

assign	wPWR_P48V_FAULT 				=	(wP48V_HS1_FAULT_N_PLD && wP48V_HS2_FAULT_N_PLD) ? 1 : 0;
assign	wPWR_FAN_FAULT 					=	(wP12V_AUX_FAN_FAULT_PLD_N && wP12V_AUX_FAN_OC_PLD_N) ? 1 : 0;
assign	wPWR_NIC0_FAULT 				=	(wFM_P3V3_NIC0_FAULT_R_N && wFM_P12V_NIC0_FLTB_R_N) ? 1 : 0;
assign	wPWR_NIC1_FAULT 				=	(wFM_P3V3_NIC1_FAULT_R_N && wFM_P12V_NIC1_FLTB_R_N) ? 1 : 0;

assign	wPWR_VR_Alert 					=	(wNODEA_PSU_SMB_ALERT_R_L && wNODEB_PSU_SMB_ALERT_R_L && wP12V_AUX_FAN_ALERT_PLD_N && wP12V_AUX_PSU_SMB_ALERT_R_L) ? 1 : 0;
assign	wPWR_Sense_Alert 				=	(wP12V_AUX_NIC0_SENSE_ALERT_R_N && wP12V_AUX_NIC1_SENSE_ALERT_R_N && wP12V_SCM_SENSE_ALERT_R_N && wP52V_SENSE_ALERT_PLD_N) ? 1 : 0;

assign 	PSU_ALERT_N 					=	(wPWR_VR_Alert && wPWR_Sense_Alert) ? 1 : 0;

assign	wFan_PRSNT_N 					=	(!wFAN_0_PRESENT_N || !wFAN_1_PRESENT_N || !wFAN_2_PRESENT_N || !wFAN_3_PRESENT_N || !wFAN_4_PRESENT_N || !wFAN_5_PRESENT_N || !wFAN_6_PRESENT_N || !wFAN_7_PRESENT_N) ? 0 : 1; 
assign	RST_OCP_V3_1_R_N 				=	(wNIC0_PERST_N && OCP_SFF_PERST_FROM_HOST_ISO_PLD_N) ? 1 : 0;
assign	RST_OCP_V3_2_R_N 				=	(wNIC1_PERST_N && OCP_V3_2_PERST_FROM_HOST_ISO_PLD_N) ? 1 : 0;
assign 	RST_SMB_SWITCH_PLD_N 			=	1'b1;
assign 	RST_USB_HUB_N 					=	(wNODEA_NODEB_PWOK_PLD_ISO_R) ? 1 : 0;

//assign	TP_U21_PB3C						=	wDBG_MSTR_SEQ_FSM_curr[3];
assign	TP_U21_PB3D						=	1'bz;
assign	TP_U21_PB5A						=	1'bz;
assign	TP_U21_PB5B						=	wPWR_EN_Devices;
assign	TP_U21_PB6C						=	1'bz;
assign	TP_U21_PB6D						=	1'bz;
assign	TP_U21_PB6A						=	1'bz;
assign	TP_U21_PB6B						=	1'bz;

assign	LEAK_DETECT_LED2_ANODE_PLD		= (IOEXP0_output[5]) ? 1'b0 : ~FM_PLD_HEARTBEAT;
assign	LEAK_DETECT_LED2_BNODE_PLD		= (IOEXP0_output[5]) ? 1'b0 : FM_PLD_HEARTBEAT;
assign	LEAK_DETECT_LED1_ANODE_PLD		= (IOEXP0_output[5]) ? 1'b0 : FM_PLD_HEARTBEAT;
assign	LEAK_DETECT_LED1_BNODE_PLD		= (IOEXP0_output[5]) ? 1'b0 : ~FM_PLD_HEARTBEAT;

assign	FM_PDB_HEALTH_R_N				= (IOEXP0_INT_N) ? 1 : 0;
assign	wPlatform_Config				= {IOEXP0_output[3],IOEXP0_output[2],IOEXP0_output[1],IOEXP0_output[0]};
assign 	wBMC_Latch_Clear				= IOEXP0_output[4];

assign wUFM_LEAK_FLT					= 1'b1;
assign wUFM_VR_FLT						= 1'b1;
assign wUFM_PRSNT_FLT					= 1'b1;
assign wUFM_SEQPWR_FLT					= 1'b1;
assign wUFM_RUNTIME_FLT					= 1'b1;

assign	FM_HDD_PWR_CTRL					= wPWR_EN_Devices;
assign	P12V_N1_ENABLE_R				= FM_MAIN_PWREN_FROM_RMC_R;
assign	P12V_N2_ENABLE_R				= FM_MAIN_PWREN_FROM_RMC_R;
    
wire sda_in;
wire scl_in;
wire sda_oe;
wire scl_oe;
wire [9:0] ctr_sda_oe;
assign scl_in = I2C_3V3_15_SCL_R2;
assign sda_in = I2C_3V3_15_SDA_R2;
//assign I2C_3V3_15_SCL_R2 = scl_oe ? 1'bz : 1'b0;
//assign I2C_3V3_15_SDA_R2 = &ctr_sda_oe & sda_oe ? 1'bz : 1'b0;
	
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
Generator_reset mGenerator_reset
( 
	.iClk   (wOSC),
	.oReset (wRST_N)
);

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
	.DivCnt0Width(8),
	.DivCnt1Width(4),
	.DivCnt2Width(8),
	.DivCnt3Width(12),
	.DivValue0(8'd2),
	.DivValue1(4'd10),
	.DivValue2(8'd100),
	.DivValue3(12'd1000)
)
Clock_Generator_inst
(
	.CLK_IN   	(wCLK_2M),
	.RESET_N  	(wRST_N),
	.CLK_EN_O0	(wCLK_EN_O0),	//	DivValue0    = 8'd2,    	(  2MHz/   2) =   1MHz :  1us
	.CLK_EN_O1	(wCLK_EN_O1),	//	DivValue1    = 4'd10,   	(  1MHz/  10) = 100KHz : 10us
	.CLK_EN_O2	(wCLK_EN_O2),	//	DivValue2    = 8'd100,  	(100KHz/ 100) =   1KHz :  1ms
	.CLK_EN_O3	(wCLK_EN_O3)	//	DivValue3    = 12'd1000,	(  1KHz/1000) =    1Hz :  1s
); 

`ifdef SIM
	assign wCLK_1ms = wCLK_EN_O0;
`else
	assign wCLK_1ms = wCLK_EN_O2;
`endif  

// Blink Clock Generator //
Blink_Clock #
(
	.BlinkTimeValue(500) // @ 1ms = 500ms
)
blink_clock_inst
(
	.CLK_IN     (wCLK_2M),
	.RESET_N    (wRST_N),
	.CLK_EN     (wCLK_1ms),
	.BLINK_CLK_O(FM_PLD_HEARTBEAT)
);

debounce mLeak0_Q_N
(
	.clk_1k(wCLK_2M),
	.cpld_rst_n(wRST_N),
	.prsnt_in(wCHASSIS0_LEAK_Q_N_PLD),
	.prsnt_out(wCHASSIS0_LEAK_Q_N_PLD_db)
);

debounce mLeak1_Q_N
(
	.clk_1k(wCLK_2M),
	.cpld_rst_n(wRST_N),
	.prsnt_in(wCHASSIS1_LEAK_Q_N_PLD),
	.prsnt_out(wCHASSIS1_LEAK_Q_N_PLD_db)
);

debounce mLeak2_Q_N
(
	.clk_1k(wCLK_2M),
	.cpld_rst_n(wRST_N),
	.prsnt_in(wCHASSIS2_LEAK_Q_N_PLD),
	.prsnt_out(wCHASSIS2_LEAK_Q_N_PLD_db)
);
	
debounce mLeak3_Q_N
(
	.clk_1k(wCLK_2M),
	.cpld_rst_n(wRST_N),
	.prsnt_in(wCHASSIS3_LEAK_Q_N_PLD),
	.prsnt_out(wCHASSIS3_LEAK_Q_N_PLD_db)
);
	
debounce mLeak0_Q
(
	.clk_1k(wCLK_2M),
	.cpld_rst_n(wRST_N),
	.prsnt_in(wLEAK0_DETECT_R),
	.prsnt_out(wLEAK0_DETECT_R_db)
);
	
debounce mLeak1_Q
(
	.clk_1k(wCLK_2M),
	.cpld_rst_n(wRST_N),
	.prsnt_in(wLEAK1_DETECT_R),
	.prsnt_out(wLEAK1_DETECT_R_db)
);

debounce mLeak2_Q
(
	.clk_1k(wCLK_2M),
	.cpld_rst_n(wRST_N),
	.prsnt_in(wLEAK2_DETECT_R),
	.prsnt_out(wLEAK2_DETECT_R_db)
);
	
debounce mLeak3_Q
(
	.clk_1k(wCLK_2M),
	.cpld_rst_n(wRST_N),
	.prsnt_in(wLEAK3_DETECT_R),
	.prsnt_out(wLEAK3_DETECT_R_db)
);

MSTR_SEQ mMSTR_SEQ
(
    .iClk                       (wCLK_2M),
    .iClk_1ms                   (wCLK_1ms),
    .iRst_n                     (wRST_N),

	.iPWRGD_P3V3_AUX            (wPWRGD_P3V3_AUX_PLD),
    .iPWRGD_P12V_AUX            (wPWRGD_P12V_AUX_PLD_ISO_R),
	.iRMC_PWR_Enable			(wFM_MAIN_PWREN_RMC_EN_ISO_R),
	.iLarge_Leak_Detect_N		(wLarge_Leakage_N),
	.iSmall_Leak_Detect_N		(wSmall_Leakage_N),
	.iLatch_Clear				(wBMC_Latch_Clear),
	.iPlaform_Config			(wPlatform_Config),
		
	.oP12V_AUX_FAN_EN			(P12V_AUX_FAN_EN_PLD),
	.iPWRGD_P12V_AUX_FAN		(wPWRGD_P12V_AUX_FAN_PLD),

	.oPWR_EN_Devices            (wPWR_EN_Devices),
	.iNIC_STBY_PWR_OK           (wNIC_STBY_PWR_OK),
    .iNIC_MAIN_PWR_OK           (wNIC_MAIN_PWR_OK),

	.oP12V_NODEx_EN				(FM_MAIN_PWREN_FROM_RMC_R),
	.iPWRGD_P12V_Nodex			(wNODEA_NODEB_PWOK_PLD_ISO_R),

	.iDC_PWR_BTN_ON				((wFAB_BMC_REV_ID1) ? TP_U21_PB3C || wPDB_P12V_EN_N_ISO_PLD_R : 0),
	.iPWR_P48V_FAULT			(wPWR_P48V_FAULT),
	.iPWR_FAN_FAULT				(wPWR_FAN_FAULT),
	.iPWR_NIC0_FAULT			(wPWR_NIC0_FAULT),
	.iPWR_NIC1_FAULT			(wPWR_NIC1_FAULT),
		
	.iLeakage_BMC_ready			(IOEXP0_INT_N_Edge_Detect),
	.iFault_BMC_ready			(IOEXP1_INT_N_Edge_Detect),

	.oDBG_MSTR_SEQ_FSM_curr     (wDBG_MSTR_SEQ_FSM_curr)
);

OCP3_NIC_Control mOCP3_NIC_Control 
(
    .iClk                   (wCLK_2M),
    .iClk_1ms               (wCLK_1ms),
    .iRst_n                 (wRST_N),
	
    .iPWR_EN_DEV            (wPWR_EN_Devices & wPWR_NIC0_FAULT & wPWR_NIC1_FAULT),
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
	
	.oNICx_FSM_curr			(wDBG_NICx_SEQ_FSM_curr)
);

wire sda_in;
wire scl_in;

wire UFM_scl_oe;
wire IOEXP_sda_oe;
wire UFM_sda_oe;
wire REGs_sda_oe;

assign scl_in = I2C_3V3_15_SCL_R2;
assign sda_in = I2C_3V3_15_SDA_R2;
//assign I2C_3V3_15_SCL_R2 = UFM_scl_oe ? 1'bz : 1'b0;
assign I2C_3V3_15_SDA_R2 = IOEXP_sda_oe /*& UFM_sda_oe */& REGs_sda_oe ? 1'bz : 1'b0;

//	SMBus CLk setting 400KHz
SMBusFWUpdate mSMBusFWUpdate 
(
	.wb_clk_i      (wOSC),
	.i2c1_scl      (I2C_3V3_15_SCL_R),
	.i2c1_sda      (I2C_3V3_15_SDA_R),
	.i2c1_irqo     ()
);

wire	[15:0]	IOEXP0_output;
wire	IOEXP0_INT_N;
wire	IOEXP0_INT_N_Edge_Detect;

SMBusIOExp_Control#
(
	.i2c_slave_addr		(7'h10)
)I2C_Control_0
(
	.iClk				(wOSC),
	.iClk_1ms			(wCLK_1ms),
	.iRst_n				(wRST_N),
	.scl_in             (scl_in),
	.sda_in             (sda_in),
	.sda_oe             (IOEXP_sda_oe),
	.iI0				({
						1'b1,
						1'b1,
						1'b1,
						wUFM_LEAK_FLT,
						wUFM_VR_FLT,
						wUFM_PRSNT_FLT,
						wUFM_SEQPWR_FLT,
						wUFM_RUNTIME_FLT
						}),
	.iI1				({
						8'hff
						}),
	.INT_N				(IOEXP0_INT_N),
	.output_data		({
						IOEXP0_output[15],
						IOEXP0_output[14],
						IOEXP0_output[13],
						IOEXP0_output[12],
						IOEXP0_output[11],			
						IOEXP0_output[10],
						IOEXP0_output[9],
						IOEXP0_output[8],
						IOEXP0_output[7],
						IOEXP0_output[6],
						IOEXP0_output[5],			//	MFG LED test mode(low active)
						IOEXP0_output[4],			//	clear sequence latch
						IOEXP0_output[3],			//	platform config 3
						IOEXP0_output[2],			//	platform config 2
						IOEXP0_output[1],			//	platform config 1
						IOEXP0_output[0]			//	platform config 0
						})
);
	
Edge_Detector IOEXP0_INT_N_Detect
(
	.iClk					(wOSC),
	.iRst_n					(wRST_N),
	.iClear					(),
	.pos_neg				(1'b1),
	.input_sig				(IOEXP0_INT_N),
	.output_pulse_sig		(IOEXP0_INT_N_Edge_Detect),
	.output_constant_sig	()
);

wire 	[127:0] Regs_Input;

assign	Regs_Input =
{
	wCHASSIS0_LEAK_Q_N_PLD,					//[127:120]
	wCHASSIS2_LEAK_Q_N_PLD,
	wCHASSIS1_LEAK_Q_N_PLD,
	wCHASSIS3_LEAK_Q_N_PLD,
	wLEAK0_DETECT_R,
	wLEAK2_DETECT_R,
	wLEAK1_DETECT_R,
	wLEAK3_DETECT_R,
	RSVD_RMC_GPIO3_R,						//[119:112]
	LEAK_DETECT_RMC_N_R,
	
	wP12V_AUX_FAN_FAULT_PLD_N,
	wP12V_AUX_FAN_OC_PLD_N,
	wP48V_HS1_FAULT_N_PLD,
	wP48V_HS2_FAULT_N_PLD,
	wFM_P3V3_NIC0_FAULT_R_N,
	wFM_P12V_NIC0_FLTB_R_N,
	wFM_P3V3_NIC1_FAULT_R_N,				//[111:104]
	wFM_P12V_NIC1_FLTB_R_N,
	wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N,
	wOCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N,
	FM_SYS_THROTTLE_N,
	
	wSMB_RJ45_FIO_TMP_ALERT,
	wP52V_SENSE_ALERT_PLD_N,
	wP12V_AUX_FAN_ALERT_PLD_N,
	wNODEA_PSU_SMB_ALERT_R_L,				//[103:96]
	wNODEB_PSU_SMB_ALERT_R_L,
	wP12V_AUX_NIC0_SENSE_ALERT_R_N,
	wP12V_AUX_NIC1_SENSE_ALERT_R_N,
	wP12V_SCM_SENSE_ALERT_R_N,
	wP12V_AUX_PSU_SMB_ALERT_R_L,
	
	wFAN_0_PRESENT_N,
	wFAN_1_PRESENT_N,
	wFAN_2_PRESENT_N,						//[95:88]
	wFAN_3_PRESENT_N,
	wFAN_4_PRESENT_N,
	wFAN_5_PRESENT_N,
	wFAN_6_PRESENT_N,
	wFAN_7_PRESENT_N,
	wPRSNT_OSFP0_POWER_CABLE_N,
    wPRSNT_HDDBD_POWER_CABLE_N,
	wPRSNT_RJ45_FIO_N_R,					//[87:80]
	wPRSNT_CHASSIS0_LEAK_CABLE_R_N,
	wPRSNT_CHASSIS2_LEAK_CABLE_R_N,
	wPRSNT_CHASSIS1_LEAK_CABLE_R_N,
	wPRSNT_CHASSIS3_LEAK_CABLE_R_N,
	wHP_LVC3_OCP_V3_1_PRSNT2_PLD_N,
    wHP_LVC3_OCP_V3_2_PRSNT2_PLD_N,
	
	wHP_OCP_V3_1_HSC_PWRGD_PLD_R,
	wHP_LVC3_OCP_V3_1_PWRGD_PLD,			//[79:72]
    OCP_SFF_AUX_PWR_PLD_EN_R,
	wFM_OCP_SFF_PWR_GOOD_PLD,
	OCP_SFF_MAIN_PWR_EN,
	wOCP_SFF_PERST_FROM_HOST_ISO_PLD_N,
    wNIC0_PERST_N,
	RST_OCP_V3_1_R_N,
	
	wHP_OCP_V3_2_HSC_PWRGD_PLD_R,
	wHP_LVC3_OCP_V3_2_PWRGD_PLD,			//[71:64]
    OCP_V3_2_AUX_PWR_PLD_EN_R,
	wFM_OCP_V3_2_PWR_GOOD_PLD,
	OCP_V3_2_MAIN_PWR_EN,
	wOCP_V3_2_PERST_FROM_HOST_ISO_PLD_N,
    wNIC1_PERST_N,
	RST_OCP_V3_2_R_N,
	
	wPWRGD_P3V3_AUX_PLD,
	wPWRGD_P12V_AUX_PLD_ISO_R,				//[63:56]
	P12V_AUX_FAN_EN_PLD,
	wPWRGD_P12V_AUX_FAN_PLD,
	wFM_MAIN_PWREN_RMC_EN_ISO_R,
	wPDB_P12V_EN_N_ISO_PLD_R,
	FM_MAIN_PWREN_FROM_RMC_R,
	wPWR_EN_Devices,
	wP12V_N1_ENABLE_PLD_R,
	wP12V_N2_ENABLE_PLD_R,					//[55:48]
	P12V_N1_ENABLE_R,
	P12V_N2_ENABLE_R,
	wNODEA_NODEB_PWOK_PLD_ISO_R,
	PWRGD_RMC_R,
	1'b1,
	1'b1,
	1'b1,
	
	1'b1,									//[47:40]
	1'b1,
	1'b1,
	1'b1,
	1'b1,
	1'b1,
	1'b1,
	1'b1,
	1'b1,									//[39:32]
	1'b1,
	1'b1,
	1'b1,
	wDBG_NICx_SEQ_FSM_curr[7:4],
	1'b1,									//[31:24]
	1'b1,
	1'b1,
	1'b1,
	1'b1,
	1'b1,
	1'b1,
	1'b1,
	1'b1,									//[23:16]
	1'b1,
	1'b1,
	1'b1,
	wDBG_NICx_SEQ_FSM_curr[3:0],
	1'b1,									//[15:8]
	1'b1,
	1'b1,
	1'b1,
	1'b1,
	1'b1,
	1'b1,
	1'b1,
	1'b1,									//[7:0]
	1'b1,
	1'b1,
	1'b1,
	wDBG_MSTR_SEQ_FSM_curr
};

wire	[9:0] Leak_Cable_prev_state_0;
wire	[9:0] Leak_Cable_prev_state_1;
wire	[9:0] Leak_Cable_prev_state_2;
wire	[9:0] Leak_Cable_curr_state;

State_Multiple_Logger#
(
	.bits				(10)
)
Leak_Cable_state_logger
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b0),

	.iDbgSt				(Regs_Input[127:118]),

	.prev_state_0		(Leak_Cable_prev_state_0),
	.prev_state_1		(Leak_Cable_prev_state_1),
	.prev_state_2		(Leak_Cable_prev_state_2),
	.current_state		(Leak_Cable_curr_state)
);

wire	[10:0] Fault_prev_state_0;
wire	[10:0] Fault_prev_state_1;
wire	[10:0] Fault_prev_state_2;
wire	[10:0] Fault_curr_state;

State_Multiple_Logger#
(
	.bits				(11)
)
Fault_state_logger
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b0),

	.iDbgSt				(Regs_Input[117:107]),

	.prev_state_0		(Fault_prev_state_0),
	.prev_state_1		(Fault_prev_state_1),
	.prev_state_2		(Fault_prev_state_2),
	.current_state		(Fault_curr_state)
);

wire	[8:0] Alert_prev_state_0;
wire	[8:0] Alert_prev_state_1;
wire	[8:0] Alert_prev_state_2;
wire	[8:0] Alert_curr_state;

State_Multiple_Logger#
(
	.bits				(9)
)
Alert_state_logger
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b0),

	.iDbgSt				(Regs_Input[106:98]),

	.prev_state_0		(Alert_prev_state_0),
	.prev_state_1		(Alert_prev_state_1),
	.prev_state_2		(Alert_prev_state_2),
	.current_state		(Alert_curr_state)
);

wire	[16:0] Prsnt_prev_state_0;
wire	[16:0] Prsnt_prev_state_1;
wire	[16:0] Prsnt_prev_state_2;
wire	[16:0] Prsnt_curr_state;

State_Multiple_Logger#
(
	.bits				(17)
)
Prsnt_state_logger
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b0),

	.iDbgSt				(Regs_Input[97:81]),

	.prev_state_0		(Prsnt_prev_state_0),
	.prev_state_1		(Prsnt_prev_state_1),
	.prev_state_2		(Prsnt_prev_state_2),
	.current_state		(Prsnt_curr_state)
);

wire	[7:0] NIC0_Detail_prev_state_0;
wire	[7:0] NIC0_Detail_prev_state_1;
wire	[7:0] NIC0_Detail_prev_state_2;
wire	[7:0] NIC0_Detail_curr_state;

State_Multiple_Logger#
(
	.bits				(8)
)
NIC0_Detail_state_logger
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b0),

	.iDbgSt				(Regs_Input[80:73]),

	.prev_state_0		(NIC0_Detail_prev_state_0),
	.prev_state_1		(NIC0_Detail_prev_state_1),
	.prev_state_2		(NIC0_Detail_prev_state_2),
	.current_state		(NIC0_Detail_curr_state)
);

wire	[7:0] NIC1_Detail_prev_state_0;
wire	[7:0] NIC1_Detail_prev_state_1;
wire	[7:0] NIC1_Detail_prev_state_2;
wire	[7:0] NIC1_Detail_curr_state;

State_Multiple_Logger#
(
	.bits				(8)
)
NIC1_Detail_state_logger
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b0),

	.iDbgSt				(Regs_Input[72:65]),

	.prev_state_0		(NIC1_Detail_prev_state_0),
	.prev_state_1		(NIC1_Detail_prev_state_1),
	.prev_state_2		(NIC1_Detail_prev_state_2),
	.current_state		(NIC1_Detail_curr_state)
);

wire	[7:0] Mstr_Detail_prev_state_0;
wire	[7:0] Mstr_Detail_prev_state_1;
wire	[7:0] Mstr_Detail_prev_state_2;
wire	[7:0] Mstr_Detail_curr_state;

State_Multiple_Logger#
(
	.bits				(17)
)
Mstr_Detail_state_logger
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b0),

	.iDbgSt				(Regs_Input[64:48]),

	.prev_state_0		(Mstr_Detail_prev_state_0),
	.prev_state_1		(Mstr_Detail_prev_state_1),
	.prev_state_2		(Mstr_Detail_prev_state_2),
	.current_state		(Mstr_Detail_curr_state)
);

wire	[3:0] NIC0_Seq_prev_state_0;
wire	[3:0] NIC0_Seq_prev_state_1;
wire	[3:0] NIC0_Seq_prev_state_2;
wire	[3:0] NIC0_Seq_curr_state;

State_Multiple_Logger#
(
	.bits				(4)
)
NIC0_Seq_state_logger
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b0),

	.iDbgSt				(Regs_Input[35:32]),

	.prev_state_0		(NIC0_Seq_prev_state_0),
	.prev_state_1		(NIC0_Seq_prev_state_1),
	.prev_state_2		(NIC0_Seq_prev_state_2),
	.current_state		(NIC0_Seq_curr_state)
);

wire	[3:0] NIC1_Seq_prev_state_0;
wire	[3:0] NIC1_Seq_prev_state_1;
wire	[3:0] NIC1_Seq_prev_state_2;
wire	[3:0] NIC1_Seq_curr_state;

State_Multiple_Logger#
(
	.bits				(4)
)
NIC1_Seq_state_logger
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b0),

	.iDbgSt				(Regs_Input[19:16]),

	.prev_state_0		(NIC1_Seq_prev_state_0),
	.prev_state_1		(NIC1_Seq_prev_state_1),
	.prev_state_2		(NIC1_Seq_prev_state_2),
	.current_state		(NIC1_Seq_curr_state)
);


wire	[3:0] Mstr_Seq_prev_state_0;
wire	[3:0] Mstr_Seq_prev_state_1;
wire	[3:0] Mstr_Seq_prev_state_2;
wire	[3:0] Mstr_Seq_curr_state;

State_Multiple_Logger#
(
	.bits				(4)
)
Mstr_Seq_state_logger
(
	.iClk				(wOSC),
	.iRst_n				(wRST_N),
	.iClear				(1'b0),

	.iDbgSt				(Regs_Input[3:0]),

	.prev_state_0		(Mstr_Seq_prev_state_0),
	.prev_state_1		(Mstr_Seq_prev_state_1),
	.prev_state_2		(Mstr_Seq_prev_state_2),
	.current_state		(Mstr_Seq_curr_state)
);

wire	[127:0] Regs_curr_state;
wire	[127:0] Regs_prev_state_2;
wire	[127:0] Regs_prev_state_1;
wire	[127:0] Regs_prev_state_0;

assign	Regs_curr_state =
{
	Leak_Cable_curr_state,
	Fault_curr_state,
	Alert_curr_state,
	Prsnt_curr_state,
	NIC0_Detail_curr_state,
	NIC1_Detail_curr_state,
	Mstr_Detail_curr_state,
	Regs_Input[47:36],
	NIC0_Seq_curr_state,
	Regs_Input[31:20],
	NIC1_Seq_curr_state,
	Regs_Input[15:4],
	Mstr_Seq_curr_state
};

assign	Regs_prev_state_2 =
{
	Leak_Cable_prev_state_2,
	Fault_prev_state_2,
	Alert_prev_state_2,
	Prsnt_prev_state_2,
	NIC0_Detail_prev_state_2,
	NIC1_Detail_prev_state_2,
	Mstr_Detail_prev_state_2,
	Regs_Input[47:36],
	NIC0_Seq_prev_state_2,
	Regs_Input[31:20],
	NIC1_Seq_prev_state_2,
	Regs_Input[15:4],
	Mstr_Seq_prev_state_2
};

assign	Regs_prev_state_1 =
{
	Leak_Cable_prev_state_1,
	Fault_prev_state_1,
	Alert_prev_state_1,
	Prsnt_prev_state_1,
	NIC0_Detail_prev_state_1,
	NIC1_Detail_prev_state_1,
	Mstr_Detail_prev_state_1,
	Regs_Input[47:36],
	NIC0_Seq_prev_state_1,
	Regs_Input[31:20],
	NIC1_Seq_prev_state_1,
	Regs_Input[15:4],
	Mstr_Seq_prev_state_1
};

assign	Regs_prev_state_0 =
{
	Leak_Cable_prev_state_0,
	Fault_prev_state_0,
	Alert_prev_state_0,
	Prsnt_prev_state_0,
	NIC0_Detail_prev_state_0,
	NIC1_Detail_prev_state_0,
	Mstr_Detail_prev_state_0,
	Regs_Input[47:36],
	NIC0_Seq_prev_state_0,
	Regs_Input[31:20],
	NIC1_Seq_prev_state_0,
	Regs_Input[15:4],
	Mstr_Seq_prev_state_0
};

SMBusRegs#
(
	.i2c_slave_addr		(7'h12)
)mSMBusRegs_BMC
(
	.CLK_IN         (wOSC),
	.RESET_N        (wRST_N),
	.scl_in         (scl_in),
	.sda_in         (sda_in),
	.sda_oe         (REGs_sda_oe),

	.iFPGA_REG_00   (Regs_curr_state[127:120]  ),
	.iFPGA_REG_01   (Regs_curr_state[119:112]  ),
	.iFPGA_REG_02   (Regs_curr_state[111:104]  ),
	.iFPGA_REG_03   (Regs_curr_state[103:96]   ),
	.iFPGA_REG_04   (Regs_curr_state[95:88]    ),
	.iFPGA_REG_05   (Regs_curr_state[87:80]    ),
	.iFPGA_REG_06   (Regs_curr_state[79:72]    ),
	.iFPGA_REG_07   (Regs_curr_state[71:64]    ),
	.iFPGA_REG_08   (Regs_curr_state[63:56]    ),
	.iFPGA_REG_09   (Regs_curr_state[55:48]    ),
	.iFPGA_REG_0A   (Regs_curr_state[47:40]    ),
	.iFPGA_REG_0B   (Regs_curr_state[39:32]    ),
	.iFPGA_REG_0C   (Regs_curr_state[31:24]    ),
	.iFPGA_REG_0D   (Regs_curr_state[23:16]    ),
	.iFPGA_REG_0E   (Regs_curr_state[15:8]     ),
	.iFPGA_REG_0F   (Regs_curr_state[7:0]      ),
	.iFPGA_REG_10   (Regs_prev_state_2[127:120]),
	.iFPGA_REG_11   (Regs_prev_state_2[119:112]),
	.iFPGA_REG_12   (Regs_prev_state_2[111:104]),
	.iFPGA_REG_13   (Regs_prev_state_2[103:96] ),
	.iFPGA_REG_14   (Regs_prev_state_2[95:88]  ),
	.iFPGA_REG_15   (Regs_prev_state_2[87:80]  ),
	.iFPGA_REG_16   (Regs_prev_state_2[79:72]  ),
	.iFPGA_REG_17   (Regs_prev_state_2[71:64]  ),
	.iFPGA_REG_18   (Regs_prev_state_2[63:56]  ),
	.iFPGA_REG_19   (Regs_prev_state_2[55:48]  ),
	.iFPGA_REG_1A   (Regs_prev_state_2[47:40]  ),
	.iFPGA_REG_1B   (Regs_prev_state_2[39:32]  ),
	.iFPGA_REG_1C   (Regs_prev_state_2[31:24]  ),
	.iFPGA_REG_1D   (Regs_prev_state_2[23:16]  ),
	.iFPGA_REG_1E   (Regs_prev_state_2[15:8]   ),
	.iFPGA_REG_1F   (Regs_prev_state_2[7:0]    ),
	.iFPGA_REG_20   (Regs_prev_state_1[127:120]),
	.iFPGA_REG_21   (Regs_prev_state_1[119:112]),
	.iFPGA_REG_22   (Regs_prev_state_1[111:104]),
	.iFPGA_REG_23   (Regs_prev_state_1[103:96] ),
	.iFPGA_REG_24   (Regs_prev_state_1[95:88]  ),
	.iFPGA_REG_25   (Regs_prev_state_1[87:80]  ),
	.iFPGA_REG_26   (Regs_prev_state_1[79:72]  ),
	.iFPGA_REG_27   (Regs_prev_state_1[71:64]  ),
	.iFPGA_REG_28   (Regs_prev_state_1[63:56]  ),
	.iFPGA_REG_29   (Regs_prev_state_1[55:48]  ),
	.iFPGA_REG_2A   (Regs_prev_state_1[47:40]  ),
	.iFPGA_REG_2B   (Regs_prev_state_1[39:32]  ),
	.iFPGA_REG_2C   (Regs_prev_state_1[31:24]  ),
	.iFPGA_REG_2D   (Regs_prev_state_1[23:16]  ),
	.iFPGA_REG_2E   (Regs_prev_state_1[15:8]   ),
	.iFPGA_REG_2F   (Regs_prev_state_1[7:0]    ),
	.iFPGA_REG_30   (Regs_prev_state_0[127:120]),
	.iFPGA_REG_31   (Regs_prev_state_0[119:112]),
	.iFPGA_REG_32   (Regs_prev_state_0[111:104]),
	.iFPGA_REG_33   (Regs_prev_state_0[103:96] ),
	.iFPGA_REG_34   (Regs_prev_state_0[95:88]  ),
	.iFPGA_REG_35   (Regs_prev_state_0[87:80]  ),
	.iFPGA_REG_36   (Regs_prev_state_0[79:72]  ),
	.iFPGA_REG_37   (Regs_prev_state_0[71:64]  ),
	.iFPGA_REG_38   (Regs_prev_state_0[63:56]  ),
	.iFPGA_REG_39   (Regs_prev_state_0[55:48]  ),
	.iFPGA_REG_3A   (Regs_prev_state_0[47:40]  ),
	.iFPGA_REG_3B   (Regs_prev_state_0[39:32]  ),
	.iFPGA_REG_3C   (Regs_prev_state_0[31:24]  ),
	.iFPGA_REG_3D   (Regs_prev_state_0[23:16]  ),
	.iFPGA_REG_3E   (Regs_prev_state_0[15:8]   ),
	.iFPGA_REG_3F   (Regs_prev_state_0[7:0]    )
);
/*
wire rmc_scl_in;
wire rmc_sda_in;

//wire rmc_scl_oe;
wire rmc_sda_oe;

assign rmc_scl_in = I2C_RMC_SCL_BUF;
assign rmc_sda_in = I2C_RMC_SDA_BUF;
//assign I2C_RMC_SCL_BUF = rmc_scl_oe ? 1'bz : 1'b0;
assign I2C_RMC_SDA_BUF = rmc_sda_oe ? 1'bz : 1'b0;

SMBusRegs#
(
	.i2c_slave_addr		(7'h12)
)mSMBusRegs_BMC
(
	.CLK_IN         (wOSC),
	.RESET_N        (wRST_N),
	.scl_in         (rmc_scl_in),
	.sda_in         (rmc_sda_in),
	.sda_oe         (rmc_sda_oe),

	.iFPGA_REG_00   (Regs_curr_state[127:120]  ),
	.iFPGA_REG_01   (Regs_curr_state[119:112]  ),
	.iFPGA_REG_02   (Regs_curr_state[111:104]  ),
	.iFPGA_REG_03   (Regs_curr_state[103:96]   ),
	.iFPGA_REG_04   (Regs_curr_state[95:88]    ),
	.iFPGA_REG_05   (Regs_curr_state[87:80]    ),
	.iFPGA_REG_06   (Regs_curr_state[79:72]    ),
	.iFPGA_REG_07   (Regs_curr_state[71:64]    ),
	.iFPGA_REG_08   (Regs_curr_state[63:56]    ),
	.iFPGA_REG_09   (Regs_curr_state[55:48]    ),
	.iFPGA_REG_0A   (Regs_curr_state[47:40]    ),
	.iFPGA_REG_0B   (Regs_curr_state[39:32]    ),
	.iFPGA_REG_0C   (Regs_curr_state[31:24]    ),
	.iFPGA_REG_0D   (Regs_curr_state[23:16]    ),
	.iFPGA_REG_0E   (Regs_curr_state[15:8]     ),
	.iFPGA_REG_0F   (Regs_curr_state[7:0]      ),
	.iFPGA_REG_10   (Regs_prev_state_2[127:120]),
	.iFPGA_REG_11   (Regs_prev_state_2[119:112]),
	.iFPGA_REG_12   (Regs_prev_state_2[111:104]),
	.iFPGA_REG_13   (Regs_prev_state_2[103:96] ),
	.iFPGA_REG_14   (Regs_prev_state_2[95:88]  ),
	.iFPGA_REG_15   (Regs_prev_state_2[87:80]  ),
	.iFPGA_REG_16   (Regs_prev_state_2[79:72]  ),
	.iFPGA_REG_17   (Regs_prev_state_2[71:64]  ),
	.iFPGA_REG_18   (Regs_prev_state_2[63:56]  ),
	.iFPGA_REG_19   (Regs_prev_state_2[55:48]  ),
	.iFPGA_REG_1A   (Regs_prev_state_2[47:40]  ),
	.iFPGA_REG_1B   (Regs_prev_state_2[39:32]  ),
	.iFPGA_REG_1C   (Regs_prev_state_2[31:24]  ),
	.iFPGA_REG_1D   (Regs_prev_state_2[23:16]  ),
	.iFPGA_REG_1E   (Regs_prev_state_2[15:8]   ),
	.iFPGA_REG_1F   (Regs_prev_state_2[7:0]    ),
	.iFPGA_REG_20   (Regs_prev_state_1[127:120]),
	.iFPGA_REG_21   (Regs_prev_state_1[119:112]),
	.iFPGA_REG_22   (Regs_prev_state_1[111:104]),
	.iFPGA_REG_23   (Regs_prev_state_1[103:96] ),
	.iFPGA_REG_24   (Regs_prev_state_1[95:88]  ),
	.iFPGA_REG_25   (Regs_prev_state_1[87:80]  ),
	.iFPGA_REG_26   (Regs_prev_state_1[79:72]  ),
	.iFPGA_REG_27   (Regs_prev_state_1[71:64]  ),
	.iFPGA_REG_28   (Regs_prev_state_1[63:56]  ),
	.iFPGA_REG_29   (Regs_prev_state_1[55:48]  ),
	.iFPGA_REG_2A   (Regs_prev_state_1[47:40]  ),
	.iFPGA_REG_2B   (Regs_prev_state_1[39:32]  ),
	.iFPGA_REG_2C   (Regs_prev_state_1[31:24]  ),
	.iFPGA_REG_2D   (Regs_prev_state_1[23:16]  ),
	.iFPGA_REG_2E   (Regs_prev_state_1[15:8]   ),
	.iFPGA_REG_2F   (Regs_prev_state_1[7:0]    ),
	.iFPGA_REG_30   (Regs_prev_state_0[127:120]),
	.iFPGA_REG_31   (Regs_prev_state_0[119:112]),
	.iFPGA_REG_32   (Regs_prev_state_0[111:104]),
	.iFPGA_REG_33   (Regs_prev_state_0[103:96] ),
	.iFPGA_REG_34   (Regs_prev_state_0[95:88]  ),
	.iFPGA_REG_35   (Regs_prev_state_0[87:80]  ),
	.iFPGA_REG_36   (Regs_prev_state_0[79:72]  ),
	.iFPGA_REG_37   (Regs_prev_state_0[71:64]  ),
	.iFPGA_REG_38   (Regs_prev_state_0[63:56]  ),
	.iFPGA_REG_39   (Regs_prev_state_0[55:48]  ),
	.iFPGA_REG_3A   (Regs_prev_state_0[47:40]  ),
	.iFPGA_REG_3B   (Regs_prev_state_0[39:32]  ),
	.iFPGA_REG_3C   (Regs_prev_state_0[31:24]  ),
	.iFPGA_REG_3D   (Regs_prev_state_0[23:16]  ),
	.iFPGA_REG_3E   (Regs_prev_state_0[15:8]   ),
	.iFPGA_REG_3F   (Regs_prev_state_0[7:0]    )
);
*/
GlitchFilter #
	(
		.NUMBER_OF_SIGNALS  (71)
	) 
	mGlitchFilter
	(
		.iClk               (wOSC),
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
					HDD_LED_PLD_N,
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
					wHDD_LED_PLD_N,
					wPDB_P12V_EN_N_ISO_PLD_R,
					wPWR_BTN_BMC_R_N,
					wP12V_N1_ENABLE_PLD_R,
					wP12V_N2_ENABLE_PLD_R
				}
			)
	);

endmodule