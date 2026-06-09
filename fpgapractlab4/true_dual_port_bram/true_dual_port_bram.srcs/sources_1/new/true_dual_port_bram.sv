`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2026 11:18:38 AM
// Design Name: 
// Module Name: true_dual_port_bram
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


module true_dual_port_bram
#(
  parameter RAM_WIDTH     = 8,
  parameter RAM_ADDR_BITS = 10
)
(
    input logic clk_i,
    input logic en_a_i,
    input logic en_b_i,
    input logic we_a_i,
    input logic we_b_i,
    input logic [RAM_ADDR_BITS-1:0] addr_a_i,
    input logic [RAM_ADDR_BITS-1:0] addr_b_i,
    input logic [RAM_WIDTH-1:0] data_a_i,
    input logic [RAM_WIDTH-1:0] data_b_i,
    output logic [RAM_WIDTH-1:0] data_a_o,
    output logic [RAM_WIDTH-1:0] data_b_o
);

localparam RAM_DEPTH = 2**RAM_ADDR_BITS;

logic [RAM_WIDTH-1:0] bram [RAM_DEPTH-1:0];

// Port A - Read First
always_ff @(posedge clk_i) begin
    if (en_a_i) begin
        if (we_a_i) begin
            bram[addr_a_i] <= data_a_i;
        end
        data_a_o <= bram[addr_a_i];
    end
end

// Port B - Write First
always_ff @(posedge clk_i) begin
    if (en_b_i) begin
        if (we_b_i) begin
            bram[addr_b_i] <= data_b_i;
            data_b_o <= data_b_i;
        end else begin
            data_b_o <= bram[addr_b_i];
        end
    end
end

endmodule
