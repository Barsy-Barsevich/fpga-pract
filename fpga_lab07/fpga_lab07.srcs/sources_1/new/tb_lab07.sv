`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2026 03:38:13 PM
// Design Name: 
// Module Name: tb_lab07
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_lab07;
//(
//    input logic clk_i
//);

logic reset;
logic flag;
logic [4:0] counter;
logic clk_i;

lab07 dut
(
    .clk_100mhz_i (clk_i),
    .reset_i (reset),
    .flag_i (flag),
    .cnt_val_o (counter)
);

logic [31:0] i;

initial begin
    clk_i = '0;
    forever #10 clk_i = ~clk_i;
end

initial begin
    flag = '0;
    reset = '1;
    #10;
    reset = '0;
    wait (dut.n_pll_locked);
    #50;
    for (i = 32'd1; i < 32'd5; i += 32'd1) begin
        flag = '1;
        #(40*i);
        flag = '0;
        #(200*i);
    end
end

endmodule
