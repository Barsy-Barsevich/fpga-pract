module sum_of_quadrats_1
#(
  parameter DATA_WIDTH = 16
)
(
  input logic                         clk_i,
  input logic                         rst_i,
  input logic [DATA_WIDTH-1:0]        a_i,
  input logic                         a_valid_i,
  output logic                        a_ready_o,
  input logic [DATA_WIDTH-1:0]        b_i,
  input logic                         b_valid_i,
  output logic                        b_ready_o,
  input logic [DATA_WIDTH-1:0]        c_i,
  input logic                         c_valid_i,
  output logic                        c_ready_o,
  output logic [(2*DATA_WIDTH+2)-1:0] output_o,
  output logic                        output_valid_o,
  input logic                         output_ready_i
);

logic [DATA_WIDTH-1:0] a_ff;
logic [DATA_WIDTH-1:0] b_ff;
logic [DATA_WIDTH-1:0] c_ff;
logic [2*DATA_WIDTH-1:0] a_quad;
logic [2*DATA_WIDTH-1:0] b_quad;
logic [2*DATA_WIDTH-1:0] c_quad;
logic [2*DATA_WIDTH:0] a_quad_plus_b_quad;
logic [2*DATA_WIDTH+1:0] result;

assign a_quad = a_ff * a_ff;
assign b_quad = b_ff * b_ff;
assign c_quad = c_ff * c_ff;
assign a_quad_plus_b_quad = a_quad + b_quad;
assign result = a_quad_plus_b_quad + c_quad;

logic a_handshake;
logic b_handshake;
logic c_handshake;
logic output_handshake;

assign a_handshake = a_valid_i & a_ready_o;
assign b_handshake = b_valid_i & b_ready_o;
assign c_handshake = c_valid_i & c_ready_o;
assign output_handshake = output_valid_o & output_ready_i;

always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        a_ff <= '0;
        b_ff <= '0;
        c_ff <= '0;
    end
    else begin
        if (a_handshake)
            a_ff <= a_i;
        if (b_handshake)
            b_ff <= b_i;
        if (c_handshake)
            c_ff <= c_i;
    end
end

always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        a_ready_o <= '0;
        b_ready_o <= '0;
        c_ready_o <= '0;
    end
    else begin
        if (a_valid_i)
            a_ready_o <= '1;
        else
            a_ready_o <= '0;
        if (b_valid_i)
            b_ready_o <= '1;
        else
            b_ready_o <= '0;
        if (c_valid_i)
            c_ready_o <= '1;
        else
            c_ready_o <= '0;
    end
end

always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        output_o <= '0;
        output_valid_o <= '0;
    end
    else if (output_ready_i) begin
        output_o <= result;
        output_valid_o <= '1;
    end
end

endmodule
