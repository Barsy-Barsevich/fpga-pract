`timescale 1ns / 1ps

module tb_podstava2;

logic clk;
logic rst;
logic [15:0] data_i;
logic valid_i;
logic ready_o;
logic [22:0] data_o;
logic valid_o;
logic ready_i;

podstava2 dut
(
    .clk_i (clk),
    .rst_i (rst),
    
    .data_i (data_i),
    .valid_i (valid_i),
    .ready_o (ready_o),
    .data_o (data_o),
    .valid_o (valid_o),
    .ready_i (ready_i)
);

initial begin
    clk = '0;
    forever #10 clk = ~clk;
end

initial begin
    rst = '1;
    valid_i = '0;
    ready_i = '0;
    #20;
    rst = '0;
    data_i = 16'd3;
    valid_i = '1;
    #150;
    valid_i = '0;
    ready_i = '1;
    #150;
    valid_i = '1;
    ready_i = '0;
    #150;
    valid_i = '0;
    ready_i = '1;
end

endmodule
