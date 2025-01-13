`timescale 1 ns / 1 ns

`define	s0_db		            	2'b00
`define	s1_db	        			2'b01	
`define	s2_db 		    			2'b10
`define	s3_db   		   			2'b11

module debounce
(
	input	wire	clk_1k,
	input	wire	cpld_rst_n,
	input	wire	prsnt_in,
	output	reg		prsnt_out
);

/********IOs Declaration********************************/
reg	 [1:0]db_reg;

/**************************Operations*****************************************/

always @(posedge clk_1k or negedge cpld_rst_n) begin
	if(!cpld_rst_n) begin
			db_reg	<= `s0_db;
			prsnt_out	<= prsnt_in;
	end
	else begin
		case (db_reg)
				`s0_db:	begin
					case ({prsnt_in, prsnt_out})
						2'b00: db_reg <= `s0_db;
						2'b01: begin 
							db_reg <= `s0_db; 
							prsnt_out <= 1'b0; 
						end
						2'b10: db_reg <= `s1_db;
						2'b11: db_reg <= `s3_db;
					endcase
				end
				`s1_db:	begin
					case ({prsnt_in, prsnt_out})
						2'b00: db_reg <= `s0_db;
						2'b01: db_reg <= `s0_db;
						2'b10: db_reg <= `s2_db;
						2'b11: db_reg <= `s3_db;
					endcase
				end
				`s2_db:	begin
					case ({prsnt_in, prsnt_out})
						2'b00: db_reg <= `s0_db;
						2'b01: db_reg <= `s1_db;
						2'b10: db_reg <= `s3_db;
						2'b11: db_reg <= `s3_db;
					endcase
				end
				`s3_db: begin
					case ({prsnt_in, prsnt_out})
						2'b00: db_reg <= `s0_db;
						2'b01: db_reg <= `s2_db;
						2'b10: begin 
							db_reg <= `s3_db; 
							prsnt_out <= 1'b1; 
						end
						2'b11: db_reg <= `s3_db;
					endcase
				end
		endcase
	end
end
	
endmodule
