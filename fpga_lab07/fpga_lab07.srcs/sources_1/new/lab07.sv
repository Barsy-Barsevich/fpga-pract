module lab07
(
    input  logic clk_100mhz_i,
    input  logic reset_i,
    input  logic flag_i,
    output logic [4:0] cnt_val_o
);

logic clk_31mhz;
logic clk_65mhz;
logic n_pll_locked;

clk_wiz_0 pll_inst
( 
    .clk_in1 (clk_100mhz_i),
    .clk_out1 (clk_31mhz),
    .clk_out2 (clk_65mhz),
    .reset (reset_i),
    .locked (n_pll_locked)
);

logic clk_a;
logic clk_b;
logic flag_a_ff;
logic flag_b_ff;
logic [4:0] cnt_b;
logic [4:0] cnt_a;

assign clk_a = clk_31mhz & n_pll_locked & ~reset_i;
assign clk_b = clk_65mhz & n_pll_locked & ~reset_i;
assign cnt_val_o = cnt_a;

// Syncronize flag_i & A clock domain
always_ff @(posedge clk_a or posedge reset_i) begin
    if (reset_i)
        flag_a_ff <= '0;
    else
        flag_a_ff <= flag_i;
end

// Resyncronize flag_a to B clock domain
logic dat_a;
always_ff @(posedge clk_a or posedge reset_i) begin
    if (reset_i)
        dat_a <= '0;
    else
        dat_a <= dat_a ^ flag_a_ff;
end
logic [2:0] sync_b;
always_ff @(posedge clk_b or posedge reset_i) begin
    if (reset_i)
        sync_b <= '0;
    else
        sync_b <= {sync_b[1:0], dat_a};
end
assign flag_b_ff = ^sync_b[2:1];

// Increment counter by flag b
always_ff @(posedge flag_b_ff or posedge reset_i) begin
    if (reset_i)
        cnt_b <= '0;
    else
        cnt_b <= cnt_b + 5'd1;
end

always_ff @(posedge clk_a or posedge reset_i) begin
    if (reset_i) 
        cnt_a <= '0;
    else 
        cnt_a <= cnt_b;
end


endmodule