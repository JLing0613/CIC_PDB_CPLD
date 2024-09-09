
module Blink_Clock
  #(
      parameter BlinkTimeValue = 500 // @ 1ms = 500ms
    )
    (
      input          CLK_IN,
      input          RESET_N,
      input          CLK_EN,
      output         BLINK_CLK_O
    );

    wire          clk,nrst;
    wire          blink_en,blink_clk_d;
    reg           blink_clk_r;
    wire  [ 11:0] blink_cnt_d;
    reg   [ 11:0] blink_cnt_r;

  assign clk  = CLK_IN;
  assign nrst = RESET_N;

  assign blink_en = (blink_cnt_r == BlinkTimeValue);

  assign blink_cnt_d = CLK_EN   ?
                       blink_en ? 12'h0 : blink_cnt_r + 1'b1
                                        : blink_cnt_r;

  assign blink_clk_d = CLK_EN   ? 
                       blink_en ? ~blink_clk_r : blink_clk_r
                                               : blink_clk_r;

  always @(posedge clk or negedge nrst) begin
      if (!nrst) begin
          blink_clk_r <= 1'b0;
          blink_cnt_r <= 12'h0;
        end
      else begin
          blink_clk_r <= blink_clk_d;
          blink_cnt_r <= blink_cnt_d;
        end
    end

  assign BLINK_CLK_O = blink_clk_r; // 1Hz Clock //

endmodule