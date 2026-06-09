module stage4
#(
    parameter D_WIDTH_I
)
(
    input  logic                 clk_i,
    input  logic                 rst_i,
    input  logic [D_WIDTH_I-1:0] data_i,
    output logic [D_WIDTH_I:0]   data_o,
    input  logic                 valid_i,
    output logic                 ready_o
);

// +=76

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
        data_o <= data_i + (D_WIDTH_I)'(76);
    end
end

endmodule
