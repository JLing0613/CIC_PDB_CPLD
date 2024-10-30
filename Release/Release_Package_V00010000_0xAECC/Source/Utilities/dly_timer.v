// FILE:      dly_timer.v
// BLOCK:     DELAY TIME FOR OCP NIC3 Sequence
// REVISION:  [0.85]
//
// DESCRIPTION:  DEY TIMER module
//   
// ASSUMPTIONS:

`timescale 1 ns / 1 ns

module dly_timer#
(
    parameter pulse_constant = 0    //1'b0 = pulse, 1'b1 = constant
)
(
	input   wire            clk_in,
	input   wire            iRst_n,
    input   wire            iClear,
    input   wire            dly_timer_en,
	input   wire  [15:0]    dly_time,
	output  reg             dly_timeout	
);
reg	    [15:0]  dly_count;

always @(posedge clk_in or negedge iRst_n or negedge iClear or negedge dly_timer_en) begin
    if (!iRst_n || !iClear || !dly_timer_en) begin
        dly_count		<= 0;
        dly_timeout		<= 0;
    end
    else begin
        if (dly_count < dly_time) begin
            dly_count	<= dly_count + 16'd1;
            dly_timeout	<= 0;
        end
        else begin
            if(pulse_constant) begin
                dly_count	<= dly_count;
                dly_timeout	<= 1;
            end
            else begin
                dly_count	<= 0;
                dly_timeout	<= 1;
            end
        end
    end
end

endmodule