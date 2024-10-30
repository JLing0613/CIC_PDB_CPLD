`timescale 1ns/100ps 
module EVENT_SAVE_UFM_Top
	(   
	///// I2C BUSs /////   
	input  wire    wRST_N,
	inout  wire    SMB_PROG_CPLD_3V3AUX_SCL_R,   
	inout  wire    SMB_PROG_CPLD_3V3AUX_SDA_R, 
	inout  wire    SMB_SCM_SENSOR_3V3AUX_SCL_R,
	inout  wire    SMB_SCM_SENSOR_3V3AUX_SDA_R,
	//erase ufm
	input  wire   enter_earse_i,
	
	//flag
	output wire    write2ufm_o,
	output wire    buf_ready_o,
	output wire    ufm_busy_o	 
	);
	//	Two EEPROM declarations //
	parameter bmc_DEV_ID = 7'h50;
	//	Internal declarations //
	wire	    wOSC;
	wire        OSC_Reset;
	wire	     v_RST_N;
	assign      v_RST_N = wRST_N & OSC_Reset;
	//timer
	wire Time1us;  
	wire Time10us; 
	wire Time1ms;  
	wire Time10ms; 
	wire Time100ms;
	wire Time1s;   
	wire clock1ms; 
	wire clcok1us; 
	//BIC I2C PIO assign
	wire sda_oe_bmc;
	wire sda_in_bmc;
	wire scl_in_bmc;	
	wire bmc_sda_db;
	wire bmc_scl_db;	
    wire bmc_sda_in;
    wire bmc_scl_in;
    wire bmc_sda_oe;
    wire bmc_scl_oe;
	assign bmc_sda_in = SMB_SCM_SENSOR_3V3AUX_SDA_R;
	assign bmc_scl_in = SMB_SCM_SENSOR_3V3AUX_SCL_R;
	assign SMB_SCM_SENSOR_3V3AUX_SDA_R = bmc_sda_oe ? 1'bz : 1'b0;
	assign SMB_SCM_SENSOR_3V3AUX_SCL_R = bmc_scl_oe ? 1'bz : 1'b0;

	//debounce
	wire msda_low_en_i;
	wire mscl_low_en_i;	
	assign msda_low_en_i = !bmc_sda_oe;
	assign mscl_low_en_i = !bmc_scl_oe;
	//ufm_wb_top
	parameter GPI_BIT = 256;
	wire [2:0]   cmd;
	wire [10:0]  ufm_page;
	wire         GO;
	wire		 BUSY;
	wire		 ERR;			
	/***************** DPRAM port B signals *************/
	wire         mem_we;
	wire         mem_ce;
	wire [3:0]   mem_addr;
	wire [7:0]   mem_wr_data;
	wire [7:0]   mem_rd_data;
	wire [GPI_BIT-1:0] gpi;
	wire [GPI_BIT-1:0] rnd;
	
	assign 	  gpi = rnd;
	
	randomnumbergenerator
	#(
	.BIT(GPI_BIT)
	)
b2v_inst1(
		.clk(wOSC),
		.rstn(v_RST_N),
		.rnd(rnd));
	
	
	
	
	//	OSC // 
	OSCH #("24.18") OSCH_inst ( .OSC(wOSC),.SEDSTDBY(), .STDBY(1'b0));
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

	 //reset Module //
	Generator_reset mGenerator_reset
	( 
		.iClk   (wOSC),
		.oReset (OSC_Reset)
	);
	
//////////////////////////////////////////////////////////////////////////////////
//TWO EEPROM with UFM Map//
//////////////////////////////////////////////////////////////////////////////////
	//MASTER DB	
	clk_debounce_p3 i2c_bmc_db
		(
		.sda_in                      (bmc_sda_in              ),
		.scl_in                      (bmc_scl_in              ),
		.sda_low_en_i                (msda_low_en_i    	  ),
		.scl_low_en_i                (mscl_low_en_i        ),
		.sda_out                     (bmc_sda_db              ),
		.scl_out                     (bmc_scl_db              ),
		.clk_i                       (wOSC                    ),
		.resetn_i                    (v_RST_N                  )
		);

	TimerMang inst_Mag
		(
		.iClk                   (wOSC                 ),
		.resetn_i               (v_RST_N               ),
		.Trigger1us             (Time1us              ),
		.Trigger10us            (Time10us             ),
		.Trigger1ms             (Time1ms              ),
		.Trigger10ms            (Time10ms             ),
		.Trigger100ms           (Time100ms            ),
		.Trigger1s              (Time1s               ),
		.clk1ms                 (clock1ms             ),
		.clk1us                 (clcok1us             ));
	
	ufm_rw256_top
		inst_URW
		(
		.bmc_DEV_ID			     (bmc_DEV_ID           ),
		//.Trigger10ms            (Time10ms             ),	
		//ufm flash erase
		.En_UFM_SAVE_i          (En_UFM_SAVE_i        ),
		.enter_earse_i          (enter_earse_i        ),
		//BMC
		.bmc_sda_oe			    (bmc_sda_oe           ),
		.bmc_scl_oe			    (bmc_scl_oe           ),
		.bmc_sda_in			    (bmc_sda_db           ),
		.bmc_scl_in			    (bmc_scl_db           ),
		//EVNT
		.gpi                    (gpi                  ),
		//flag
		.write2ufm_o            (write2ufm_o          ),
		.buf_ready_o            (buf_ready_o          ),
		//.ufm_busy_o             (ufm_busy_o           ),
		//ufm_command
		.cmd					(cmd			      ),
		.ufm_page				(ufm_page		      ),
		.GO						(GO				      ),
		.BUSY					(BUSY			      ),
		.ERR					(ERR			      ),
		.mem_we					(mem_we			      ),
		.mem_ce					(mem_ce			      ),
		.mem_addr				(mem_addr		      ),
		.mem_wr_data			(mem_wr_data	      ),
		.mem_rd_data			(mem_rd_data	      ),
		//System
		.clk_i                  (wOSC                 ),
		.resetn_i               (v_RST_N              )
		);
		
		wire [2:0]	i2c_cs = 3'b000; //Config ation feature_row sletect	
		ufm_wb_top inst_EFB
		(
		.clk_i						(wOSC					),
		.ext_rstn					(v_RST_N				),
		.cmd						(cmd					),
		.ufm_page					(ufm_page				),
		.GO							(GO						),
		.BUSY						(BUSY					),
		.ERR						(ERR					),
		.mem_clk					(wOSC					),
		.mem_we						(mem_we					),
		.mem_ce						(mem_ce					),
		.mem_addr					(mem_addr				),
		.mem_wr_data				(mem_wr_data			),
		.mem_rd_data				(mem_rd_data			),
		//FWUpdate
		.i2c1_scl                   (SMB_PROG_CPLD_3V3AUX_SCL_R),
		.i2c1_sda                   (SMB_PROG_CPLD_3V3AUX_SDA_R),
		.i2c1_irqo                  (                          ),
		//.DIP						(DIP					),
		//.DIP						(1'b0					),
		.i2c_cs						(i2c_cs					)//,
		//.update_done				(update_done			),
		//.update_pass				(update_pass			)
		);	
		
endmodule