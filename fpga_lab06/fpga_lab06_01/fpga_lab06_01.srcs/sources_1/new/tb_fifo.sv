`timescale 1ns / 1ps

module tb_fifo;

logic clk;
logic rst;
logic fifo_push;
logic fifo_pop;
logic fifo_empty;
logic fifo_full;
logic [21:0] fifo_data_i;
logic [21:0] fifo_data_o;

fifo
#(
    .D_WIDTH (22),
    .N (5)
) dut (
    .clk_i (clk),
    .rstn_i (~rst),
    .push_i (fifo_push),
    .wdata_i (fifo_data_i),
    .pop_i (fifo_pop),
    .rdata_o (fifo_data_o),
    .full_o (fifo_full),
    .empty_o (fifo_empty)
);

initial begin
    clk = '0;
    forever #10 clk = ~clk;
end

initial begin
    rst = '1;
    fifo_push = '0;
    fifo_pop = '0;
    fifo_data_i = '0;
    #20;
    rst = '0;
    fifo_data_i = 22'd1;
    fifo_push = '1;
    #20;
    fifo_data_i = 22'd2;
    #20;
    fifo_data_i = 22'd3;
    #20;
    fifo_data_i = 22'd4;
    #20;
    fifo_data_i = 22'd5;
    #20;
    fifo_push = '0;
    fifo_pop = '1;
    fifo_data_i = 22'd6;
    #20;
    fifo_push = '0;
end

endmodule
