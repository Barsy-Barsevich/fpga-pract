module stage3
#(
    parameter D_WIDTH_I
)
(
    input  logic                 clk_i,
    input  logic                 rst_i,
    input  logic [D_WIDTH_I-1:0] data_i,
    output logic [D_WIDTH_I+3:0] data_o,
    input  logic                 valid_i,
    output logic                 ready_o
);

// *=9

logic handshake;

assign handshake = valid_i & ready_o;

always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        ready_o <= '0;
    end
    else begin
        ready_o <= '1;
    end
end

always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        data_o <= '0;
    end
    else if (handshake) begin
        data_o <= data_i * 4'd9;
    end
end

endmodule
