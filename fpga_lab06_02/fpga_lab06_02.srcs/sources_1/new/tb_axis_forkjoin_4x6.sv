`timescale 1ns / 1ps

module tb_axis_forkjoin_4x6;

logic       clk;
logic [7:0] i_data [4];
logic       i_valid [4];
logic       i_ready [4];
logic [7:0] o_data[6];
logic       o_valid[6];
logic       o_ready[6];

axis_forkjoin_4x6
#(
    .TDATA_WIDTH (8)
) dut (
    .s0_data_i  (i_data [0]),
    .s0_valid_i (i_valid[0]),
    .s0_ready_o (i_ready[0]),
    .s1_data_i  (i_data [1]),
    .s1_valid_i (i_valid[1]),
    .s1_ready_o (i_ready[1]),
    .s2_data_i  (i_data [2]),
    .s2_valid_i (i_valid[2]),
    .s2_ready_o (i_ready[2]),
    .s3_data_i  (i_data [3]),
    .s3_valid_i (i_valid[3]),
    .s3_ready_o (i_ready[3]),
    .m0_data_o  (o_data [0]),
    .m0_valid_o (o_valid[0]),
    .m0_ready_i (o_ready[0]),
    .m1_data_o  (o_data [1]),
    .m1_valid_o (o_valid[1]),
    .m1_ready_i (o_ready[1]),
    .m2_data_o  (o_data [2]),
    .m2_valid_o (o_valid[2]),
    .m2_ready_i (o_ready[2]),
    .m3_data_o  (o_data [3]),
    .m3_valid_o (o_valid[3]),
    .m3_ready_i (o_ready[3]),
    .m4_data_o  (o_data [4]),
    .m4_valid_o (o_valid[4]),
    .m4_ready_i (o_ready[4]),
    .m5_data_o  (o_data [5]),
    .m5_valid_o (o_valid[5]),
    .m5_ready_i (o_ready[5])
);

initial begin
    clk = '0;
    forever #5 clk = ~clk;
end

logic [31:0] i;

initial begin
    for (i=0; i<6; i+=1) begin
        if (i < 4) begin
            i_data[i] = '0;
            i_valid[i] = '0;
        end
        o_ready[i] = '0;
    end
    @(posedge clk);
    i_data[1] = 8'h12;
    i_data[3] = 8'h34;
    i_valid[1] = '1;
    i_valid[3] = '1;
    
    @(posedge clk);
    o_ready[1] = '1;
    o_ready[4] = '1;
    
    @(posedge clk);
    o_ready[1] = '1;
    o_ready[2] = '1;
    o_ready[4] = '1;
    
    @(posedge clk);
    o_ready[0] = '1;
    o_ready[1] = '1;
    o_ready[2] = '1;
    o_ready[4] = '1;
    
    @(posedge clk)
    i_valid[1] = '0;
end

endmodule
