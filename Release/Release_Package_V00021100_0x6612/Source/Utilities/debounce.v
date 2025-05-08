`timescale 1 ns / 1 ns

`define	s0_db		            	2'b00
`define	s1_db	        			2'b01	
`define	s2_db 		    			2'b10
`define	s3_db   		   			2'b11

module debounce
(
	input	wire			iCLK,
	input	wire			iRst_n,
	input	wire			iClk_dly,
	input	wire	[15:0]	dly_time,
	input	wire			prsnt_in,
	output	reg				prsnt_out
);

/********IOs Declaration********************************/
reg	 	[1:0]	db_reg;
reg				rDLY_TIMER_EN;
wire			wDLY_TIMEOUT;
/**************************Operations*****************************************/

always @(posedge iCLK or negedge iRst_n) begin
	if(!iRst_n) begin
			db_reg		<= `s0_db;
			prsnt_out	<= prsnt_in;
	end
	else begin
		case (db_reg)
				`s0_db:	begin
					if(dly_time != 16'd0) begin
						if(wDLY_TIMEOUT) begin
							rDLY_TIMER_EN			<=	1'b0;

							case ({prsnt_in, prsnt_out})
								2'b00: 	db_reg 		<= `s0_db;
								2'b01: begin 
										db_reg 		<= `s0_db; 
										prsnt_out 	<= 1'b0; 
								end
								2'b10: 	db_reg 		<= `s1_db;
								2'b11: 	db_reg 		<= `s3_db;
							endcase
						end
						else begin
							rDLY_TIMER_EN			<=	1'b1;
						end
					end
					else begin
						case ({prsnt_in, prsnt_out})
							2'b00: 	db_reg 			<= `s0_db;
							2'b01: begin 
									db_reg 			<= `s0_db; 
									prsnt_out 		<= 1'b0; 
							end
							2'b10: 	db_reg 			<= `s1_db;
							2'b11: 	db_reg 			<= `s3_db;
						endcase
					end
				end
				`s1_db:	begin
					if(dly_time != 16'd0) begin
						if(wDLY_TIMEOUT) begin
							rDLY_TIMER_EN			<=	1'b0;

							case ({prsnt_in, prsnt_out})
								2'b00: 	db_reg 		<= `s0_db;
								2'b01: 	db_reg 		<= `s0_db;
								2'b10: 	db_reg 		<= `s2_db;
								2'b11: 	db_reg 		<= `s3_db;
							endcase
						end
						else begin
							rDLY_TIMER_EN			<=	1'b1;
						end
					end
					else begin
						case ({prsnt_in, prsnt_out})
							2'b00: 	db_reg 			<= `s0_db;
							2'b01: 	db_reg 			<= `s0_db;
							2'b10: 	db_reg 			<= `s2_db;
							2'b11: 	db_reg 			<= `s3_db;
						endcase
					end
				end
				`s2_db:	begin
					if(dly_time != 16'd0) begin
						if(wDLY_TIMEOUT) begin
							rDLY_TIMER_EN			<=	1'b0;
							
							case ({prsnt_in, prsnt_out})
								2'b00: 	db_reg 		<= `s0_db;
								2'b01: 	db_reg 		<= `s1_db;
								2'b10: 	db_reg 		<= `s3_db;
								2'b11: 	db_reg 		<= `s3_db;
							endcase
						end
						else begin
							rDLY_TIMER_EN			<=	1'b1;
						end
					end
					else begin
						case ({prsnt_in, prsnt_out})
							2'b00: 	db_reg 			<= `s0_db;
							2'b01: 	db_reg 			<= `s1_db;
							2'b10: 	db_reg 			<= `s3_db;
							2'b11: 	db_reg 			<= `s3_db;
						endcase
					end
				end
				`s3_db: begin
					if(dly_time != 16'd0) begin
						if(wDLY_TIMEOUT) begin
							rDLY_TIMER_EN			<=	1'b0;

							case ({prsnt_in, prsnt_out})
								2'b00: 	db_reg 		<= `s0_db;
								2'b01: 	db_reg 		<= `s2_db;
								2'b10: begin 
										db_reg 		<= `s3_db; 
										prsnt_out 	<= 1'b1; 
								end
								2'b11: 	db_reg 		<= `s3_db;
							endcase
											end
						else begin
							rDLY_TIMER_EN			<=	1'b1;
						end
					end
					else begin
						case ({prsnt_in, prsnt_out})
							2'b00: 	db_reg 			<= `s0_db;
							2'b01: 	db_reg 			<= `s2_db;
							2'b10: begin 
									db_reg 			<= `s3_db; 
									prsnt_out 		<= 1'b1; 
							end
							2'b11: 	db_reg 			<= `s3_db;
						endcase
					end
				end
		endcase
	end
end

dly_timer#
(
	.pulse_constant	(1'b1)	//1'b0 = pulse, 1'b1 = constant
)
mdly_timer
(
	.clk_in				(iClk_dly),
	.iRst_n				(iRst_n),
	.iClear				(1'b1),
	.dly_timer_en		(rDLY_TIMER_EN),
	.dly_timer_start	(1'b1),
	.dly_time			(dly_time),
	.dly_timeout		(wDLY_TIMEOUT)
);

endmodule
