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

	wire	[7:0] wDBG_NICx_SEQ_FSM_curr;
	wire	[7:0] wDBG_NICx_SEQ_FSM_prev;

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
	
	assign	wSmall_Leakage_N 				= 	((!wPRSNT_CHASSIS0_LEAK_CABLE_R_N || !IOEXP9_output[6]) ? wCHASSIS0_LEAK_Q_N_PLD_db & IOEXP9_output[6] : 1) | 
												((!wPRSNT_CHASSIS2_LEAK_CABLE_R_N || !IOEXP9_output[6]) ? wCHASSIS2_LEAK_Q_N_PLD_db & IOEXP9_output[6] : 1);
	assign	wLarge_Leakage_N 				= 	((!wPRSNT_CHASSIS1_LEAK_CABLE_R_N || !IOEXP9_output[7]) ? wCHASSIS1_LEAK_Q_N_PLD_db & IOEXP9_output[7] : 1) | 
												((!wPRSNT_CHASSIS3_LEAK_CABLE_R_N || !IOEXP9_output[7]) ? wCHASSIS3_LEAK_Q_N_PLD_db & IOEXP9_output[7] : 1);

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

	assign	LEAK_DETECT_LED2_ANODE_PLD		= (IOEXP9_output[5]) ? 1'b0 : ~FM_PLD_HEARTBEAT;
	assign	LEAK_DETECT_LED2_BNODE_PLD		= (IOEXP9_output[5]) ? 1'b0 : FM_PLD_HEARTBEAT;
	assign	LEAK_DETECT_LED1_ANODE_PLD		= (IOEXP9_output[5]) ? 1'b0 : FM_PLD_HEARTBEAT;
	assign	LEAK_DETECT_LED1_BNODE_PLD		= (IOEXP9_output[5]) ? 1'b0 : ~FM_PLD_HEARTBEAT;

	assign	FM_PDB_HEALTH_R_N				= (IOEXP0_INT_N && IOEXP1_INT_N && IOEXP2_INT_N && IOEXP3_INT_N && IOEXP4_INT_N && IOEXP5_INT_N) ? 1 : 0;
	
	assign	wPlatform_Config				= {IOEXP9_output[3],IOEXP9_output[2],IOEXP9_output[1],IOEXP9_output[0]};
	
	assign 	wBMC_Latch_Clear				= IOEXP9_output[4];

	assign	FM_HDD_PWR_CTRL					= wPWR_EN_Devices;
	assign	P12V_N1_ENABLE_R				= FM_MAIN_PWREN_FROM_RMC_R;
	assign	P12V_N2_ENABLE_R				= FM_MAIN_PWREN_FROM_RMC_R;

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
		
	wire [3:0] wDBG_MSTR_SEQ_FSM_prev0;
	wire [3:0] wDBG_MSTR_SEQ_FSM_prev1;
	wire [3:0] wDBG_MSTR_SEQ_FSM_prev2;
	wire [3:0] wDBG_MSTR_SEQ_FSM_curr;

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

		.iDC_PWR_BTN_ON				(TP_U21_PB3C || wPDB_P12V_EN_N_ISO_PLD_R),
		.iPWR_P48V_FAULT			(wPWR_P48V_FAULT),
		.iPWR_FAN_FAULT				(wPWR_FAN_FAULT),
		.iPWR_NIC0_FAULT			(wPWR_NIC0_FAULT),
		.iPWR_NIC1_FAULT			(wPWR_NIC1_FAULT),
		
		.iLeakage_BMC_ready			(IOEXP0_INT_N_Edge_Detect),
		.iFault_BMC_ready			(IOEXP1_INT_N_Edge_Detect),
		
        .oDBG_MSTR_SEQ_FSM_curr     (wDBG_MSTR_SEQ_FSM_curr),
		.oDBG_MSTR_SEQ_FSM_prev2    (wDBG_MSTR_SEQ_FSM_prev2),
		.oDBG_MSTR_SEQ_FSM_prev1    (wDBG_MSTR_SEQ_FSM_prev1),
		.oDBG_MSTR_SEQ_FSM_prev0    (wDBG_MSTR_SEQ_FSM_prev0)
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
	
		.oNICx_FSM_curr			(wDBG_NICx_SEQ_FSM_curr),
		.oNICx_FSM_prev			(wDBG_NICx_SEQ_FSM_prev)
    );

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
	
	I2C_Control#
	(
		.i2c_slave_addr		(7'h10)
	)I2C_Control_0
	(
		.iClk				(wOSC),
		.iClk_1ms			(wCLK_1ms),
		.iRst_n				(wRST_N),
		.INT_DISABLE_N		(1'b1),
		.INT_N				(IOEXP0_INT_N),
		.SMB_CPLD_LOG_SCL	(I2C_3V3_15_SCL_R2),
		.SMB_CPLD_LOG_SDA	(I2C_3V3_15_SDA_R2),
		.iI0				({
							IOEXPx_INPUT_config[159:152]
							}),
		.iI1				({
							IOEXPx_INPUT_config[151:144]
							}),
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
							IOEXP0_output[5],
							IOEXP0_output[4],
							IOEXP0_output[3],
							IOEXP0_output[2],
							IOEXP0_output[1],
							IOEXP0_output[0]
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

	wire	[15:0]	IOEXP1_output;
	wire	IOEXP1_INT_N;
	wire	IOEXP1_INT_N_Edge_Detect;

	I2C_Control#
	(
		.i2c_slave_addr		(7'h11)
	)I2C_Control_1
	(
		.iClk				(wOSC),
		.iClk_1ms			(wCLK_1ms),
		.iRst_n				(wRST_N),
		.INT_DISABLE_N		(1'b1),
		.INT_N				(IOEXP1_INT_N),
		.SMB_CPLD_LOG_SCL	(I2C_3V3_15_SCL_R2),
		.SMB_CPLD_LOG_SDA	(I2C_3V3_15_SDA_R2),
		.iI0				({
							IOEXPx_INPUT_config[143:136]
							}),
		.iI1				({
							IOEXPx_INPUT_config[135:128]
							}),
		.output_data		({
							IOEXP1_output[15],
							IOEXP1_output[14],
							IOEXP1_output[13],
							IOEXP1_output[12],
							IOEXP1_output[11],
							IOEXP1_output[10],
							IOEXP1_output[9],
							IOEXP1_output[8],
							IOEXP1_output[7],
							IOEXP1_output[6],
							IOEXP1_output[5],
							IOEXP1_output[4],
							IOEXP1_output[3],
							IOEXP1_output[2],
							IOEXP1_output[1],
							IOEXP1_output[0]
							})
	);

	Edge_Detector IOEXP1_INT_N_Detect
	(
		.iClk					(wOSC),
		.iRst_n					(wRST_N),
		.iClear					(),

		.pos_neg				(1'b1),
		.input_sig				(IOEXP1_INT_N),

		.output_pulse_sig		(IOEXP1_INT_N_Edge_Detect),
		.output_constant_sig	()
	);

	wire	[15:0]	IOEXP2_output;
	wire	IOEXP2_INT_N;
	wire	IOEXP2_INT_N_Edge_Detect;

	I2C_Control#
	(
		.i2c_slave_addr		(7'h12)
	)I2C_Control_2
	(
		.iClk				(wOSC),
		.iClk_1ms			(wCLK_1ms),
		.iRst_n				(wRST_N),
		.INT_DISABLE_N		(1'b1),
		.INT_N				(IOEXP2_INT_N),
		.SMB_CPLD_LOG_SCL	(I2C_3V3_15_SCL_R2),
		.SMB_CPLD_LOG_SDA	(I2C_3V3_15_SDA_R2),
		.iI0				({
							IOEXPx_INPUT_config[127:120]
							}),
		.iI1				({
							IOEXPx_INPUT_config[119:112]
							}),
		.output_data		({
							IOEXP2_output[15],
							IOEXP2_output[14],	
							IOEXP2_output[13],
							IOEXP2_output[12],
							IOEXP2_output[11],
							IOEXP2_output[10],
							IOEXP2_output[9],
							IOEXP2_output[8],
							IOEXP2_output[7],
							IOEXP2_output[6],
							IOEXP2_output[5],
							IOEXP2_output[4],
							IOEXP2_output[3],
							IOEXP2_output[2],
							IOEXP2_output[1],
							IOEXP2_output[0]
							})
	);

	Edge_Detector IOEXP2_INT_N_Detect
	(
		.iClk				(wOSC),
		.iRst_n				(wRST_N),

		.pos_neg			(1'b1),
		.input_sig			(IOEXP2_INT_N),

		.output_sig			(IOEXP2_INT_N_Edge_Detect)
	);

	wire	[15:0]	IOEXP3_output;
	wire	IOEXP3_INT_N;
	wire	IOEXP3_INT_N_Edge_Detect;

	I2C_Control#
	(
		.i2c_slave_addr		(7'h13)
	)I2C_Control_3
	(
		.iClk				(wOSC),
		.iClk_1ms			(wCLK_1ms),
		.iRst_n				(wRST_N),
		.INT_DISABLE_N		(1'b1),
		.INT_N				(IOEXP3_INT_N),
		.SMB_CPLD_LOG_SCL	(I2C_3V3_15_SCL_R2),
		.SMB_CPLD_LOG_SDA	(I2C_3V3_15_SDA_R2),
		.iI0				({
							IOEXPx_INPUT_config[111:104]
							}),
		.iI1				({
							IOEXPx_INPUT_config[103:96]
							}),
		.output_data		({
							IOEXP3_output[15],
							IOEXP3_output[14],
							IOEXP3_output[13],
							IOEXP3_output[12],
							IOEXP3_output[11],
							IOEXP3_output[10],
							IOEXP3_output[9],
							IOEXP3_output[8],
							IOEXP3_output[7],
							IOEXP3_output[6],
							IOEXP3_output[5],
							IOEXP3_output[4],
							IOEXP3_output[3],
							IOEXP3_output[2],
							IOEXP3_output[1],
							IOEXP3_output[0]
							})
	);

	Edge_Detector IOEXP3_INT_N_Detect
	(
		.iClk				(wOSC),
		.iRst_n				(wRST_N),

		.pos_neg			(1'b1),
		.input_sig			(IOEXP3_INT_N),

		.output_sig			(IOEXP3_INT_N_Edge_Detect)
	);

	wire	[15:0]	IOEXP4_output;
	wire	IOEXP4_INT_N;
	wire	IOEXP4_INT_N_Edge_Detect;

	I2C_Control#
	(
		.i2c_slave_addr		(7'h14)
	)I2C_Control_4
	(
		.iClk				(wOSC),
		.iClk_1ms			(wCLK_1ms),
		.iRst_n				(wRST_N),
		.INT_DISABLE_N		(1'b1),
		.INT_N				(IOEXP4_INT_N),
		.SMB_CPLD_LOG_SCL	(I2C_3V3_15_SCL_R2),
		.SMB_CPLD_LOG_SDA	(I2C_3V3_15_SDA_R2),
		.iI0				({
							IOEXPx_INPUT_config[95:88]
							}),
		.iI1				({
							IOEXPx_INPUT_config[87:80]
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
							IOEXP4_output[7],
							IOEXP4_output[6],
							IOEXP4_output[5],
							IOEXP4_output[4],
							IOEXP4_output[3],
							IOEXP4_output[2],
							IOEXP4_output[1],
							IOEXP4_output[0]
							})
	);

	Edge_Detector IOEXP4_INT_N_Detect
	(
		.iClk				(wOSC),
		.iRst_n				(wRST_N),

		.pos_neg			(1'b1),
		.input_sig			(IOEXP4_INT_N),

		.output_sig			(IOEXP4_INT_N_Edge_Detect)
	);

	wire	[15:0]	IOEXP5_output;
	wire	IOEXP5_INT_N;
	wire	IOEXP5_INT_N_Edge_Detect;

	I2C_Control#
	(
		.i2c_slave_addr		(7'h15)
	)I2C_Control_5
	(
		.iClk				(wOSC),
		.iClk_1ms			(wCLK_1ms),
		.iRst_n				(wRST_N),
		.INT_DISABLE_N		(1'b1),
		.INT_N				(IOEXP5_INT_N),
		.SMB_CPLD_LOG_SCL	(I2C_3V3_15_SCL_R2),
		.SMB_CPLD_LOG_SDA	(I2C_3V3_15_SDA_R2),
		.iI0				({
							IOEXPx_INPUT_config[79:72]
							}),
		.iI1				({
							IOEXPx_INPUT_config[71:64]
							}),
		.output_data		({
							IOEXP5_output[15],
							IOEXP5_output[14],
							IOEXP5_output[13],
							IOEXP5_output[12],
							IOEXP5_output[11],
							IOEXP5_output[10],
							IOEXP5_output[8],
							IOEXP5_output[9],
							IOEXP5_output[7],
							IOEXP5_output[6],
							IOEXP5_output[5],
							IOEXP5_output[4],
							IOEXP5_output[3],
							IOEXP5_output[2],
							IOEXP5_output[1],
							IOEXP5_output[0]
							})
	);

	Edge_Detector IOEXP5_INT_N_Detect
	(
		.iClk				(wOSC),
		.iRst_n				(wRST_N),

		.pos_neg			(1'b1),
		.input_sig			(IOEXP5_INT_N),

		.output_sig			(IOEXP5_INT_N_Edge_Detect)
	);

	wire	[15:0]	IOEXP6_output;
	wire	IOEXP6_INT_N;
	wire	IOEXP6_INT_N_Edge_Detect;

	I2C_Control#
	(
		.i2c_slave_addr		(7'h16)
	)I2C_Control_6
	(
		.iClk				(wOSC),
		.iClk_1ms			(wCLK_1ms),
		.iRst_n				(wRST_N),
		.INT_DISABLE_N		(1'b0),
		.INT_N				(IOEXP6_INT_N),
		.SMB_CPLD_LOG_SCL	(I2C_3V3_15_SCL_R2),
		.SMB_CPLD_LOG_SDA	(I2C_3V3_15_SDA_R2),
		.iI0				({
							IOEXPx_INPUT_config[63:56]
							}),
		.iI1				({
							IOEXPx_INPUT_config[55:48]
							}),
		.output_data		({
							IOEXP6_output[15],
							IOEXP6_output[14],
							IOEXP6_output[13],
							IOEXP6_output[12],
							IOEXP6_output[11],			
							IOEXP6_output[10],			
							IOEXP6_output[9],			
							IOEXP6_output[8],			
							IOEXP6_output[7],
							IOEXP6_output[6],
							IOEXP6_output[5],
							IOEXP6_output[4],
							IOEXP6_output[3],
							IOEXP6_output[2],
							IOEXP6_output[1],
							IOEXP6_output[0]
							})
	);

	wire	[15:0]	IOEXP7_output;
	wire	IOEXP7_INT_N;
	wire	IOEXP7_INT_N_Edge_Detect;

	I2C_Control#
	(
		.i2c_slave_addr		(7'h17)
	)I2C_Control_7
	(
		.iClk				(wOSC),
		.iClk_1ms			(wCLK_1ms),
		.iRst_n				(wRST_N),
		.INT_DISABLE_N		(1'b0),
		.INT_N				(IOEXP7_INT_N),
		.SMB_CPLD_LOG_SCL	(I2C_3V3_15_SCL_R2),
		.SMB_CPLD_LOG_SDA	(I2C_3V3_15_SDA_R2),
		.iI0				({
							IOEXPx_INPUT_config[47:40]
							}),
		.iI1				({
							IOEXPx_INPUT_config[39:32]
							}),
		.output_data		({
							IOEXP7_output[15],
							IOEXP7_output[14],
							IOEXP7_output[13],
							IOEXP7_output[12],
							IOEXP7_output[11],			
							IOEXP7_output[10],			
							IOEXP7_output[9],			
							IOEXP7_output[8],			
							IOEXP7_output[7],
							IOEXP7_output[6],
							IOEXP7_output[5],
							IOEXP7_output[4],
							IOEXP7_output[3],
							IOEXP7_output[2],
							IOEXP7_output[1],
							IOEXP7_output[0]
							})
	);

	wire	[15:0]	IOEXP8_output;
	wire	IOEXP8_INT_N;
	wire	IOEXP8_INT_N_Edge_Detect;

	I2C_Control#
	(
		.i2c_slave_addr		(7'h18)
	)I2C_Control_8
	(
		.iClk				(wOSC),
		.iClk_1ms			(wCLK_1ms),
		.iRst_n				(wRST_N),
		.INT_DISABLE_N		(1'b0),
		.INT_N				(IOEXP8_INT_N),
		.SMB_CPLD_LOG_SCL	(I2C_3V3_15_SCL_R2),
		.SMB_CPLD_LOG_SDA	(I2C_3V3_15_SDA_R2),
		.iI0				({
							IOEXPx_INPUT_config[31:24]
							}),
		.iI1				({
							IOEXPx_INPUT_config[23:16]
							}),
		.output_data		({
							IOEXP8_output[15],
							IOEXP8_output[14],
							IOEXP8_output[13],
							IOEXP8_output[12],
							IOEXP8_output[11],			
							IOEXP8_output[10],			
							IOEXP8_output[9],			
							IOEXP8_output[8],			
							IOEXP8_output[7],
							IOEXP8_output[6],
							IOEXP8_output[5],
							IOEXP8_output[4],
							IOEXP8_output[3],
							IOEXP8_output[2],
							IOEXP8_output[1],
							IOEXP8_output[0]
							})
	);

	wire	[15:0]	IOEXP9_output;
	wire	IOEXP9_INT_N;
	wire	IOEXP9_INT_N_Edge_Detect;

	I2C_Control#
	(
		.i2c_slave_addr		(7'h19)
	)I2C_Control_9
	(
		.iClk				(wOSC),
		.iClk_1ms			(wCLK_1ms),
		.iRst_n				(wRST_N),
		.INT_DISABLE_N		(1'b0),
		.INT_N				(IOEXP9_INT_N),
		.SMB_CPLD_LOG_SCL	(I2C_3V3_15_SCL_R2),
		.SMB_CPLD_LOG_SDA	(I2C_3V3_15_SDA_R2),
		.iI0				({
							IOEXPx_INPUT_config[15:8]
							}),
		.iI1				({
							IOEXPx_INPUT_config[7:0]
							}),
		.output_data		({
							IOEXP9_output[15],
							IOEXP9_output[14],
							IOEXP9_output[13],
							IOEXP9_output[12],
							IOEXP9_output[11],			
							IOEXP9_output[10],			
							IOEXP9_output[9],			
							IOEXP9_output[8],			
							IOEXP9_output[7],			//	RMC Error injection(large leak)
							IOEXP9_output[6],			//	RMC Error injection(small leak)
							IOEXP9_output[5],			//	MFG LED test mode(low active)
							IOEXP9_output[4],			//	clear sequence latch
							IOEXP9_output[3],			//	platform config 3
							IOEXP9_output[2],			//	platform config 2
							IOEXP9_output[1],			//	platform config 1
							IOEXP9_output[0]			//	platform config 0
							})
	);

	wire 	[159:0] IOEXPx_INPUT_config;

	assign	IOEXPx_INPUT_config =
	{
		//IOEXP_0_input
		//IOEXPx_INPUT_config[159:152]
		wCHASSIS0_LEAK_Q_N_PLD,
		wCHASSIS2_LEAK_Q_N_PLD,
		wCHASSIS1_LEAK_Q_N_PLD,
		wCHASSIS3_LEAK_Q_N_PLD,
		wLEAK0_DETECT_R,
		wLEAK2_DETECT_R,
		wLEAK1_DETECT_R,
		wLEAK3_DETECT_R,
		//IOEXPx_INPUT_config[151:144]
		1'b1,
		1'b1,
		wSMB_RJ45_FIO_TMP_ALERT,
		RSVD_RMC_GPIO3_R,
		LEAK_DETECT_RMC_N_R,
		wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N,
		wOCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N,
		FM_SYS_THROTTLE_N,
		//IOEXP_1_input
		//IOEXPx_INPUT_config[143:136]
		wP12V_AUX_FAN_FAULT_PLD_N,
		wP12V_AUX_FAN_OC_PLD_N,
		wP48V_HS1_FAULT_N_PLD,
		wP48V_HS2_FAULT_N_PLD,
		wFM_P3V3_NIC0_FAULT_R_N,
		wFM_P12V_NIC0_FLTB_R_N,
		wFM_P3V3_NIC1_FAULT_R_N,
    	wFM_P12V_NIC1_FLTB_R_N,
		//IOEXPx_INPUT_config[135:128]
		wP52V_SENSE_ALERT_PLD_N,
		wP12V_AUX_FAN_ALERT_PLD_N,
		wNODEA_PSU_SMB_ALERT_R_L,
		wNODEB_PSU_SMB_ALERT_R_L,
		wP12V_AUX_NIC0_SENSE_ALERT_R_N,
		wP12V_AUX_NIC1_SENSE_ALERT_R_N,
		wP12V_SCM_SENSE_ALERT_R_N,
		wP12V_AUX_PSU_SMB_ALERT_R_L,
		//IOEX_2_input
		//IOEXPx_INPUT_config[127:120]
		wFAN_0_PRESENT_N,
		wFAN_1_PRESENT_N,
		wFAN_2_PRESENT_N,
		wFAN_3_PRESENT_N,
		wFAN_4_PRESENT_N,
		wFAN_5_PRESENT_N,
		wFAN_6_PRESENT_N,
		wFAN_7_PRESENT_N,
		//IOEXPx_INPUT_config[119:112]
		1'b0,
		wPRSNT_OSFP0_POWER_CABLE_N,
        wPRSNT_HDDBD_POWER_CABLE_N,
		wPRSNT_RJ45_FIO_N_R,
		wPRSNT_CHASSIS0_LEAK_CABLE_R_N,
		wPRSNT_CHASSIS2_LEAK_CABLE_R_N,
		wPRSNT_CHASSIS1_LEAK_CABLE_R_N,
		wPRSNT_CHASSIS3_LEAK_CABLE_R_N,
		//IOEXP_3_input
		//IOEXPx_INPUT_config[111:104]
		wHP_OCP_V3_1_HSC_PWRGD_PLD_R,
        wHP_LVC3_OCP_V3_1_PWRGD_PLD,
        OCP_SFF_AUX_PWR_PLD_EN_R,
		wFM_OCP_SFF_PWR_GOOD_PLD,
		OCP_SFF_MAIN_PWR_EN,
		wOCP_SFF_PERST_FROM_HOST_ISO_PLD_N,
        wNIC0_PERST_N,
		RST_OCP_V3_1_R_N,
		//IOEXPx_INPUT_config[103:96]
		wHP_OCP_V3_2_HSC_PWRGD_PLD_R,
        wHP_LVC3_OCP_V3_2_PWRGD_PLD,
        OCP_V3_2_AUX_PWR_PLD_EN_R,
		wFM_OCP_V3_2_PWR_GOOD_PLD,
		OCP_V3_2_MAIN_PWR_EN,
		wOCP_V3_2_PERST_FROM_HOST_ISO_PLD_N,
        wNIC1_PERST_N,
		RST_OCP_V3_2_R_N,
		//IOEXP_4_input
		//IOEXPx_INPUT_config[95:88]
		wPWRGD_P3V3_AUX_PLD,
		wPWRGD_P12V_AUX_PLD_ISO_R,
		P12V_AUX_FAN_EN_PLD,
		wPWRGD_P12V_AUX_FAN_PLD,
		wFM_MAIN_PWREN_RMC_EN_ISO_R,
		wPDB_P12V_EN_N_ISO_PLD_R,
		FM_MAIN_PWREN_FROM_RMC_R,
		wPWR_EN_Devices,
		//IOEXPx_INPUT_config[87:80]
		wP12V_N1_ENABLE_PLD_R,
		wP12V_N2_ENABLE_PLD_R,
		P12V_N1_ENABLE_R,
		P12V_N2_ENABLE_R,
		wNODEA_NODEB_PWOK_PLD_ISO_R,
		PWRGD_RMC_R,
		wHP_LVC3_OCP_V3_1_PRSNT2_PLD_N,
        wHP_LVC3_OCP_V3_2_PRSNT2_PLD_N,
        //IOEXP_5_input
		//IOEXPx_INPUT_config[79:72]
		wPWR_BTN_BMC_R_N,
		wFAB_BMC_REV_ID0,
        wFAB_BMC_REV_ID1,
        wFAB_BMC_REV_ID2,
		wFM_BOARD_BMC_SKU_ID0,
        wFM_BOARD_BMC_SKU_ID1,
        wFM_BOARD_BMC_SKU_ID2,
        wFM_BOARD_BMC_SKU_ID3,
		//IOEXPx_INPUT_config[71:64]
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		//IOEXP_6_input
		//IOEXPx_INPUT_config[63:56]
		wDBG_MSTR_SEQ_FSM_curr,
		wDBG_MSTR_SEQ_FSM_prev2,
		//IOEXPx_INPUT_config[55:48]
		wDBG_MSTR_SEQ_FSM_prev1,
		wDBG_MSTR_SEQ_FSM_prev0,
		//IOEXP_7_input
		//IOEXPx_INPUT_config[47:40]
		wDBG_NICx_SEQ_FSM_curr[7],
		wDBG_NICx_SEQ_FSM_curr[6],
		wDBG_NICx_SEQ_FSM_curr[5],
		wDBG_NICx_SEQ_FSM_curr[4],
		wDBG_NICx_SEQ_FSM_prev[7],
		wDBG_NICx_SEQ_FSM_prev[6],
		wDBG_NICx_SEQ_FSM_prev[5],
		wDBG_NICx_SEQ_FSM_prev[4],
		//IOEXPx_INPUT_config[39:32]
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		//IOEXP_8_input
		//IOEXPx_INPUT_config[31:24]
		wDBG_NICx_SEQ_FSM_curr[3],
		wDBG_NICx_SEQ_FSM_curr[2],
		wDBG_NICx_SEQ_FSM_curr[1],
		wDBG_NICx_SEQ_FSM_curr[0],
		wDBG_NICx_SEQ_FSM_prev[3],
		wDBG_NICx_SEQ_FSM_prev[2],
		wDBG_NICx_SEQ_FSM_prev[1],
		wDBG_NICx_SEQ_FSM_prev[0],
		//IOEXPx_INPUT_config[23:16]
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		//IOEXP_9_input
		//IOEXPx_INPUT_config[15:8]
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		//IOEXPx_INPUT_config[7:0]
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1,
		1'b1
	};
/*
    wire	[7:0] wI2C_CMD_O_BMC; 
    wire	[7:0] wI2C_DAT_O_BMC; 
    wire	[7:0] wI2C_DAT_I_BMC; 
    wire	wI2C_WREN_BMC;  
    wire	wI2C_RDEN_BMC;
	wire	[7:0] wI2C_CMD_O_RMC;
    wire	[7:0] wI2C_DAT_O_RMC; 
    wire	[7:0] wI2C_DAT_I_RMC; 
    wire	wI2C_WREN_RMC;  
    wire	wI2C_RDEN_RMC;
    wire	[7:0] wFPGA_REG_00;
    wire	[7:0] wFPGA_REG_01;
    wire	[7:0] wFPGA_REG_02;
    wire	[7:0] wFPGA_REG_03;
    wire	[7:0] wFPGA_REG_04;
    wire	[7:0] wFPGA_REG_05;
    wire	[7:0] wFPGA_REG_06;
    wire	[7:0] wFPGA_REG_07;    
	wire	[7:0] wFPGA_REG_08;
    wire	[7:0] wFPGA_REG_09;
    wire	[7:0] wFPGA_REG_0A;
    wire	[7:0] wFPGA_REG_0B;
    wire	[7:0] wFPGA_REG_0C;
    wire	[7:0] wFPGA_REG_0D;
    wire	[7:0] wFPGA_REG_0E;
    wire	[7:0] wFPGA_REG_0F;
    wire	[7:0] wFPGA_REG_10;
    wire	[7:0] wFPGA_REG_11;
    wire	[7:0] wFPGA_REG_12;
    wire	[7:0] wFPGA_REG_13;
    wire	[7:0] wFPGA_REG_14;
    wire	[7:0] wFPGA_REG_15;
    wire	[7:0] wFPGA_REG_16;
    wire	[7:0] wFPGA_REG_17;
    wire	[7:0] wFPGA_REG_18;
    wire	[7:0] wFPGA_REG_19;
    wire	[7:0] wFPGA_REG_1A;
    wire	[7:0] wFPGA_REG_1B;
    wire	[7:0] wFPGA_REG_1C;
    wire	[7:0] wFPGA_REG_1D;
    wire	[7:0] wFPGA_REG_1E;
    wire	[7:0] wFPGA_REG_1F;
		
	// SMBus Register
	SMBusControl mSMBusControl_BMC
	(
		.CLK_IN     	(wOSC),
		.RESET_N    	(wRST_N),
		.I2C_ADR_I  	(7'h2f),
		.SDA        	(I2C_3V3_15_SDA_R2),
		.SCL        	(I2C_3V3_15_SCL_R2),
		.I2C_CMD_O  	(wI2C_CMD_O_BMC),
		.I2C_DAT_O  	(wI2C_DAT_O_BMC),
		.I2C_DAT_I  	(wI2C_DAT_I_BMC),
		.I2C_WREN   	(wI2C_WREN_BMC),
		.I2C_RDEN   	(wI2C_RDEN_BMC)
	);	

	SMBusRegs mSMBusRegs_BMC
	(
		.CLK_IN         (wOSC),
		.RESET_N        (wRST_N),
		.I2C_CMD        (wI2C_CMD_O_BMC),
		.I2C_DAT_O      (wI2C_DAT_I_BMC),
		.I2C_DAT_I      (wI2C_DAT_O_BMC),
		.I2C_WREN       (wI2C_WREN_BMC),
		.I2C_RDEN       (wI2C_RDEN_BMC),
		.iFPGA_REG_00    (wFPGA_REG_00),
		.iFPGA_REG_01    (wFPGA_REG_01),
		.iFPGA_REG_02    (wFPGA_REG_02),
		.iFPGA_REG_03    (wFPGA_REG_03),
		.iFPGA_REG_04    (wFPGA_REG_04),
		.iFPGA_REG_05    (wFPGA_REG_05),
		.iFPGA_REG_06    (wFPGA_REG_06),
		.iFPGA_REG_07    (wFPGA_REG_07),
		.iFPGA_REG_08    (wFPGA_REG_08),
		.iFPGA_REG_09    (wFPGA_REG_09),
		.iFPGA_REG_0A    (wFPGA_REG_0A),
		.iFPGA_REG_0B    (wFPGA_REG_0B),
		.iFPGA_REG_0C    (wFPGA_REG_0C),
		.iFPGA_REG_0D    (wFPGA_REG_0D),
		.iFPGA_REG_0E    (wFPGA_REG_0E),
		.iFPGA_REG_0F    (wFPGA_REG_0F),
		.iFPGA_REG_10    (wFPGA_REG_10),
		.iFPGA_REG_11    (wFPGA_REG_11),
		.iFPGA_REG_12    (wFPGA_REG_12),
		.iFPGA_REG_13    (wFPGA_REG_13),
		.iFPGA_REG_14    (wFPGA_REG_14),
		.iFPGA_REG_15    (wFPGA_REG_15),
		.iFPGA_REG_16    (wFPGA_REG_16),
		.iFPGA_REG_17    (wFPGA_REG_17),
		.iFPGA_REG_18    (wFPGA_REG_18),
		.iFPGA_REG_19    (wFPGA_REG_19),
		.iFPGA_REG_1A    (wFPGA_REG_1A),
		.iFPGA_REG_1B    (wFPGA_REG_1B),
		.iFPGA_REG_1C    (wFPGA_REG_1C),
		.iFPGA_REG_1D    (wFPGA_REG_1D),
		.iFPGA_REG_1E    (wFPGA_REG_1E),
		.iFPGA_REG_1F    (wFPGA_REG_1F)
	);  

	SMBusControl mSMBusControl_RMC
	(
		.CLK_IN     (wOSC),
		.RESET_N    (wRST_N),
		.I2C_ADR_I  (7'h2f),
		.SDA        (I2C_RMC_SDA_BUF),
		.SCL        (I2C_RMC_SCL_BUF),
		.I2C_CMD_O  (wI2C_CMD_O_RMC),
		.I2C_DAT_O  (wI2C_DAT_O_RMC),
		.I2C_DAT_I  (wI2C_DAT_I_RMC),
		.I2C_WREN   (wI2C_WREN_RMC),
		.I2C_RDEN   (wI2C_RDEN_RMC)
	);

	SMBusRegs mSMBusRegs_RMC
	(
		.CLK_IN         (wOSC),
		.RESET_N        (wRST_N),
		.I2C_CMD        (wI2C_CMD_O_RMC),
		.I2C_DAT_O      (wI2C_DAT_I_RMC),
		.I2C_DAT_I      (wI2C_DAT_O_RMC),
		.I2C_WREN       (wI2C_WREN_RMC),
		.I2C_RDEN       (wI2C_RDEN_RMC),
		.iFPGA_REG_00    (wFPGA_REG_00),
		.iFPGA_REG_01    (wFPGA_REG_01),
		.iFPGA_REG_02    (wFPGA_REG_02),
		.iFPGA_REG_03    (wFPGA_REG_03),
		.iFPGA_REG_04    (wFPGA_REG_04),
		.iFPGA_REG_05    (wFPGA_REG_05),
		.iFPGA_REG_06    (wFPGA_REG_06),
		.iFPGA_REG_07    (wFPGA_REG_07),
		.iFPGA_REG_08    (wFPGA_REG_08),
		.iFPGA_REG_09    (wFPGA_REG_09),
		.iFPGA_REG_0A    (wFPGA_REG_0A),
		.iFPGA_REG_0B    (wFPGA_REG_0B),
		.iFPGA_REG_0C    (wFPGA_REG_0C),
		.iFPGA_REG_0D    (wFPGA_REG_0D),
		.iFPGA_REG_0E    (wFPGA_REG_0E),
		.iFPGA_REG_0F    (wFPGA_REG_0F),
		.iFPGA_REG_10    (wFPGA_REG_10),
		.iFPGA_REG_11    (wFPGA_REG_11),
		.iFPGA_REG_12    (wFPGA_REG_12),
		.iFPGA_REG_13    (wFPGA_REG_13),
		.iFPGA_REG_14    (wFPGA_REG_14),
		.iFPGA_REG_15    (wFPGA_REG_15),
		.iFPGA_REG_16    (wFPGA_REG_16),
		.iFPGA_REG_17    (wFPGA_REG_17),
		.iFPGA_REG_18    (wFPGA_REG_18),
		.iFPGA_REG_19    (wFPGA_REG_19),
		.iFPGA_REG_1A    (wFPGA_REG_1A),
		.iFPGA_REG_1B    (wFPGA_REG_1B),
		.iFPGA_REG_1C    (wFPGA_REG_1C),
		.iFPGA_REG_1D    (wFPGA_REG_1D),
		.iFPGA_REG_1E    (wFPGA_REG_1E),
		.iFPGA_REG_1F    (wFPGA_REG_1F)
	);  

	//	Address 0x13, offset 0x00
	assign	wFPGA_REG_00 =
		{
			wRST_N,
			wCLK_50M,
			wCLK_2M,
			wCLK_1ms,
			wCLK_EN_O0,
			wCLK_EN_O1,
			wCLK_EN_O2,
			wCLK_EN_O3
		};
	//	Address 0x13, offset 0x00
	assign	wFPGA_REG_00 =
		{
			wRST_N,
			wCLK_50M,
			wCLK_2M,
			wCLK_1ms,
			wCLK_EN_O0,
			wCLK_EN_O1,
			wCLK_EN_O2,
			wCLK_EN_O3
		};
	//	Address 0x13, offset 0x01
	assign	wFPGA_REG_01 =
		{
			wP12V_AUX_PSU_SMB_ALERT_R_L,
			wP52V_SENSE_ALERT_PLD_N,
			wP48V_HS1_FAULT_N_PLD,
			wP48V_HS2_FAULT_N_PLD,
			P12V_AUX_PSU_SMB_ALERT_R_L,	    	//  B11 PDB P12V VR alert
        	P52V_SENSE_ALERT_PLD_N,	            //  A8	P52V Sense alert
        	P48V_HS1_FAULT_N_PLD,	            //  D14	P48V HSC1 fault
        	P48V_HS2_FAULT_N_PLD	            //  E15 P48V HSC2 fault
		};
	//	Address 0x13, offset 0x02
	assign	wFPGA_REG_02 =
		{
			wPWRGD_P3V3_AUX_PLD,
			wPWRGD_P12V_AUX_PLD_ISO_R,
			wPRSNT_OSFP0_POWER_CABLE_N,
			wPRSNT_HDDBD_POWER_CABLE_N,
			PWRGD_P3V3_AUX_PLD,	            	//  F16	PWRGD of P3V3_AUX on PDB
			PWRGD_P12V_AUX_PLD_ISO_R,			//  N6  P12V_AUX PWRGD
			PRSNT_OSFP0_POWER_CABLE_N,	    	//  J15 Cable PRSNT of OSFP
        	PRSNT_HDDBD_POWER_CABLE_N	    	//  K14 Cable PRSNT of HDDBD
		};
	//	Address 0x13, offset 0x03
	assign	wFPGA_REG_03 =
		{
			wLarge_Leakage,
			wSmall_Leakage,
			wLarge_Leakage_N,
			wSmall_Leakage_N,
			wP12V_AUX_NIC1_SENSE_ALERT_R_N,		
			wP12V_AUX_NIC0_SENSE_ALERT_R_N,
			P12V_AUX_NIC1_SENSE_ALERT_R_N,	    //  B9
        	P12V_AUX_NIC0_SENSE_ALERT_R_N		    //  D9
		};
	//	Address 0x13, offset 0x04
	assign	wFPGA_REG_04 =
		{
			wOCP_V3_2_PERST_FROM_HOST_ISO_PLD_N,
			wOCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N,
			wFM_P3V3_NIC1_FAULT_R_N,
			wFM_P12V_NIC1_FLTB_R_N,
			OCP_V3_2_PERST_FROM_HOST_ISO_PLD_N,	//  F14
        	OCP_V3_2_PWRBRK_FROM_HOST_ISO_PLD_N,//  P15
        	FM_P3V3_NIC1_FAULT_R_N,	            //  E8
        	FM_P12V_NIC1_FLTB_R_N	            	//  D7
		};
	//	Address 0x13, offset 0x05
	assign	wFPGA_REG_05 =
		{
			wHP_OCP_V3_2_HSC_PWRGD_PLD_R,
			wHP_LVC3_OCP_V3_2_PRSNT2_PLD_N,
			wHP_LVC3_OCP_V3_2_PWRGD_PLD,
			wFM_OCP_V3_2_PWR_GOOD_PLD,
			HP_OCP_V3_2_HSC_PWRGD_PLD_R,	//  E7
        	HP_LVC3_OCP_V3_2_PRSNT2_PLD_N,		//  B4
        	HP_LVC3_OCP_V3_2_PWRGD_PLD,	    	//  C7
        	FM_OCP_V3_2_PWR_GOOD_PLD	        //  E9
		};
	//	Address 0x13, offset 0x06
	assign	wFPGA_REG_06 =
		{
			wOCP_SFF_PERST_FROM_HOST_ISO_PLD_N,
			wOCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N,
			wFM_P3V3_NIC0_FAULT_R_N,
			wFM_P12V_NIC0_FLTB_R_N,
			OCP_SFF_PERST_FROM_HOST_ISO_PLD_N,	//  F15
        	OCP_SFF_PWRBRK_FROM_HOST_ISO_PLD_N,	//  R16
        	FM_P3V3_NIC0_FAULT_R_N,	            //  F7
        	FM_P12V_NIC0_FLTB_R_N		            //  E6
		};
	//	Address 0x13, offset 0x07
	assign	wFPGA_REG_07 =
		{
			wHP_OCP_V3_1_HSC_PWRGD_PLD_R,
			wHP_LVC3_OCP_V3_1_PRSNT2_PLD_N,
			wHP_LVC3_OCP_V3_1_PWRGD_PLD,
			wFM_OCP_SFF_PWR_GOOD_PLD,
			HP_OCP_V3_1_HSC_PWRGD_PLD_R,	//  D6
        	HP_LVC3_OCP_V3_1_PRSNT2_PLD_N,		//  A3
        	HP_LVC3_OCP_V3_1_PWRGD_PLD,	    	//  B7
        	FM_OCP_SFF_PWR_GOOD_PLD	        	//  D8
		};  	
	//	Address 0x13, offset 0x08
	assign	wFPGA_REG_08 =
		{
        	wP12V_SCM_SENSE_ALERT_R_N,
			wSMB_RJ45_FIO_TMP_ALERT,
			wPRSNT_RJ45_FIO_N_R,
			wRSVD_RMC_GPIO3_R,
			P12V_SCM_SENSE_ALERT_R_N,
			SMB_RJ45_FIO_TMP_ALERT,	        	//  G16
        	PRSNT_RJ45_FIO_N_R,	            	//  E16
        	RSVD_RMC_GPIO3_R	                //  J14 no function determined
		};
	//	Address 0x13, offset 0x09
	assign	wFPGA_REG_09 =
		{
            wFM_BOARD_BMC_SKU_ID0,
			wFM_BOARD_BMC_SKU_ID1,
			wFM_BOARD_BMC_SKU_ID2,
			wFM_BOARD_BMC_SKU_ID3,
			FM_BOARD_BMC_SKU_ID0,	            //  A4	BOARD BOM SKU ID
        	FM_BOARD_BMC_SKU_ID1,	            //  B3	BOARD BOM SKU ID
        	FM_BOARD_BMC_SKU_ID2,	            //  B5	BOARD BOM SKU ID
        	FM_BOARD_BMC_SKU_ID3	            //  C4	BOARD BOM SKU ID
		};
	//	Address 0x13, offset 0x0A
	assign	wFPGA_REG_0A =
		{
			wPWR_VR_Alert,
			wPWR_Sense_Alert,
            wFAB_BMC_REV_ID0,
			wFAB_BMC_REV_ID1,
			wFAB_BMC_REV_ID2,
			FAB_BMC_REV_ID0,	                //  B6	BOARD REV ID
        	FAB_BMC_REV_ID1,	                //  A5	BOARD REV ID
        	FAB_BMC_REV_ID2		                //  C5	BOARD REV ID
		};
	//	Address 0x13, offset 0x0B
	assign	wFPGA_REG_0B =
		{
            wFM_PLD_LEAK_DETECT_PWM,
			FM_PLD_LEAK_DETECT_PWM,	        	//  J16	Leak sensor PWM monitor input
        	wPRSNT_CHASSIS0_LEAK_CABLE_R_N,
			wCHASSIS0_LEAK_Q_N_PLD,
			wLEAK0_DETECT_R,
			PRSNT_CHASSIS0_LEAK_CABLE_R_N,		//  L14	PRSNT of Internal LEAK_0
        	CHASSIS0_LEAK_Q_N_PLD,	        	//  L13 Leak cable_0 flipflop Q
        	LEAK0_DETECT_R	                	//  G11 Leak cable_0 flipflop Q_N
		};
	//	Address 0x13, offset 0x0C
	assign	wFPGA_REG_0C =
		{
            RST_OCP_V3_1_R_N,
			RST_OCP_V3_2_R_N,
            wPRSNT_CHASSIS1_LEAK_CABLE_R_N,
			wCHASSIS1_LEAK_Q_N_PLD,
			wLEAK1_DETECT_R,
			PRSNT_CHASSIS1_LEAK_CABLE_R_N,		//  K13	PRSNT of Internal LEAK_1
        	CHASSIS1_LEAK_Q_N_PLD,	        	//  N15 Leak cable_1 flipflop Q
        	LEAK1_DETECT_R	                	//  H12 Leak cable_1 flipflop Q_N
		};
	//	Address 0x13, offset 0x0D
	assign	wFPGA_REG_0D =
		{
        	1'b0,
			1'b0,
			wPRSNT_CHASSIS2_LEAK_CABLE_R_N,
			wCHASSIS2_LEAK_Q_N_PLD,
			wLEAK2_DETECT_R,
			PRSNT_CHASSIS2_LEAK_CABLE_R_N,		//  K12	PRSNT of Internal LEAK_2
        	CHASSIS2_LEAK_Q_N_PLD,	        	//  P16 Leak cable_2 flipflop Q
        	LEAK2_DETECT_R	                	//  H13 Leak cable_2 flipflop Q_N
		};
	//	Address 0x13, offset 0x0E
	assign	wFPGA_REG_0E =
		{
            1'b0,
			1'b0,
			wPRSNT_CHASSIS3_LEAK_CABLE_R_N,
			wCHASSIS3_LEAK_Q_N_PLD,
			wLEAK3_DETECT_R,
            PRSNT_CHASSIS3_LEAK_CABLE_R_N,		//  L15	PRSNT of Internal LEAK_3
        	CHASSIS3_LEAK_Q_N_PLD,	        	//  J12 Leak cable_3 flipflop Q
			LEAK3_DETECT_R	                	//  K11 Leak cable_3 flipflop Q_N
		};
	//	Address 0x13, offset 0x0F
	assign	wFPGA_REG_0F =
		{
            wFAN_0_PRESENT_N,
			wFAN_1_PRESENT_N,
			wFAN_2_PRESENT_N,
			wFAN_3_PRESENT_N,
			FAN_0_PRESENT_N,	                //  C15	PRSNT of Internal FAN_0
        	FAN_1_PRESENT_N,	                //  B16	PRSNT of Internal FAN_1
        	FAN_2_PRESENT_N,	                //  C16	PRSNT of Internal FAN_2
        	FAN_3_PRESENT_N		                //  D15	PRSNT of Internal FAN_3
		};
	//	Address 0x13, offset 0x10
	assign	wFPGA_REG_10 =
		{
			wFAN_4_PRESENT_N,
			wFAN_5_PRESENT_N,
			wFAN_6_PRESENT_N,
			wFAN_7_PRESENT_N,
			FAN_4_PRESENT_N,	                //  F13	PRSNT of Internal FAN_4
        	FAN_5_PRESENT_N,	                //  G12	PRSNT of Internal FAN_5
        	FAN_6_PRESENT_N,	                //  F12	PRSNT of Internal FAN_6
        	FAN_7_PRESENT_N	                	//  G13	PRSNT of Internal FAN_7		
		};
	//	Address 0x13, offset 0x11
	assign	wFPGA_REG_11 =
		{
			wP12V_AUX_FAN_FAULT_PLD_N,
			wP12V_AUX_FAN_ALERT_PLD_N,
			wP12V_AUX_FAN_OC_PLD_N,
			wPWRGD_P12V_AUX_FAN_PLD,
            P12V_AUX_FAN_FAULT_PLD_N,	        	//  M15 P12V FAN VR fault
        	P12V_AUX_FAN_ALERT_PLD_N,	        //  K16 P12V FAN VR alert
        	P12V_AUX_FAN_OC_PLD_N,	            //  N16 P12V FAN VR OC
        	PWRGD_P12V_AUX_FAN_PLD	        	//  N14 P12V FAN VR PWRGD
        };
	//	Address 0x13, offset 0x12
	assign	wFPGA_REG_12 =
		{
			wNODEA_PSU_SMB_ALERT_R_L,
			wNODEB_PSU_SMB_ALERT_R_L,
			wFM_MAIN_PWREN_RMC_EN_ISO_R,
			wNODEA_NODEB_PWOK_PLD_ISO_R,
            NODEA_PSU_SMB_ALERT_R_L,	        //  F10	Node_A P12V VR alert
        	NODEB_PSU_SMB_ALERT_R_L,	        //  D11 Node_B P12V VR alert
        	FM_MAIN_PWREN_RMC_EN_ISO_R,	    	//  J13	Enable power pin of PDB control by RMC
			NODEA_NODEB_PWOK_PLD_ISO_R			//  A15 PWROK indicator from Node_A & Node_B
		};
	//	Address 0x13, offset 0x13
	assign	wFPGA_REG_13 =
		{
			wDBG_NICx_SEQ_FSM_curr[7],
			wDBG_NICx_SEQ_FSM_curr[6],
			wDBG_NICx_SEQ_FSM_curr[5],
			wDBG_NICx_SEQ_FSM_curr[4],
			wDBG_NICx_SEQ_FSM_prev[7],
			wDBG_NICx_SEQ_FSM_prev[6],
			wDBG_NICx_SEQ_FSM_prev[5],
			wDBG_NICx_SEQ_FSM_prev[4]
        };
	//	Address 0x13, offset 0x14
	assign	wFPGA_REG_14 =
		{
			wDBG_NICx_SEQ_FSM_curr[3],
			wDBG_NICx_SEQ_FSM_curr[2],
			wDBG_NICx_SEQ_FSM_curr[1],
			wDBG_NICx_SEQ_FSM_curr[0],
			wDBG_NICx_SEQ_FSM_prev[3],
			wDBG_NICx_SEQ_FSM_prev[2],
			wDBG_NICx_SEQ_FSM_prev[1],
			wDBG_NICx_SEQ_FSM_prev[0]
		};
	//	Address 0x13, offset 0x15
	assign	wFPGA_REG_15 =
		{
			wDBG_MSTR_SEQ_FSM_curr[3],
			wDBG_MSTR_SEQ_FSM_curr[2],
			wDBG_MSTR_SEQ_FSM_curr[1],
			wDBG_MSTR_SEQ_FSM_curr[0],
			wDBG_MSTR_SEQ_FSM_prev[3],
			wDBG_MSTR_SEQ_FSM_prev[2],
			wDBG_MSTR_SEQ_FSM_prev[1],
			wDBG_MSTR_SEQ_FSM_prev[0]
        };
	//	Address 0x13, offset 0x16
	assign	wFPGA_REG_16 =
		{
			wFan_PRSNT_N,
			wNIC0_PERST_N,
			wNIC1_PERST_N,
			wPWR_EN_Devices,
			wPWR_P48V_FAULT,
			wPWR_FAN_FAULT,
			wPWR_NIC0_FAULT,
			wPWR_NIC1_FAULT
        };
	//	Address 0x13, offset 0x17
	assign	wFPGA_REG_17 =
		{
			FAN_0_PRESENT_N,	                //  C15	PRSNT of Internal FAN_0
        	FAN_1_PRESENT_N,	                //  B16	PRSNT of Internal FAN_1
        	FAN_2_PRESENT_N,	                //  C16	PRSNT of Internal FAN_2
        	FAN_3_PRESENT_N,		            //  D15	PRSNT of Internal FAN_3
			FAN_4_PRESENT_N,	                //  F13	PRSNT of Internal FAN_4
        	FAN_5_PRESENT_N,	                //  G12	PRSNT of Internal FAN_5
        	FAN_6_PRESENT_N,	                //  F12	PRSNT of Internal FAN_6
        	FAN_7_PRESENT_N	                	//  G13	PRSNT of Internal FAN_7	
		};
	//	Address 0x13, offset 0x18
	assign	wFPGA_REG_18 =
		{
			PRSNT_CHASSIS0_LEAK_CABLE_R_N,		//  L14	PRSNT of Internal LEAK_0
			PRSNT_CHASSIS1_LEAK_CABLE_R_N,		//  K13	PRSNT of Internal LEAK_1
			PRSNT_CHASSIS2_LEAK_CABLE_R_N,		//  K12	PRSNT of Internal LEAK_2
			PRSNT_CHASSIS3_LEAK_CABLE_R_N,		//  L15	PRSNT of Internal LEAK_3
			HP_LVC3_OCP_V3_2_PRSNT2_PLD_N,		//  B4
			HP_LVC3_OCP_V3_1_PRSNT2_PLD_N,		//  A3
			PRSNT_OSFP0_POWER_CABLE_N,	    	//  J15 Cable PRSNT of OSFP
        	PRSNT_HDDBD_POWER_CABLE_N	    	//  K14 Cable PRSNT of HDDBD
        };
	//	Address 0x13, offset 0x19
	assign	wFPGA_REG_19 =
		{
        	8'b0
			//IOEXP_INT_curr
        };
	//	Address 0x13, offset 0x1A
	assign	wFPGA_REG_1A =
		{
			8'b0
			//IOEXP_INT_prev
		};
	//	Address 0x13, offset 0x1B
	assign	wFPGA_REG_1B =
		{
			8'b0
			//IOEXP_INT_prev1
		};
	//	Address 0x13, offset 0x1C
	assign	wFPGA_REG_1C =
		{
			8'b0
			//IOEXP_INT_prev2
        };
	//	Address 0x13, offset 0x1D
	assign	wFPGA_REG_1D =
		{
			wDBG_MSTR_SEQ_FSM_curr,
			wDBG_MSTR_SEQ_FSM_prev
		};
	//	Address 0x13, offset 0x1E
	assign	wFPGA_REG_1E =
		{
			wDBG_MSTR_SEQ_FSM_prev3,
			wDBG_MSTR_SEQ_FSM_prev2
		};
	//	Address 0x13, offset 0x1F
	assign	wFPGA_REG_1F =
		{
			wDBG_MSTR_SEQ_FSM_prev1,
			wDBG_MSTR_SEQ_FSM_prev0
		};
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

	//wire	[3:0] Mstr_prev_state_1;
	//wire	[3:0] Mstr_prev_state_0;
	//wire	[3:0] Mstr_prev_state_2;
	//wire	[3:0] Mstr_current_state;
	//
	//State_Multiple_Logger#
	//(
	//	.bits				(4)
	//)
	//Mstr_Seq_State_Log
	//(
	//	.iClk				(wOSC),
	//	.iRst_n				(wRST_N),
	//	.iClear				(1'b0),
	//
	//	.iDbgSt				(debug_FSM),
	//
	//	.prev_state_0		(Mstr_prev_state_0),
	//	.prev_state_1		(Mstr_prev_state_1),
	//	.prev_state_2		(Mstr_prev_state_2),
	//	.current_state		(Mstr_current_state)
	//);

endmodule