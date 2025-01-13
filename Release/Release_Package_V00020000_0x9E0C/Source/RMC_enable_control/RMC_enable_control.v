`timescale 1 ns / 1 ns

module RMC_enable_control
(
	input   wire    clk_in,
    input   wire    clk_delay,
	input   wire    iRst_n,
    input   wire    iClear,
    
    input   wire    iRMC_enable_debounce,
    input   wire    iRMC_enable_config,
    output  wire    oRMC_enable_delay

);

assign  oRMC_enable_delay   =   rRMC_enable;

reg rRMC_enable;
reg rDlytimer_en;
wire wDlytimer_output;

always @ (posedge clk_in or negedge iRst_n) begin
	if(!iRst_n) begin
		rRMC_enable				    <= 1'b1;
	end
	else begin
		if(!iRMC_enable_config) begin
            rRMC_enable             <= iRMC_enable_debounce;
        end
        else begin
            if(iRMC_enable_debounce && !rRMC_enable) begin
                //if(wDlytimer_output) begin
                    rRMC_enable    <= 1'b1;
                //    rDlytimer_en   <= 1'b0;
                //end
                //else begin
                //    rDlytimer_en   <= 1'b1;
                //end
            end
            else if(!iRMC_enable_debounce && rRMC_enable) begin
                if(wDlytimer_output) begin
                    rRMC_enable    <= 1'b0;
                    rDlytimer_en   <= 1'b0;
                end
                else begin
                    rDlytimer_en   <= 1'b1;
                end
            end
            else begin
                rRMC_enable         <= rRMC_enable;
            end
        end
	end
end

dly_timer#
(
	.pulse_constant		(1'b1)
)
mRMC_enable_fall_delay
(
	.clk_in				(clk_delay),
	.iRst_n				(iRst_n),
	.iClear				(1'b1),
	.dly_timer_en		(rDlytimer_en),
	.dly_timer_start	(1'b1),
	.dly_time			(16'd1200),
	.dly_timeout		(wDlytimer_output)
);

endmodule