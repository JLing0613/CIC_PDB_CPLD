module det_efb2rst
	( 
	//EFB
	input  wire			EFB_scl_i,
	input  wire			EFB_sda_i,
	output wire         rstn_ufm_o,
	//system
	input  wire			clk_i,
	input  wire			resetn_i
	);	
	// ===========================================================
	//	DETECT EFB ID Disable UFM Trigger segment
	// ===========================================================
	// -----------------------------------------------------------------------------
	// FEB DET I2C FEATURE
	// -----------------------------------------------------------------------------
	parameter EFB_SYS_IDLE     = 4'd0,
		EFB_SYS_ADDR     = 4'd1,
		EFB_DEV_CHC      = 4'd2,
		EFB_DEV_ACK0     = 4'd3,
		EFB_SYS_DAT      = 4'd4,
		EFB_DAT_CHC      = 4'd5,		
		WAIT_EFB_STOP    = 4'd6,
		WAIT_EFB_RUN     = 4'd7;	
	reg rstn_ufm;
	wire v_rstn_ufm;
	wire efb_CMD_Run; 
	wire efb_CMD_Stop;
	wire efb_ST_Run;
	wire efb_ST_Stop;
	// Collect I2C bus three date
	reg  [2:0]   sda_efb;
	wire [2:0] v_sda_efb = {sda_efb[1:0], EFB_sda_i};
	reg  [3:0] v_efb_state , efb_state;
	reg  [2:0] v_efb_bitcnt, efb_bitcnt;
	reg  [7:0] v_efb_wdata , efb_wdata; // I2C write data data
	reg efb_start_r, efb_stop_r;
	reg          efb_byteend;
	wire       v_efb_byteend = v_scl_negedge & (efb_bitcnt == 3'd7);
	// Collect I2C bus three clock
	reg  [2:0]   scl_efb;
	wire [2:0] v_scl_efb = {scl_efb[1:0], EFB_scl_i};
	
	// ------I2C clock negedg
	wire       v_scl_negedge = (scl_efb[2:1] == 2'b10);	 	
	// ------I2C clock posedge
	wire       v_scl_posedge = (scl_efb[2:1] == 2'b01);	
	
	
	wire       v_efb_start = (sda_efb[2:1] == 2'b10) && (scl_efb[2:1] == 2'b11) ? 1'b1
		: v_scl_negedge ? 1'b0 : efb_start_r;
	
	wire       v_efb_stop  = (sda_efb[2:1] == 2'b01) && (scl_efb[2:1] == 2'b11);	
	
	wire   efb_ID;	  
	// ===========================================================
	//	DETECT EFB ID Disable UFM Trigger segment
	// ===========================================================
	// -----------------------------------------------------------------------------
	// Instruction set
	// -----------------------------------------------------------------------------
	assign efb_ID  =    (efb_wdata[7:1] == 7'h40);// | 
		//(efb_wdata[7:1]  == 7'h41) |
		//(efb_wdata[7:1]  == 7'h43) |
		//(efb_wdata[7:1]  == 7'h78) ;
		
	assign efb_CMD_Run = (efb_wdata[7:0] == 8'hFF);//*Not Equal WAIT_EFB_RUN, UFM to RESET.
	//assign efb_CMD_Stop = (efb_wdata[7:0] == 8'hE0);	
	assign efb_ST_Run = (efb_state == WAIT_EFB_RUN);	
	assign efb_ST_Stop = (efb_state == WAIT_EFB_STOP);
	assign v_rstn_ufm =  efb_ST_Stop ? 1'b0 : (efb_ST_Run & v_efb_stop) ? 1'b1 : rstn_ufm;
	// I2C State Machine //
	always @(*) begin
			if (efb_stop_r) begin
					v_efb_state  = EFB_SYS_IDLE;
					v_efb_bitcnt = 3'd0;
					v_efb_wdata  = 8'd0;
				end
			else
				case (efb_state)
					EFB_SYS_IDLE : begin
							v_efb_state  = (efb_start_r & v_scl_negedge) ? EFB_SYS_ADDR : efb_state;
							v_efb_bitcnt = 3'd0;
							v_efb_wdata  = 8'd0;
						end
					EFB_SYS_ADDR : begin     // if no channel write to CPLD
							v_efb_state  = efb_byteend ?  EFB_DEV_CHC : efb_state;
							v_efb_bitcnt = (efb_bitcnt == 3'd7) ? efb_bitcnt
							: v_scl_negedge ? (efb_bitcnt + 1'b1) : efb_bitcnt;
							v_efb_wdata  = v_scl_posedge ? {efb_wdata[6:0], sda_efb[2]} : efb_wdata;
						end
					EFB_DEV_CHC : begin
							v_efb_state  = efb_ID ? EFB_DEV_ACK0 : EFB_SYS_IDLE;
							v_efb_bitcnt = 3'd0;
							v_efb_wdata  = efb_wdata;
						end
					EFB_DEV_ACK0 : begin
							v_efb_state  = v_scl_posedge ? EFB_SYS_DAT : efb_state;
							v_efb_bitcnt = 3'd0;
							v_efb_wdata  = efb_wdata;
						end						
					EFB_SYS_DAT : begin     // if no channel write to CPLD
							v_efb_state  = efb_byteend ?  EFB_DAT_CHC : efb_state;
							v_efb_bitcnt = (efb_bitcnt == 3'd7) ? efb_bitcnt
							: v_scl_negedge ? (efb_bitcnt + 1'b1) : efb_bitcnt;
							v_efb_wdata  = v_scl_posedge ? {efb_wdata[6:0], sda_efb[2]} : efb_wdata;
						end
					EFB_DAT_CHC : begin
							v_efb_state  = efb_CMD_Run ? WAIT_EFB_RUN : WAIT_EFB_STOP;
							v_efb_bitcnt = 3'd0;
							v_efb_wdata  = efb_wdata;
						end						
					WAIT_EFB_STOP : begin
							v_efb_state  = efb_state;
							v_efb_bitcnt = 3'd0;
							v_efb_wdata  = efb_wdata;
						end
					WAIT_EFB_RUN : begin
							v_efb_state  = efb_state;
							v_efb_bitcnt = 3'd0;
							v_efb_wdata  = efb_wdata;
						end							
					default : begin
							v_efb_state  = EFB_SYS_IDLE;
							v_efb_bitcnt = 3'd0;
							v_efb_wdata  = efb_wdata;
						end
				endcase
		end						
	
	always @(posedge clk_i or negedge resetn_i) begin
			if (~resetn_i) begin		
					efb_start_r     <= 1'b0;
					efb_stop_r      <= 1'b0;
					sda_efb         <= 3'b111;
					scl_efb         <= 3'b111;			
					efb_state       <= 4'd0;
					efb_bitcnt      <= 3'd0;
					efb_wdata       <= 8'd0;
					efb_byteend     <= 1'b0;
					rstn_ufm         <= 1'b1;
				end
			else begin
					efb_start_r     <= v_efb_start    ;
					efb_stop_r      <= v_efb_stop   ;
					sda_efb         <= v_sda_efb     ;
					scl_efb         <= v_scl_efb     ;
					efb_state       <= v_efb_state      ;
					efb_bitcnt      <= v_efb_bitcnt     ;
					efb_wdata       <= v_efb_wdata      ;
					efb_byteend     <= v_efb_byteend    ;
					rstn_ufm         <= v_rstn_ufm    ;
				end
		end
	assign rstn_ufm_o = rstn_ufm;
endmodule		