//
// File            : ufm_buf_top.v
// Author          : <WKT_HP>
// Date            : 2021/06/03
// Version         : <>.<>
// Abstract        : <>
// Company        : Taiwan Weikeng  Industrial CO., LTD
// Eamil           : hpli@weikeng.com.tw
// Tel : 2659-0202 EXT:349
// Fax: (886-2)2658-8313
//Mop: 0963-315-015
// Modification History:
// Date        By       Version    Change Description
//
// ===========================================================
// 24/08/2    HP      0.0        building inital code 
// 24/08/23   HP                 adding  gpi_update
// 24/11/14   HP                 adding  EFD_ID disable UFM trigger
// ===========================================================
`timescale  1 ns /  100 ps
module ufm_rw_top
	( 
	input  wire [6:0]   bmc_DEV_ID,
	//Triggr Timer
	//input  wire         Trigger10ms,
	input  wire         En_UFM_SAVE_i,
	//erase ufm flash
	input  wire         enter_earse_i,
	//BMC
	output wire			bmc_sda_oe,
	output wire			bmc_scl_oe,
	input  wire			bmc_sda_in,
	input  wire			bmc_scl_in,
	input  wire			EFB_scl_i,
	input  wire			EFB_sda_i,
	//input
	input  wire [511:0] gpi,
	//output
	//output wire [7:0]   gpo00_o,	
	//flag
	output wire			write2ufm_o,
	output wire         buf_ready_o,
	//output wire			buf00_ready_o,
	output wire         save_done_o,
	//ufm_wb_top
	output reg  [2:0]   cmd,
	output reg  [10:0]  ufm_page,
	output reg          GO,
	input  wire			BUSY,
	input  wire			ERR,			
	/***************** DPRAM port B signals *************/
	output reg          mem_we,
	output reg          mem_ce,
	output reg  [3:0]   mem_addr,
	output reg  [7:0]   mem_wr_data,
	input  wire	[7:0]   mem_rd_data,
	//system
	input  wire			clk_i,
	input  wire			resetn_i

	)/* synthesis FILE="../Source/EVENT_SAVE_UFM/EventSave_UFM_impl1.ngo" */;

endmodule