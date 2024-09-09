`timescale 1 ns/1 ns

module I2C_Slave(

CLK_IN,
RESET_N,
I2C_SLAVE_ADDR,
SDA,
SCL,
OFFSET,
DATA_OUT,
DATA_IN,
WRITE_EN,
READ_EN,
START,
STOP
//BYTE_INDEX

);

input  wire        CLK_IN;
input  wire        RESET_N;
input  wire [ 6:0] I2C_SLAVE_ADDR;
inout  wire        SDA;
input  wire        SCL;
output wire [ 7:0] OFFSET;
output wire [ 7:0] DATA_OUT;
input  wire [ 7:0] DATA_IN;
output wire        WRITE_EN;
output wire        READ_EN;
output wire        START;
output wire        STOP;
//output wire [ 7:0] BYTE_INDEX;



parameter TP = 1;
parameter TP2 = 3;

parameter sm_idle    = 4'h0;
parameter sm_pre_adr = 4'h1;
parameter sm_adr     = 4'h2;
parameter sm_adr_ack = 4'h3;
parameter sm_cmd     = 4'h4;
parameter sm_cmd_ack = 4'h5;
parameter sm_dat     = 4'h6;
parameter sm_dat_ack = 4'h7;
parameter sm_stop    = 4'h8;


wire        clk;
wire        nrst;
wire        i2c_start;
wire        i2c_stop;
wire        clr_bit_cnt;
wire        bit_cnt_en;
wire        latch_adr_en;
wire        latch_cmd_en;
wire        latch_dat_en;
wire        latch_read_ack;
wire        i2c_data_index_en;
wire        i2c_wren_rden;
wire        i2c_rnw;
wire        load_rd_dat;
wire        shift_reg_en;
wire        i2c_ack_bit;
wire        i2c_adr_match;
wire        scl_pos;
wire        scl_neg;
wire        adr_reg_ld;
wire        cmd_reg_ld;
wire        dat_reg_ld;

reg         i2c_ack;
reg         sda_i;
reg  [ 2:0] i2c_wren;
reg         i2c_rden;
//reg  [ 7:0] dat_index;
reg  [ 2:0] sda_pipe;
reg  [ 2:0] scl_pipe;
reg  [ 3:0] csm;
reg  [ 3:0] nsm;
reg  [ 3:0] bit_cnt;
reg  [ 7:0] i2c_reg;
reg  [ 7:0] adr_reg;
reg  [ 7:0] cmd_reg;
reg  [ 7:0] dat_reg;
reg  [ 7:0] rd_dat_shift_reg;



assign clk  = CLK_IN;

assign nrst = RESET_N;



// SDA,SCL pipeline //
always @(posedge clk or negedge nrst)
  begin
    if (!nrst)
        sda_pipe <= # TP 3'b111;
    else
        sda_pipe <= # TP {sda_pipe[1:0],SDA};
  end


always @(posedge clk or negedge nrst)
  begin
    if (!nrst)
        scl_pipe <= # TP 3'b111;
    else
        scl_pipe <= # TP {scl_pipe[1:0],SCL};
  end



// SCL rising,falling edge //
assign scl_neg = (scl_pipe[2:1] == 2'b10);

assign scl_pos = (scl_pipe[2:1] == 2'b01);



// I2C start,stop detect //
assign i2c_start = ((sda_pipe[2:1] == 2'b10) & (scl_pipe[2:1] == 2'b11));

assign i2c_stop  = ((sda_pipe[2:1] == 2'b01) & (scl_pipe[2:1] == 2'b11));


// I2C State Machine //
always @(posedge clk or negedge nrst)
  begin
    if (!nrst)
        csm <= # TP sm_idle;
    else if (i2c_stop)
        csm <= # TP sm_idle;
    else
        csm <= # TP nsm;
  end


always @(*)
  begin
    case (csm)
      sm_idle     : nsm = (i2c_start) ? sm_pre_adr : sm_idle;
      sm_pre_adr  : nsm = (scl_neg) ? sm_adr : sm_pre_adr;
      sm_adr      : nsm = (bit_cnt[3]) ? sm_adr_ack : sm_adr;
      sm_adr_ack  : nsm = (scl_neg) ? (i2c_adr_match ? ((i2c_rnw) ? sm_dat : sm_cmd) : sm_stop) : sm_adr_ack;
      sm_cmd      : nsm = (bit_cnt[3]) ? sm_cmd_ack : sm_cmd;
      sm_cmd_ack  : nsm = (scl_neg) ? sm_dat : sm_cmd_ack;
      sm_dat      : nsm = (i2c_start) ? sm_pre_adr :
                          (bit_cnt[3]) ? sm_dat_ack : sm_dat;
      sm_dat_ack  : nsm = (scl_neg) ? ((i2c_rnw & (i2c_ack)) ? sm_stop : sm_dat) : sm_dat_ack;
      sm_stop     : nsm = (i2c_stop) ? sm_idle : sm_stop;
      default     : nsm = sm_idle;
    endcase
  end


// I2C bit counter //
assign clr_bit_cnt = i2c_start | (csm == sm_adr_ack) | (csm == sm_cmd_ack) | (csm == sm_dat_ack);

assign bit_cnt_en = ((csm == sm_adr) | (csm == sm_cmd) | (csm == sm_dat)) & scl_neg;



always @(posedge clk or negedge nrst)
  begin
    if (!nrst)
        bit_cnt <= # TP 4'h0;
    else if (clr_bit_cnt)
        bit_cnt <= # TP 4'h0;
    else if (bit_cnt_en)
        bit_cnt <= # TP bit_cnt + 1'b1;
  end



// Latch I2C Address , Offset , Data //
always @(posedge clk or negedge nrst)
  begin
    if (!nrst)
      i2c_reg <= # TP 8'hff;
    else if (latch_adr_en | latch_cmd_en | latch_dat_en)
      begin
        if (bit_cnt == 4'h0) i2c_reg[7] <= # TP sda_pipe[2];
        if (bit_cnt == 4'h1) i2c_reg[6] <= # TP sda_pipe[2];
        if (bit_cnt == 4'h2) i2c_reg[5] <= # TP sda_pipe[2];
        if (bit_cnt == 4'h3) i2c_reg[4] <= # TP sda_pipe[2];
        if (bit_cnt == 4'h4) i2c_reg[3] <= # TP sda_pipe[2];
        if (bit_cnt == 4'h5) i2c_reg[2] <= # TP sda_pipe[2];
        if (bit_cnt == 4'h6) i2c_reg[1] <= # TP sda_pipe[2];
        if (bit_cnt == 4'h7) i2c_reg[0] <= # TP sda_pipe[2];
      end
  end


// Latch I2C address //
assign latch_adr_en = (csm == sm_adr) & scl_pos;

// Latch I2C command //
assign latch_cmd_en = (csm == sm_cmd) & scl_pos & i2c_adr_match;

// Latch I2C data //
assign latch_dat_en = (csm == sm_dat) & scl_pos & i2c_adr_match & !i2c_rnw;



// Load Address //
assign adr_reg_ld = (csm == sm_adr) & scl_neg & (bit_cnt == 4'd7);


always @(posedge clk or negedge nrst)
  begin
    if (!nrst)
        adr_reg <= # TP 8'h00;
    else if (adr_reg_ld)
        adr_reg <= # TP i2c_reg;
  end



assign i2c_adr_match = (adr_reg[7:1] == I2C_SLAVE_ADDR);

assign i2c_rnw = adr_reg[0];



// Load Offset //
assign cmd_reg_ld        = (csm == sm_cmd_ack) & scl_pos & i2c_adr_match;

assign i2c_data_index_en = i2c_rnw ? ( (csm == sm_dat_ack) & scl_pos & i2c_adr_match )
                                   : ( (csm == sm_dat_ack) & scl_neg & i2c_adr_match );


always @(posedge clk or negedge nrst)
  begin
    if (!nrst)
        cmd_reg <= # TP 8'hff;
    else if (cmd_reg_ld)
        cmd_reg <= # TP i2c_reg;
    else if (i2c_data_index_en)
        //cmd_reg <= # TP cmd_reg + 1'b1;   --> original setting
        //cmd_reg <= # TP cmd_reg;
        cmd_reg <= # TP 8'hff;
  end


assign OFFSET = cmd_reg;


// Load Data //
assign dat_reg_ld = (csm == sm_dat_ack) & scl_pos & i2c_adr_match & !i2c_rnw;


always @(posedge clk or negedge nrst)
  begin
    if (!nrst)
        dat_reg <= # TP 8'h00;
    else if (dat_reg_ld)
        dat_reg <= # TP i2c_reg;
  end


assign DATA_OUT = dat_reg;


// I2C Write Enable , Read Enable //
assign i2c_wren_rden = ( ( (csm == sm_adr_ack) && i2c_rnw ) || (csm == sm_dat_ack) ) & scl_pos & i2c_adr_match;


always @(posedge clk or negedge nrst)
  begin
    if (!nrst)
        i2c_wren <= # TP 3'b000;
    else if (i2c_wren_rden & !i2c_rnw)
        i2c_wren <= # TP 3'b001;
    else
        i2c_wren <= # TP { i2c_wren[1:0], 1'b0 };
  end

always @(posedge clk or negedge nrst)
  begin
    if (!nrst)
        i2c_rden <= # TP 1'b0;
    else if (i2c_wren_rden & i2c_rnw)
        i2c_rden <= # TP 1'b1;
    else
        i2c_rden <= # TP 1'b0;
  end

assign WRITE_EN = i2c_wren[2];
assign READ_EN  = i2c_rden;
assign START    = i2c_start;
assign STOP     = i2c_stop;

//always @(posedge clk or negedge nrst)
//  begin
//    if (!nrst)
//        dat_index <= # TP 8'b0;
//    else if (i2c_start)
//        dat_index <= # TP 8'b0;
//    else if (i2c_data_index_en)
//        dat_index <= # TP dat_index;
//  end

//assign BYTE_INDEX = dat_index;

// I2C read ack //
assign latch_read_ack = (csm == sm_dat_ack) & i2c_rnw & scl_pos & i2c_adr_match;

always @(posedge clk or negedge nrst)
  begin
    if (!nrst)
        i2c_ack <= # TP 1'b1;
    else if (i2c_stop)
        i2c_ack <= # TP 1'b1;
    else if (latch_read_ack)
        i2c_ack <= # TP sda_pipe[2];
  end

// Read data shift register //
assign load_rd_dat = ((csm == sm_adr_ack) || (csm == sm_dat_ack)) && i2c_rnw && scl_neg && i2c_adr_match;

assign shift_reg_en = (csm == sm_dat) && i2c_rnw && scl_neg && i2c_adr_match;

always @(posedge clk or negedge nrst)
  begin
    if (!nrst)
        rd_dat_shift_reg <= # TP 8'h00;
    else if (load_rd_dat)
        rd_dat_shift_reg <= # TP DATA_IN;
    else if (shift_reg_en)
        rd_dat_shift_reg <= # TP {rd_dat_shift_reg[6:0],1'b1};
  end

assign i2c_ack_bit = ((csm == sm_adr_ack) || (csm == sm_cmd_ack) || ((csm == sm_dat_ack) && !i2c_rnw)) & i2c_adr_match;

always @(posedge clk or negedge nrst)
  begin
    if (!nrst)
        sda_i <= # TP 1'b0;
    else if (i2c_ack_bit)
        sda_i <= # TP 1'b1;
    else if ((csm == sm_dat) && i2c_rnw)
        sda_i <= # TP ~rd_dat_shift_reg[7];
    else
        sda_i <= # TP 1'b0;
  end

assign SDA = (sda_i) ? 1'b0 : 1'bz;

//assign SCL = 1'bz;


endmodule