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
//#(
//  parameter CpldMajorRev = 8'h01,
//            CpldMinorRev = 8'h00
//)
(
  input          CLK_IN,
  input          RESET_N,
  input  [  7:0] I2C_CMD,
  output [  7:0] I2C_DAT_O,
  input  [  7:0] I2C_DAT_I,
  input          I2C_WREN,
  input          I2C_RDEN,
  input  [  7:0] iFPGA_REG_00,
  input  [  7:0] iFPGA_REG_01,
  input  [  7:0] iFPGA_REG_02,
  input  [  7:0] iFPGA_REG_03,
  input  [  7:0] iFPGA_REG_04,
  input  [  7:0] iFPGA_REG_05,
  input  [  7:0] iFPGA_REG_06,
  input  [  7:0] iFPGA_REG_07,
  input  [  7:0] iFPGA_REG_08,
  input  [  7:0] iFPGA_REG_09,
  input  [  7:0] iFPGA_REG_0A,
  input  [  7:0] iFPGA_REG_0B,
  input  [  7:0] iFPGA_REG_0C,
  input  [  7:0] iFPGA_REG_0D,
  input  [  7:0] iFPGA_REG_0E,
  input  [  7:0] iFPGA_REG_0F,
  input  [  7:0] iFPGA_REG_10,
  input  [  7:0] iFPGA_REG_11,
  input  [  7:0] iFPGA_REG_12,
  input  [  7:0] iFPGA_REG_13,
  input  [  7:0] iFPGA_REG_14,
  input  [  7:0] iFPGA_REG_15,
  input  [  7:0] iFPGA_REG_16,
  input  [  7:0] iFPGA_REG_17,
  input  [  7:0] iFPGA_REG_18,
  input  [  7:0] iFPGA_REG_19,
  input  [  7:0] iFPGA_REG_1A,
  input  [  7:0] iFPGA_REG_1B,
  input  [  7:0] iFPGA_REG_1C,
  input  [  7:0] iFPGA_REG_1D,
  input  [  7:0] iFPGA_REG_1E,
  input  [  7:0] iFPGA_REG_1F
);

  wire clk;
  wire nrst;
  
  reg  [  7:0] FPGA_REG_00;
  reg  [  7:0] FPGA_REG_01;
  reg  [  7:0] FPGA_REG_02;
  reg  [  7:0] FPGA_REG_03;
  reg  [  7:0] FPGA_REG_04;
  reg  [  7:0] FPGA_REG_05;
  reg  [  7:0] FPGA_REG_06;
  reg  [  7:0] FPGA_REG_07;
  reg  [  7:0] FPGA_REG_08;
  reg  [  7:0] FPGA_REG_09;
  reg  [  7:0] FPGA_REG_0A;
  reg  [  7:0] FPGA_REG_0B;
  reg  [  7:0] FPGA_REG_0C;
  reg  [  7:0] FPGA_REG_0D;
  reg  [  7:0] FPGA_REG_0E;
  reg  [  7:0] FPGA_REG_0F;
  reg  [  7:0] FPGA_REG_10;
  reg  [  7:0] FPGA_REG_11;
  reg  [  7:0] FPGA_REG_12;
  reg  [  7:0] FPGA_REG_13;
  reg  [  7:0] FPGA_REG_14;
  reg  [  7:0] FPGA_REG_15;
  reg  [  7:0] FPGA_REG_16;
  reg  [  7:0] FPGA_REG_17;
  reg  [  7:0] FPGA_REG_18;
  reg  [  7:0] FPGA_REG_19;
  reg  [  7:0] FPGA_REG_1A;
  reg  [  7:0] FPGA_REG_1B;
  reg  [  7:0] FPGA_REG_1C;
  reg  [  7:0] FPGA_REG_1D;
  reg  [  7:0] FPGA_REG_1E;
  reg  [  7:0] FPGA_REG_1F;


  wire  [  7:0] wFPGA_REG_00;
  wire  [  7:0] wFPGA_REG_01;
  wire  [  7:0] wFPGA_REG_02;
  wire  [  7:0] wFPGA_REG_03;
  wire  [  7:0] wFPGA_REG_04;
  wire  [  7:0] wFPGA_REG_05;
  wire  [  7:0] wFPGA_REG_06;
  wire  [  7:0] wFPGA_REG_07;
  wire  [  7:0] wFPGA_REG_08;
  wire  [  7:0] wFPGA_REG_09;
  wire  [  7:0] wFPGA_REG_0A;
  wire  [  7:0] wFPGA_REG_0B;
  wire  [  7:0] wFPGA_REG_0C;
  wire  [  7:0] wFPGA_REG_0D;
  wire  [  7:0] wFPGA_REG_0E;
  wire  [  7:0] wFPGA_REG_0F;
  wire  [  7:0] wFPGA_REG_10;
  wire  [  7:0] wFPGA_REG_11;
  wire  [  7:0] wFPGA_REG_12;
  wire  [  7:0] wFPGA_REG_13;
  wire  [  7:0] wFPGA_REG_14;
  wire  [  7:0] wFPGA_REG_15;
  wire  [  7:0] wFPGA_REG_16;
  wire  [  7:0] wFPGA_REG_17;
  wire  [  7:0] wFPGA_REG_18;
  wire  [  7:0] wFPGA_REG_19;
  wire  [  7:0] wFPGA_REG_1A;
  wire  [  7:0] wFPGA_REG_1B;
  wire  [  7:0] wFPGA_REG_1C;
  wire  [  7:0] wFPGA_REG_1D;
  wire  [  7:0] wFPGA_REG_1E;
  wire  [  7:0] wFPGA_REG_1F;

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

  // Address 0x07 , BMC Boot Status(R/W)
  // assign FPGA_REG_08_d[7]    = PWR_SYS_ON;
  // assign FPGA_REG_08_d[6:1]  = 6'h0;
  // assign FPGA_REG_08_d[0]    = I2C_WREN && (I2C_CMD == 8'h07) ? I2C_DAT_I[0]   : FPGA_REG_08[0];
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
        end
      else 
        begin
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
        end
    end


  assign I2C_DAT_O = (I2C_CMD == 8'h00) ? FPGA_REG_00 :
                     (I2C_CMD == 8'h01) ? FPGA_REG_01 :
                     (I2C_CMD == 8'h02) ? FPGA_REG_02 :
                     (I2C_CMD == 8'h03) ? FPGA_REG_03 :
                     (I2C_CMD == 8'h04) ? FPGA_REG_04 :
                     (I2C_CMD == 8'h05) ? FPGA_REG_05 :
                     (I2C_CMD == 8'h06) ? FPGA_REG_06 :
                     (I2C_CMD == 8'h07) ? FPGA_REG_07 :
                     (I2C_CMD == 8'h08) ? FPGA_REG_08 :
                     (I2C_CMD == 8'h09) ? FPGA_REG_09 :
                     (I2C_CMD == 8'h0A) ? FPGA_REG_0A :
                     (I2C_CMD == 8'h0B) ? FPGA_REG_0B :
                     (I2C_CMD == 8'h0C) ? FPGA_REG_0C :
                     (I2C_CMD == 8'h0D) ? FPGA_REG_0D :
                     (I2C_CMD == 8'h0E) ? FPGA_REG_0E :
                     (I2C_CMD == 8'h0F) ? FPGA_REG_0F : 
                     (I2C_CMD == 8'h10) ? FPGA_REG_10 :
                     (I2C_CMD == 8'h11) ? FPGA_REG_11 :
                     (I2C_CMD == 8'h12) ? FPGA_REG_12 :
                     (I2C_CMD == 8'h13) ? FPGA_REG_13 :
                     (I2C_CMD == 8'h14) ? FPGA_REG_14 :
                     (I2C_CMD == 8'h15) ? FPGA_REG_15 :
                     (I2C_CMD == 8'h16) ? FPGA_REG_16 :
                     (I2C_CMD == 8'h17) ? FPGA_REG_17 :
                     (I2C_CMD == 8'h18) ? FPGA_REG_18 :
                     (I2C_CMD == 8'h19) ? FPGA_REG_19 :
                     (I2C_CMD == 8'h1A) ? FPGA_REG_1A :
                     (I2C_CMD == 8'h1B) ? FPGA_REG_1B :
                     (I2C_CMD == 8'h1C) ? FPGA_REG_1C :
                     (I2C_CMD == 8'h1D) ? FPGA_REG_1D :
                     (I2C_CMD == 8'h1E) ? FPGA_REG_1E :
                     (I2C_CMD == 8'h1F) ? FPGA_REG_1F : 
                     8'hFF; 


endmodule