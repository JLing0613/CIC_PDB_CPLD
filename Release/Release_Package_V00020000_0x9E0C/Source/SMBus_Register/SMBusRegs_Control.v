// -------------------------------------------------------------------
// Copyright (c) 2022 by WEIKENG INDUSTRIAL CO., LTD. 
// -------------------------------------------------------------------
//
// 11F, 308, Sec.1, NeiHu Rd., Taipei 11493, Taiwan
// TEL : +886-2-2658-0959
// WEB : http://www.weikeng.com.tw
//
// -------------------------------------------------------------------
//
// File :
//     SMBusRegs.v
// Description :
//     SMBusRegs Module
//
// -------------------------------------------------------------------
// Code Revision History:
// -------------------------------------------------------------------
// Version | Author         | Modify Date | Changes Made
// V0.0    | Vincent Lee    | 2022/01/11  | Initial Version
// -------------------------------------------------------------------
// CPLD/FPGA Vender : Lattice
// Part Number      : LCMXO3LF-4300C-5BG256C
// -------------------------------------------------------------------

`timescale 1 ns/100 ps

module SMBusRegs
#(
    parameter       i2c_slave_addr = 7'h00
)
(
    input  wire         CLK_IN,
    input  wire         RESET_N,
    input  wire         scl_in,
    input  wire         sda_in,
    output wire         sda_oe,
    
    input  wire [7:0]   iFPGA_REG_00,
    input  wire [7:0]   iFPGA_REG_01,
    input  wire [7:0]   iFPGA_REG_02,
    input  wire [7:0]   iFPGA_REG_03,
    input  wire [7:0]   iFPGA_REG_04,
    input  wire [7:0]   iFPGA_REG_05,
    input  wire [7:0]   iFPGA_REG_06,
    input  wire [7:0]   iFPGA_REG_07,
    input  wire [7:0]   iFPGA_REG_08,
    input  wire [7:0]   iFPGA_REG_09,
    input  wire [7:0]   iFPGA_REG_0A,
    input  wire [7:0]   iFPGA_REG_0B,
    input  wire [7:0]   iFPGA_REG_0C,
    input  wire [7:0]   iFPGA_REG_0D,
    input  wire [7:0]   iFPGA_REG_0E,
    input  wire [7:0]   iFPGA_REG_0F,
    input  wire [7:0]   iFPGA_REG_10,
    input  wire [7:0]   iFPGA_REG_11,
    input  wire [7:0]   iFPGA_REG_12,
    input  wire [7:0]   iFPGA_REG_13,
    input  wire [7:0]   iFPGA_REG_14,
    input  wire [7:0]   iFPGA_REG_15,
    input  wire [7:0]   iFPGA_REG_16,
    input  wire [7:0]   iFPGA_REG_17,
    input  wire [7:0]   iFPGA_REG_18,
    input  wire [7:0]   iFPGA_REG_19,
    input  wire [7:0]   iFPGA_REG_1A,
    input  wire [7:0]   iFPGA_REG_1B,
    input  wire [7:0]   iFPGA_REG_1C,
    input  wire [7:0]   iFPGA_REG_1D,
    input  wire [7:0]   iFPGA_REG_1E,
    input  wire [7:0]   iFPGA_REG_1F,
    input  wire [7:0]   iFPGA_REG_20,
    input  wire [7:0]   iFPGA_REG_21,
    input  wire [7:0]   iFPGA_REG_22,
    input  wire [7:0]   iFPGA_REG_23,
    input  wire [7:0]   iFPGA_REG_24,
    input  wire [7:0]   iFPGA_REG_25,
    input  wire [7:0]   iFPGA_REG_26,
    input  wire [7:0]   iFPGA_REG_27,
    input  wire [7:0]   iFPGA_REG_28,
    input  wire [7:0]   iFPGA_REG_29,
    input  wire [7:0]   iFPGA_REG_2A,
    input  wire [7:0]   iFPGA_REG_2B,
    input  wire [7:0]   iFPGA_REG_2C,
    input  wire [7:0]   iFPGA_REG_2D,
    input  wire [7:0]   iFPGA_REG_2E,
    input  wire [7:0]   iFPGA_REG_2F,
    input  wire [7:0]   iFPGA_REG_30,
    input  wire [7:0]   iFPGA_REG_31,
    input  wire [7:0]   iFPGA_REG_32,
    input  wire [7:0]   iFPGA_REG_33,
    input  wire [7:0]   iFPGA_REG_34,
    input  wire [7:0]   iFPGA_REG_35,
    input  wire [7:0]   iFPGA_REG_36,
    input  wire [7:0]   iFPGA_REG_37,
    input  wire [7:0]   iFPGA_REG_38,
    input  wire [7:0]   iFPGA_REG_39,
    input  wire [7:0]   iFPGA_REG_3A,
    input  wire [7:0]   iFPGA_REG_3B,
    input  wire [7:0]   iFPGA_REG_3C,
    input  wire [7:0]   iFPGA_REG_3D,
    input  wire [7:0]   iFPGA_REG_3E,
    input  wire [7:0]   iFPGA_REG_3F
);

wire    clk;
wire    nrst;

wire	[7:0] wi2c_offset; 
wire	[7:0] wi2c_dat_o; 
wire	[7:0] wi2c_dat_i; 
wire	wi2c_wren;  
wire	wi2c_rden;

SMBusRegs_Slave mSMBus_Slave
(
	.CLK_IN     	(CLK_IN),
	.RESET_N    	(RESET_N),
	.I2C_ADR_I  	(i2c_slave_addr),
	.scl_in         (scl_in),
    .sda_in         (sda_in),
    .sda_oe         (sda_oe),

	.I2C_CMD_O  	(wi2c_offset),
	.I2C_DAT_O  	(wi2c_dat_o),
	.I2C_DAT_I  	(wi2c_dat_i),
	.I2C_WREN   	(wi2c_wren),
	.I2C_RDEN   	(wi2c_rden)
);	

reg     [7:0] FPGA_REG_00;
reg     [7:0] FPGA_REG_01;
reg     [7:0] FPGA_REG_02;
reg     [7:0] FPGA_REG_03;
reg     [7:0] FPGA_REG_04;
reg     [7:0] FPGA_REG_05;
reg     [7:0] FPGA_REG_06;
reg     [7:0] FPGA_REG_07;
reg     [7:0] FPGA_REG_08;
reg     [7:0] FPGA_REG_09;
reg     [7:0] FPGA_REG_0A;
reg     [7:0] FPGA_REG_0B;
reg     [7:0] FPGA_REG_0C;
reg     [7:0] FPGA_REG_0D;
reg     [7:0] FPGA_REG_0E;
reg     [7:0] FPGA_REG_0F;
reg     [7:0] FPGA_REG_10;
reg     [7:0] FPGA_REG_11;
reg     [7:0] FPGA_REG_12;
reg     [7:0] FPGA_REG_13;
reg     [7:0] FPGA_REG_14;
reg     [7:0] FPGA_REG_15;
reg     [7:0] FPGA_REG_16;
reg     [7:0] FPGA_REG_17;
reg     [7:0] FPGA_REG_18;
reg     [7:0] FPGA_REG_19;
reg     [7:0] FPGA_REG_1A;
reg     [7:0] FPGA_REG_1B;
reg     [7:0] FPGA_REG_1C;
reg     [7:0] FPGA_REG_1D;
reg     [7:0] FPGA_REG_1E;
reg     [7:0] FPGA_REG_1F;
reg     [7:0] FPGA_REG_20;
reg     [7:0] FPGA_REG_21;
reg     [7:0] FPGA_REG_22;
reg     [7:0] FPGA_REG_23;
reg     [7:0] FPGA_REG_24;
reg     [7:0] FPGA_REG_25;
reg     [7:0] FPGA_REG_26;
reg     [7:0] FPGA_REG_27;
reg     [7:0] FPGA_REG_28;
reg     [7:0] FPGA_REG_29;
reg     [7:0] FPGA_REG_2A;
reg     [7:0] FPGA_REG_2B;
reg     [7:0] FPGA_REG_2C;
reg     [7:0] FPGA_REG_2D;
reg     [7:0] FPGA_REG_2E;
reg     [7:0] FPGA_REG_2F;
reg     [7:0] FPGA_REG_30;
reg     [7:0] FPGA_REG_31;
reg     [7:0] FPGA_REG_32;
reg     [7:0] FPGA_REG_33;
reg     [7:0] FPGA_REG_34;
reg     [7:0] FPGA_REG_35;
reg     [7:0] FPGA_REG_36;
reg     [7:0] FPGA_REG_37;
reg     [7:0] FPGA_REG_38;
reg     [7:0] FPGA_REG_39;
reg     [7:0] FPGA_REG_3A;
reg     [7:0] FPGA_REG_3B;
reg     [7:0] FPGA_REG_3C;
reg     [7:0] FPGA_REG_3D;
reg     [7:0] FPGA_REG_3E;
reg     [7:0] FPGA_REG_3F;

wire    [7:0] wFPGA_REG_00;
wire    [7:0] wFPGA_REG_01;
wire    [7:0] wFPGA_REG_02;
wire    [7:0] wFPGA_REG_03;
wire    [7:0] wFPGA_REG_04;
wire    [7:0] wFPGA_REG_05;
wire    [7:0] wFPGA_REG_06;
wire    [7:0] wFPGA_REG_07;
wire    [7:0] wFPGA_REG_08;
wire    [7:0] wFPGA_REG_09;
wire    [7:0] wFPGA_REG_0A;
wire    [7:0] wFPGA_REG_0B;
wire    [7:0] wFPGA_REG_0C;
wire    [7:0] wFPGA_REG_0D;
wire    [7:0] wFPGA_REG_0E;
wire    [7:0] wFPGA_REG_0F;
wire    [7:0] wFPGA_REG_10;
wire    [7:0] wFPGA_REG_11;
wire    [7:0] wFPGA_REG_12;
wire    [7:0] wFPGA_REG_13;
wire    [7:0] wFPGA_REG_14;
wire    [7:0] wFPGA_REG_15;
wire    [7:0] wFPGA_REG_16;
wire    [7:0] wFPGA_REG_17;
wire    [7:0] wFPGA_REG_18;
wire    [7:0] wFPGA_REG_19;
wire    [7:0] wFPGA_REG_1A;
wire    [7:0] wFPGA_REG_1B;
wire    [7:0] wFPGA_REG_1C;
wire    [7:0] wFPGA_REG_1D;
wire    [7:0] wFPGA_REG_1E;
wire    [7:0] wFPGA_REG_1F;
wire    [7:0] wFPGA_REG_20;
wire    [7:0] wFPGA_REG_21;
wire    [7:0] wFPGA_REG_22;
wire    [7:0] wFPGA_REG_23;
wire    [7:0] wFPGA_REG_24;
wire    [7:0] wFPGA_REG_25;
wire    [7:0] wFPGA_REG_26;
wire    [7:0] wFPGA_REG_27;
wire    [7:0] wFPGA_REG_28;
wire    [7:0] wFPGA_REG_29;
wire    [7:0] wFPGA_REG_2A;
wire    [7:0] wFPGA_REG_2B;
wire    [7:0] wFPGA_REG_2C;
wire    [7:0] wFPGA_REG_2D;
wire    [7:0] wFPGA_REG_2E;
wire    [7:0] wFPGA_REG_2F;
wire    [7:0] wFPGA_REG_30;
wire    [7:0] wFPGA_REG_31;
wire    [7:0] wFPGA_REG_32;
wire    [7:0] wFPGA_REG_33;
wire    [7:0] wFPGA_REG_34;
wire    [7:0] wFPGA_REG_35;
wire    [7:0] wFPGA_REG_36;
wire    [7:0] wFPGA_REG_37;
wire    [7:0] wFPGA_REG_38;
wire    [7:0] wFPGA_REG_39;
wire    [7:0] wFPGA_REG_3A;
wire    [7:0] wFPGA_REG_3B;
wire    [7:0] wFPGA_REG_3C;
wire    [7:0] wFPGA_REG_3D;
wire    [7:0] wFPGA_REG_3E;
wire    [7:0] wFPGA_REG_3F;

assign clk  = CLK_IN;
assign nrst = RESET_N;
  
// NOTES :
// R   - Read Only
// W   - Write Only
// R/W - Read & Write
// W1C - Write one to clear

//////////////////////////////////////////////////////////////////////////////////
//CPLD Register 
//////////////////////////////////////////////////////////////////////////////////
assign wFPGA_REG_00 = iFPGA_REG_00;
assign wFPGA_REG_01 = iFPGA_REG_01;
assign wFPGA_REG_02 = iFPGA_REG_02;
assign wFPGA_REG_03 = iFPGA_REG_03;
assign wFPGA_REG_04 = iFPGA_REG_04;
assign wFPGA_REG_05 = iFPGA_REG_05;
assign wFPGA_REG_06 = iFPGA_REG_06;
assign wFPGA_REG_07 = iFPGA_REG_07; 
assign wFPGA_REG_08 = iFPGA_REG_08;
assign wFPGA_REG_09 = iFPGA_REG_09;
assign wFPGA_REG_0A = iFPGA_REG_0A;
assign wFPGA_REG_0B = iFPGA_REG_0B;
assign wFPGA_REG_0C = iFPGA_REG_0C;
assign wFPGA_REG_0D = iFPGA_REG_0D;
assign wFPGA_REG_0E = iFPGA_REG_0E;
assign wFPGA_REG_0F = iFPGA_REG_0F; 
assign wFPGA_REG_10 = iFPGA_REG_10;
assign wFPGA_REG_11 = iFPGA_REG_11;
assign wFPGA_REG_12 = iFPGA_REG_12;
assign wFPGA_REG_13 = iFPGA_REG_13;
assign wFPGA_REG_14 = iFPGA_REG_14;
assign wFPGA_REG_15 = iFPGA_REG_15;
assign wFPGA_REG_16 = iFPGA_REG_16;
assign wFPGA_REG_17 = iFPGA_REG_17; 
assign wFPGA_REG_18 = iFPGA_REG_18;
assign wFPGA_REG_19 = iFPGA_REG_19;
assign wFPGA_REG_1A = iFPGA_REG_1A;
assign wFPGA_REG_1B = iFPGA_REG_1B;
assign wFPGA_REG_1C = iFPGA_REG_1C;
assign wFPGA_REG_1D = iFPGA_REG_1D;
assign wFPGA_REG_1E = iFPGA_REG_1E;
assign wFPGA_REG_1F = iFPGA_REG_1F; 
assign wFPGA_REG_20 = iFPGA_REG_20;
assign wFPGA_REG_21 = iFPGA_REG_21;
assign wFPGA_REG_22 = iFPGA_REG_22;
assign wFPGA_REG_23 = iFPGA_REG_23;
assign wFPGA_REG_24 = iFPGA_REG_24;
assign wFPGA_REG_25 = iFPGA_REG_25;
assign wFPGA_REG_26 = iFPGA_REG_26;
assign wFPGA_REG_27 = iFPGA_REG_27; 
assign wFPGA_REG_28 = iFPGA_REG_28;
assign wFPGA_REG_29 = iFPGA_REG_29;
assign wFPGA_REG_2A = iFPGA_REG_2A;
assign wFPGA_REG_2B = iFPGA_REG_2B;
assign wFPGA_REG_2C = iFPGA_REG_2C;
assign wFPGA_REG_2D = iFPGA_REG_2D;
assign wFPGA_REG_2E = iFPGA_REG_2E;
assign wFPGA_REG_2F = iFPGA_REG_2F; 
assign wFPGA_REG_30 = iFPGA_REG_30;
assign wFPGA_REG_31 = iFPGA_REG_31;
assign wFPGA_REG_32 = iFPGA_REG_32;
assign wFPGA_REG_33 = iFPGA_REG_33;
assign wFPGA_REG_34 = iFPGA_REG_34;
assign wFPGA_REG_35 = iFPGA_REG_35;
assign wFPGA_REG_36 = iFPGA_REG_36;
assign wFPGA_REG_37 = iFPGA_REG_37; 
assign wFPGA_REG_38 = iFPGA_REG_38;
assign wFPGA_REG_39 = iFPGA_REG_39;
assign wFPGA_REG_3A = iFPGA_REG_3A;
assign wFPGA_REG_3B = iFPGA_REG_3B;
assign wFPGA_REG_3C = iFPGA_REG_3C;
assign wFPGA_REG_3D = iFPGA_REG_3D;
assign wFPGA_REG_3E = iFPGA_REG_3E;
assign wFPGA_REG_3F = iFPGA_REG_3F; 

// Address 0x07 , BMC Boot Status(R/W)
// assign FPGA_REG_08_d[7]    = PWR_SYS_ON;
// assign FPGA_REG_08_d[6:1]  = 6'h0;
// assign FPGA_REG_08_d[0]    = wi2c_rden && (wi2c_offset == 8'h07) ? wi2c_dat_o[0]   : FPGA_REG_08[0];
// 
// assign BMC_BOOT_COMPLETE = FPGA_REG_08[0];

// Address 0x12 , CPU Reset Status Register(R)
// assign FPGA_REG_0_d[18] = {3'h0,CPLD_CPU0_RST,3'h0,CPLD_CPU1_RST};
// PS : PCIe reset no connect to CPLD(bit7,6,5,2,1,0) ?? //

// DFF //
always @(posedge clk or negedge nrst) begin
    if (!nrst) begin
        FPGA_REG_00           <= 8'h00;
        FPGA_REG_01           <= 8'h00;
        FPGA_REG_02           <= 8'h00;
        FPGA_REG_03           <= 8'h00;
        FPGA_REG_04           <= 8'h00;
        FPGA_REG_05           <= 8'h00;
        FPGA_REG_06           <= 8'h00;
        FPGA_REG_07           <= 8'h00;
        FPGA_REG_08           <= 8'h00;
        FPGA_REG_09           <= 8'h00;
        FPGA_REG_0A           <= 8'h00;
        FPGA_REG_0B           <= 8'h00;
        FPGA_REG_0C           <= 8'h00;
        FPGA_REG_0D           <= 8'h00;
        FPGA_REG_0E           <= 8'h00;
        FPGA_REG_0F           <= 8'h00;
        FPGA_REG_10           <= 8'h00;
        FPGA_REG_11           <= 8'h00;
        FPGA_REG_12           <= 8'h00;
        FPGA_REG_13           <= 8'h00;
        FPGA_REG_14           <= 8'h00;
        FPGA_REG_15           <= 8'h00;
        FPGA_REG_16           <= 8'h00;
        FPGA_REG_17           <= 8'h00;
        FPGA_REG_18           <= 8'h00;
        FPGA_REG_19           <= 8'h00;
        FPGA_REG_1A           <= 8'h00;
        FPGA_REG_1B           <= 8'h00;
        FPGA_REG_1C           <= 8'h00;
        FPGA_REG_1D           <= 8'h00;
        FPGA_REG_1E           <= 8'h00;
        FPGA_REG_1F           <= 8'h00;
        FPGA_REG_20           <= 8'h00;
        FPGA_REG_21           <= 8'h00;
        FPGA_REG_22           <= 8'h00;
        FPGA_REG_23           <= 8'h00;
        FPGA_REG_24           <= 8'h00;
        FPGA_REG_25           <= 8'h00;
        FPGA_REG_26           <= 8'h00;
        FPGA_REG_27           <= 8'h00;
        FPGA_REG_28           <= 8'h00;
        FPGA_REG_29           <= 8'h00;
        FPGA_REG_2A           <= 8'h00;
        FPGA_REG_2B           <= 8'h00;
        FPGA_REG_2C           <= 8'h00;
        FPGA_REG_2D           <= 8'h00;
        FPGA_REG_2E           <= 8'h00;
        FPGA_REG_2F           <= 8'h00;
        FPGA_REG_30           <= 8'h00;
        FPGA_REG_31           <= 8'h00;
        FPGA_REG_32           <= 8'h00;
        FPGA_REG_33           <= 8'h00;
        FPGA_REG_34           <= 8'h00;
        FPGA_REG_35           <= 8'h00;
        FPGA_REG_36           <= 8'h00;
        FPGA_REG_37           <= 8'h00;
        FPGA_REG_38           <= 8'h00;
        FPGA_REG_39           <= 8'h00;
        FPGA_REG_3A           <= 8'h00;
        FPGA_REG_3B           <= 8'h00;
        FPGA_REG_3C           <= 8'h00;
        FPGA_REG_3D           <= 8'h00;
        FPGA_REG_3E           <= 8'h00;
        FPGA_REG_3F           <= 8'h00;
    end
    else begin
        FPGA_REG_00           <= wFPGA_REG_00;
        FPGA_REG_01           <= wFPGA_REG_01;
        FPGA_REG_02           <= wFPGA_REG_02;
        FPGA_REG_03           <= wFPGA_REG_03;
        FPGA_REG_04           <= wFPGA_REG_04;
        FPGA_REG_05           <= wFPGA_REG_05;
        FPGA_REG_06           <= wFPGA_REG_06;
        FPGA_REG_07           <= wFPGA_REG_07;
        FPGA_REG_08           <= wFPGA_REG_08;
        FPGA_REG_09           <= wFPGA_REG_09;
        FPGA_REG_0A           <= wFPGA_REG_0A;
        FPGA_REG_0B           <= wFPGA_REG_0B;
        FPGA_REG_0C           <= wFPGA_REG_0C;
        FPGA_REG_0D           <= wFPGA_REG_0D;
        FPGA_REG_0E           <= wFPGA_REG_0E;
        FPGA_REG_0F           <= wFPGA_REG_0F;
        FPGA_REG_10           <= wFPGA_REG_10;
        FPGA_REG_11           <= wFPGA_REG_11;
        FPGA_REG_12           <= wFPGA_REG_12;
        FPGA_REG_13           <= wFPGA_REG_13;
        FPGA_REG_14           <= wFPGA_REG_14;
        FPGA_REG_15           <= wFPGA_REG_15;
        FPGA_REG_16           <= wFPGA_REG_16;
        FPGA_REG_17           <= wFPGA_REG_17;
        FPGA_REG_18           <= wFPGA_REG_18;
        FPGA_REG_19           <= wFPGA_REG_19;
        FPGA_REG_1A           <= wFPGA_REG_1A;
        FPGA_REG_1B           <= wFPGA_REG_1B;
        FPGA_REG_1C           <= wFPGA_REG_1C;
        FPGA_REG_1D           <= wFPGA_REG_1D;
        FPGA_REG_1E           <= wFPGA_REG_1E;
        FPGA_REG_1F           <= wFPGA_REG_1F; 
        FPGA_REG_20           <= wFPGA_REG_20;
        FPGA_REG_21           <= wFPGA_REG_21;
        FPGA_REG_22           <= wFPGA_REG_22;
        FPGA_REG_23           <= wFPGA_REG_23;
        FPGA_REG_24           <= wFPGA_REG_24;
        FPGA_REG_25           <= wFPGA_REG_25;
        FPGA_REG_26           <= wFPGA_REG_26;
        FPGA_REG_27           <= wFPGA_REG_27;
        FPGA_REG_28           <= wFPGA_REG_28;
        FPGA_REG_29           <= wFPGA_REG_29;
        FPGA_REG_2A           <= wFPGA_REG_2A;
        FPGA_REG_2B           <= wFPGA_REG_2B;
        FPGA_REG_2C           <= wFPGA_REG_2C;
        FPGA_REG_2D           <= wFPGA_REG_2D;
        FPGA_REG_2E           <= wFPGA_REG_2E;
        FPGA_REG_2F           <= wFPGA_REG_2F;
        FPGA_REG_30           <= wFPGA_REG_30;
        FPGA_REG_31           <= wFPGA_REG_31;
        FPGA_REG_32           <= wFPGA_REG_32;
        FPGA_REG_33           <= wFPGA_REG_33;
        FPGA_REG_34           <= wFPGA_REG_34;
        FPGA_REG_35           <= wFPGA_REG_35;
        FPGA_REG_36           <= wFPGA_REG_36;
        FPGA_REG_37           <= wFPGA_REG_37;
        FPGA_REG_38           <= wFPGA_REG_38;
        FPGA_REG_39           <= wFPGA_REG_39;
        FPGA_REG_3A           <= wFPGA_REG_3A;
        FPGA_REG_3B           <= wFPGA_REG_3B;
        FPGA_REG_3C           <= wFPGA_REG_3C;
        FPGA_REG_3D           <= wFPGA_REG_3D;
        FPGA_REG_3E           <= wFPGA_REG_3E;
        FPGA_REG_3F           <= wFPGA_REG_3F; 
    end
end

assign wi2c_dat_i = (wi2c_offset == 8'h00) ? FPGA_REG_00 :
                    (wi2c_offset == 8'h01) ? FPGA_REG_01 :
                    (wi2c_offset == 8'h02) ? FPGA_REG_02 :
                    (wi2c_offset == 8'h03) ? FPGA_REG_03 :
                    (wi2c_offset == 8'h04) ? FPGA_REG_04 :
                    (wi2c_offset == 8'h05) ? FPGA_REG_05 :
                    (wi2c_offset == 8'h06) ? FPGA_REG_06 :
                    (wi2c_offset == 8'h07) ? FPGA_REG_07 :
                    (wi2c_offset == 8'h08) ? FPGA_REG_08 :
                    (wi2c_offset == 8'h09) ? FPGA_REG_09 :
                    (wi2c_offset == 8'h0A) ? FPGA_REG_0A :
                    (wi2c_offset == 8'h0B) ? FPGA_REG_0B :
                    (wi2c_offset == 8'h0C) ? FPGA_REG_0C :
                    (wi2c_offset == 8'h0D) ? FPGA_REG_0D :
                    (wi2c_offset == 8'h0E) ? FPGA_REG_0E :
                    (wi2c_offset == 8'h0F) ? FPGA_REG_0F :
                    (wi2c_offset == 8'h10) ? FPGA_REG_10 :
                    (wi2c_offset == 8'h11) ? FPGA_REG_11 :
                    (wi2c_offset == 8'h12) ? FPGA_REG_12 :
                    (wi2c_offset == 8'h13) ? FPGA_REG_13 :
                    (wi2c_offset == 8'h14) ? FPGA_REG_14 :
                    (wi2c_offset == 8'h15) ? FPGA_REG_15 :
                    (wi2c_offset == 8'h16) ? FPGA_REG_16 :
                    (wi2c_offset == 8'h17) ? FPGA_REG_17 :
                    (wi2c_offset == 8'h18) ? FPGA_REG_18 :
                    (wi2c_offset == 8'h19) ? FPGA_REG_19 :
                    (wi2c_offset == 8'h1A) ? FPGA_REG_1A :
                    (wi2c_offset == 8'h1B) ? FPGA_REG_1B :
                    (wi2c_offset == 8'h1C) ? FPGA_REG_1C :
                    (wi2c_offset == 8'h1D) ? FPGA_REG_1D :
                    (wi2c_offset == 8'h1E) ? FPGA_REG_1E :
                    (wi2c_offset == 8'h1F) ? FPGA_REG_1F : 
                    (wi2c_offset == 8'h20) ? FPGA_REG_20 :
                    (wi2c_offset == 8'h21) ? FPGA_REG_21 :
                    (wi2c_offset == 8'h22) ? FPGA_REG_22 :
                    (wi2c_offset == 8'h23) ? FPGA_REG_23 :
                    (wi2c_offset == 8'h24) ? FPGA_REG_24 :
                    (wi2c_offset == 8'h25) ? FPGA_REG_25 :
                    (wi2c_offset == 8'h26) ? FPGA_REG_26 :
                    (wi2c_offset == 8'h27) ? FPGA_REG_27 :
                    (wi2c_offset == 8'h28) ? FPGA_REG_28 :
                    (wi2c_offset == 8'h29) ? FPGA_REG_29 :
                    (wi2c_offset == 8'h2A) ? FPGA_REG_2A :
                    (wi2c_offset == 8'h2B) ? FPGA_REG_2B :
                    (wi2c_offset == 8'h2C) ? FPGA_REG_2C :
                    (wi2c_offset == 8'h2D) ? FPGA_REG_2D :
                    (wi2c_offset == 8'h2E) ? FPGA_REG_2E :
                    (wi2c_offset == 8'h2F) ? FPGA_REG_2F :
                    (wi2c_offset == 8'h30) ? FPGA_REG_30 :
                    (wi2c_offset == 8'h31) ? FPGA_REG_31 :
                    (wi2c_offset == 8'h32) ? FPGA_REG_32 :
                    (wi2c_offset == 8'h33) ? FPGA_REG_33 :
                    (wi2c_offset == 8'h34) ? FPGA_REG_34 :
                    (wi2c_offset == 8'h35) ? FPGA_REG_35 :
                    (wi2c_offset == 8'h36) ? FPGA_REG_36 :
                    (wi2c_offset == 8'h37) ? FPGA_REG_37 :
                    (wi2c_offset == 8'h38) ? FPGA_REG_38 :
                    (wi2c_offset == 8'h39) ? FPGA_REG_39 :
                    (wi2c_offset == 8'h3A) ? FPGA_REG_3A :
                    (wi2c_offset == 8'h3B) ? FPGA_REG_3B :
                    (wi2c_offset == 8'h3C) ? FPGA_REG_3C :
                    (wi2c_offset == 8'h3D) ? FPGA_REG_3D :
                    (wi2c_offset == 8'h3E) ? FPGA_REG_3E :
                    (wi2c_offset == 8'h3F) ? FPGA_REG_3F : 8'hFF; 

endmodule