module sum_of_quadrats_2
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
logic a_handshake;
logic b_handshake;
logic c_handshake;
logic output_handshake;

assign a_handshake = a_valid_i & a_ready_o;
assign b_handshake = b_valid_i & b_ready_o;
assign c_handshake = c_valid_i & c_ready_o;
assign output_handshake = output_valid_o & output_ready_i;

// Set inputs readies
always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        a_ready_o <= '0;
    end
    else if (a_valid_i) begin
        a_ready_o <= '1;
    end
end
always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        b_ready_o <= '0;
    end
    else if (b_valid_i) begin
        b_ready_o <= '1;
    end
end
always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        c_ready_o <= '0;
    end
    else if (c_valid_i) begin
        c_ready_o <= '1;
    end
end

// Set inputs FFs
always_ff @(posedge clk_i) begin
    if (a_handshake) begin
        a_ff <= a_i;
    end
    if (b_handshake) begin
        b_ff <= b_i;
    end
    if (c_handshake) begin
        c_ff <= c_i;
    end
end

// Set outputs valid
assign output_valid_o = a_ready_o & b_ready_o & c_ready_o;

always_ff @(posedge clk_i) begin
    if (output_handshake) begin
        a_quad = a_ff * a_ff;
        b_quad = b_ff * b_ff;
        c_quad = c_ff * c_ff;
        a_quad_plus_b_quad = a_quad + b_quad;
        output_o = a_quad_plus_b_quad + c_quad;
    end
end

endmodule
