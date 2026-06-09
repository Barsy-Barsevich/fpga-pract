`timescale 1ns/1ps

module tb_syst_ws;

logic clk;
logic rst;

logic [7:0] x1_i;
logic [7:0] x2_i;
logic [7:0] x3_i;

logic [18:0] y1_o;
logic [18:0] y2_o;

logic [31:0] i;

syst_ws dut
(
  .clk_i (clk),
  .rst_i (rst),
  .x1_i  (x1_i),
  .x2_i  (x2_i),
  .x3_i  (x3_i),
  .y1_o  (y1_o),
  .y2_o  (y2_o)
);

initial begin
  clk = '0;
  rst = '1;
  #10;
  clk = '1;
  #10;
  clk = '0;
  #10;
  rst = '0;
  
  x1_i = 8'd1;
  x2_i = 8'd1;
  x3_i = 8'd1;
  
  for (i='0; i<32'd50; i+=32'd1) begin
    clk ^= '1;
    #10;
  end
  
  $finish;
end

endmodule