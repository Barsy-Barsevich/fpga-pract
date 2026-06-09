`timescale 1ns/1ps

module tb_pow5_pipelined_valid;

logic clk;
logic reset;
logic [7:0] pow_data_i;
logic data_valid_i;
logic [(5*8)-1:0] pow_data_o;
logic data_valid_o;


pow5_pipelined_valid dut
(
  .clk_i(clk),
  .rst_i(reset),
  .pow_data_i (pow_data_i),
  .data_valid_i (data_valid_i),
  .pow_data_o (pow_data_o),
  .data_valid_o (data_valid_o)
);

logic [31:0] i;
logic [31:0] j;

logic [7:0] input_variables [3] = {
  8'h5,
  8'hFF,
  8'h2
};

initial begin
  data_valid_i = '0;
  clk = '0;
  reset = '1;
  #10;
  reset = '0;
  pow_data_i = 5;
  data_valid_i = '1;
  
  for (i=0; i<3; i+=1) begin
    pow_data_i = input_variables[i];
    for (j=0; j<12; j+=1) begin
      clk ^= '1;
      #10;
    end
  end
        
  $finish;
end

endmodule