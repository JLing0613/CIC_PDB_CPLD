
module clk_debounce_p3(
	input  wire        sda_in,
	input  wire        scl_in,
	input  wire        sda_low_en_i,
	input  wire        scl_low_en_i,	
	output wire        sda_out,
	output wire        scl_out,	
	input  wire        clk_i,
	input  wire        resetn_i
	);
	parameter det_bit = 3;
	//detect I2C Count
	reg  [det_bit-1:0] sda_hih ;
	reg  [det_bit-1:0] sda_low ;
	reg  [det_bit-1:0] scl_hih ;
	reg  [det_bit-1:0] scl_low ;
	wire [det_bit-1:0] v_sda_hih  =  sda_in ? sda_hih[det_bit-1] ?  {det_bit{1'b1}} : sda_hih + 1 : {det_bit{1'b0}};	
	wire [det_bit-1:0] v_sda_low  = ~sda_in ? sda_low[det_bit-1] ?  {det_bit{1'b1}} : sda_low + 1 : {det_bit{1'b0}};
	wire [det_bit-1:0] v_scl_hih  =  scl_in ? scl_hih[det_bit-1] ?  {det_bit{1'b1}} : scl_hih + 1 : {det_bit{1'b0}};	
	wire [det_bit-1:0] v_scl_low  = ~scl_in ? scl_low[det_bit-1] ?  {det_bit{1'b1}} : scl_low + 1 : {det_bit{1'b0}};	
	//io debuence
	reg sda_deb;
	wire v_sda_deb = (sda_low_en_i | (sda_low[det_bit-1] & ~sda_hih[det_bit-1])) ? 1'b0 : (sda_hih[det_bit-1] & ~sda_low[det_bit-1]) ? 1'b1 : sda_deb;
	reg scl_deb;
	wire v_scl_deb = (scl_low_en_i | (scl_low[det_bit-1] & ~scl_hih[det_bit-1])) ? 1'b0 : (scl_hih[det_bit-1] & ~scl_low[det_bit-1]) ? 1'b1 : scl_deb;
	//FD1S1B inst0_FD1S1B (.D(sda_deb),		.CK(clk_i),		.PD(~resetn_i),		.Q(sda_out)		);
	//FD1S1B inst1_FD1S1B (.D(scl_deb),		.CK(clk_i),		.PD(~resetn_i),		.Q(scl_out)		);

	always @ ( negedge resetn_i or posedge clk_i )
		if ( !resetn_i ) begin
			sda_deb <= 1'b1;
			scl_deb <= 1'b1;
            sda_hih <= {det_bit{1'b1}};
            sda_low	<= {det_bit{1'b0}};			
            scl_hih	<= {det_bit{1'b1}};			
            scl_low	<= {det_bit{1'b0}};			
		end else begin
			sda_deb <= v_sda_deb;
			scl_deb <= v_scl_deb;
            sda_hih <= v_sda_hih;
            sda_low	<= v_sda_low;			
            scl_hih	<= v_scl_hih;			
            scl_low	<= v_scl_low;	
			end 
	assign sda_out  = sda_deb;  
	assign scl_out  = scl_deb;
endmodule
