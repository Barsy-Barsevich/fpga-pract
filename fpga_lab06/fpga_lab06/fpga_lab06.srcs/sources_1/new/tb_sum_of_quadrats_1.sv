`timescale 1ns / 1ps

module tb_sum_of_quadrats_1;

logic clk;
logic reset;
logic a_valid, b_valid, c_valid, out_valid;
logic a_ready, b_ready, c_ready, out_ready;
logic [15:0] a;
logic [15:0] b;
logic [15:0] c;
logic [33:0] out;


sum_of_quadrats_2 dut
(
    .clk_i          (clk),
    .rst_i          (reset),
    .a_i            (a),
    .a_valid_i      (a_valid),
    .a_ready_o      (a_ready),
    .b_i            (b),
    .b_valid_i      (b_valid),
    .b_ready_o      (b_ready),
    .c_i            (c),
    .c_valid_i      (c_valid),
    .c_ready_o      (c_ready),
    .output_o       (out),
    .output_valid_o (out_valid),
    .output_ready_i (out_ready)
);

initial begin
    clk = '0;
    forever #5 clk = ~clk;
end

initial begin
    reset = '1;
    a_valid = '0;
    b_valid = '0;
    c_valid = '0;
    out_ready = '0;
    #50;
    reset = '0;
    
    a = 16'd3;
    a_valid = '1;
    wait (a_ready);
    @(posedge clk);
    a_valid = '0;
    #10;
    b = 16'd4;
    b_valid = '1;
    wait (b_ready);
    @(posedge clk);
    b_valid = '0;
    #10;
    c = 16'd5;
    c_valid = '1;
    wait (c_ready);
    @(posedge clk);
    c_valid = '0;
    #20;
    out_ready = '1;
    wait (out_valid);
    @(posedge clk);
    out_ready = '0;
    
    #40;
    a = 16'd6;
    a_valid = '1;
    #10;
    b = 16'd7;
    b_valid = '1;
    #10;
    c = 16'd8;
    c_valid = '1;
    #20;
    out_ready = '1;
end

endmodule
