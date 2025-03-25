// *******************************************************************
// Copyright (c) 2022 by WEIKENG INDUSTRIAL CO., LTD. 
// *******************************************************************
//
// 11F, 308, Sec.1, NeiHu Rd., Taipei 11493, Taiwan
// TEL : +886-2-2658-0959
// WEB : http://www.weikeng.com.tw
//
// *******************************************************************
//
// File :
//     Clock_Generator.v
// Description :
//     Clock_Generator Module
//
// *******************************************************************
// Code Revision History:
// *******************************************************************
// Version | Author         | Modify Date | Changes Made
// V0.0    | Vincent Lee    | 2022/01/11  | Initial Version
// *******************************************************************
// CPLD/FPGA Vender : Lattice
// Part Number      : LCMXO3LF-4300C-5BG256C
// *******************************************************************

`timescale 1 ns/100 ps

module Clock_Generator
  #(
      parameter DivCnt0Width = 8,
                DivCnt1Width = 4,
                DivCnt2Width = 8,
                DivCnt3Width = 12,
                DivCnt4Width = 12,
      parameter DivValue0    = 8'd2,    // (  2MHz/   2) =   1MHz =  1us
                DivValue1    = 4'd10,   // (  1MHz/  10) = 100KHz = 10us
                DivValue2    = 8'd100,  // (100KHz/ 100) =   1KHz =  1ms
                DivValue3    = 12'd50,  // (  1KHz/  50) =  200Hz =  50ms
                DivValue4    = 12'd1000 // (  1KHz/1000) =    1Hz =  1s
    )
    (
      input          CLK_IN,    // 2MHz
      input          RESET_N,
      output         CLK_EN_O0,
      output         CLK_EN_O1,
      output         CLK_EN_O2,
      output         CLK_EN_O3,
      output         CLK_EN_O4 
    );

    wire                    clk,nrst;
    wire                    div_cnt_0_en,div_cnt_1_en,div_cnt_2_en,div_cnt_3_en,div_cnt_4_en;
    reg                     clk_en_0_r,clk_en_1_r,clk_en_2_r,clk_en_3_r,clk_en_4_r;
    reg [DivCnt0Width-1:0]  div_cnt_0_r;
    reg [DivCnt1Width-1:0]  div_cnt_1_r;
    reg [DivCnt2Width-1:0]  div_cnt_2_r;
    reg [DivCnt3Width-1:0]  div_cnt_3_r;
    reg [DivCnt4Width-1:0]  div_cnt_4_r;
    
    wire [DivCnt0Width-1:0] div_cnt_0_d;
    wire [DivCnt1Width-1:0] div_cnt_1_d;
    wire [DivCnt2Width-1:0] div_cnt_2_d;
    wire [DivCnt3Width-1:0] div_cnt_3_d;
    wire [DivCnt4Width-1:0] div_cnt_4_d;
    
    assign clk  = CLK_IN;
    assign nrst = RESET_N;

    // Generate 1MHz Enable //
    assign div_cnt_0_en = (div_cnt_0_r == DivValue0 - 1'b1);
    assign div_cnt_0_d  = div_cnt_0_en ? {DivCnt0Width{1'b0}} : div_cnt_0_r + 1'b1;

    // Generate 100KHz Enable //
    assign div_cnt_1_en = (div_cnt_1_r == DivValue1 - 1'b1) && div_cnt_0_en;
    assign div_cnt_1_d  = div_cnt_1_en ? {DivCnt1Width{1'b0}} :
                          div_cnt_0_en ? div_cnt_1_r + 1'b1   : div_cnt_1_r;

    // Generate 1KHz Enable //
    assign div_cnt_2_en = (div_cnt_2_r == DivValue2 - 1'b1) && div_cnt_1_en;
    assign div_cnt_2_d  = div_cnt_2_en ? {DivCnt2Width{1'b0}} :
                          div_cnt_1_en ? div_cnt_2_r + 1'b1   : div_cnt_2_r;

    // Generate 200Hz Enable //
    assign div_cnt_3_en = (div_cnt_3_r == DivValue3 - 1'b1) && div_cnt_2_en;
    assign div_cnt_3_d  = div_cnt_3_en ? {DivCnt3Width{1'b0}} :
                          div_cnt_2_en ? div_cnt_3_r + 1'b1   : div_cnt_3_r;

    // Generate 1Hz Enable //
    assign div_cnt_4_en = (div_cnt_4_r == DivValue4 - 1'b1) && div_cnt_3_en;
    assign div_cnt_4_d  = div_cnt_4_en ? {DivCnt4Width{1'b0}} :
                          div_cnt_3_en ? div_cnt_4_r + 1'b1   : div_cnt_4_r;

  // DFF //
  always @(posedge clk or negedge nrst) begin
      if (!nrst) begin
          div_cnt_0_r <= {DivCnt0Width{1'b0}};
          div_cnt_1_r <= {DivCnt1Width{1'b0}};
          div_cnt_2_r <= {DivCnt2Width{1'b0}};
          div_cnt_3_r <= {DivCnt3Width{1'b0}};
          div_cnt_4_r <= {DivCnt4Width{1'b0}};
          clk_en_0_r  <= 1'b0;
          clk_en_1_r  <= 1'b0;
          clk_en_2_r  <= 1'b0;
          clk_en_3_r  <= 1'b0;
          clk_en_4_r  <= 1'b0;
        end
      else begin
          div_cnt_0_r <= div_cnt_0_d;
          div_cnt_1_r <= div_cnt_1_d;
          div_cnt_2_r <= div_cnt_2_d;
          div_cnt_3_r <= div_cnt_3_d;
          div_cnt_4_r <= div_cnt_4_d;
          clk_en_0_r  <= div_cnt_0_en;
          clk_en_1_r  <= div_cnt_1_en;
          clk_en_2_r  <= div_cnt_2_en;
          clk_en_3_r  <= div_cnt_3_en;
          clk_en_4_r  <= div_cnt_4_en;
        end
    end

  // Output //
  assign CLK_EN_O0 = clk_en_0_r;
  assign CLK_EN_O1 = clk_en_1_r;
  assign CLK_EN_O2 = clk_en_2_r;
  assign CLK_EN_O3 = clk_en_3_r;
  assign CLK_EN_O4 = clk_en_4_r;

endmodule