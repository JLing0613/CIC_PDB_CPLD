module randomnumbergenerator
	#(
	parameter      BIT = 512
	)
	(
	input clk,
	input rstn,
	output reg [BIT-1:0] rnd
	);
	
	wire feedback;
	wire [BIT+2:0] lfsr_next;
	
	//An LFSR cannot have an all 0 state, thus rstn to non-zero value
	reg [BIT+1:0] rstn_value = {BIT+2{1'b1}};
	reg [BIT+1:0] lfsr;
	reg [31:0] count;
	
	// pragma translate_off
	integer f;
	initial begin
			f = $fopen("output.txt","w");
		end
	// pragma translate_on
	
	always @ (posedge clk or negedge rstn)
		begin
			if (!rstn) begin
					lfsr <= rstn_value;
					count <= 32'h0;
					rnd <= {BIT{1'b1}};
				end
			else begin
					lfsr <= lfsr_next;
					count <= count + 1;
					// a new random value is ready
					if (count == 32'd32) begin
							count <= 0;
							rnd <= lfsr[BIT-1:0]; //assign the lfsr number to output after 10 shifts
							// pragma translate_off
							$fwrite(f,"%0d\n",rnd);
							// pragma translate_on
						end
				end
		end
	
	// X10+x7
	assign feedback = lfsr[BIT-1] ^ lfsr[8];
	assign lfsr_next = {lfsr[BIT-2:0], feedback};
	
	// pragma translate_off
	always @ (*) begin
			if (rnd == rstn_value) begin
					$fclose(f);
					$finish();
				end
		end
	// pragma translate_on
endmodule