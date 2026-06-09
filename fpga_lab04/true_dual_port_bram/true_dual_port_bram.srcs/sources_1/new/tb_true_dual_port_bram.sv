`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2026 12:56:45 PM
// Design Name: 
// Module Name: tb_true_dual_port_bram
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


module tb_true_dual_port_bram(

);

logic clk;
logic en_a;
logic en_b;
logic we_a;
logic we_b;
logic [9:0] addr_a;
logic [9:0] addr_b;
logic [7:0] data_a_i;
logic [7:0] data_b_i;
logic [7:0] data_a_o;
logic [7:0] data_b_o;

logic [31:0] i;

true_dual_port_bram dut
(
    .clk_i(clk),
    .en_a_i(en_a),
    .en_b_i(en_b),
    .we_a_i(we_a),
    .we_b_i(we_b),
    .addr_a_i(addr_a),
    .addr_b_i(addr_b),
    .data_a_i(data_a_i),
    .data_b_i(data_b_i),
    .data_a_o(data_a_o),
    .data_b_o(data_b_o)
);

initial begin

    clk = '0;
    en_a = '0;
    en_b = '0;
    we_a = '0;
    we_b = '0;
    addr_a = '0;
    addr_b = '0;
    data_a_i = '0;
    data_b_i = '0;
    
    for (i=0; i<100; i=i+1) begin
        #10;
        clk = 1'b1;
        #10;
        clk = 1'b0;
        if (i == 1) begin
            data_a_i = 8'h55;
            data_b_i = 8'h74;
            en_a = 1'b1;
            en_b = 1'b1;
            we_a = 1'b1;
        end else if (i == 2) begin
            data_a_i = 8'h22;
        end else if (i == 4) begin
            we_a = '0;
            we_b = 1'b1;
            data_a_i = 8'h22;
        end
    end

end

endmodule
