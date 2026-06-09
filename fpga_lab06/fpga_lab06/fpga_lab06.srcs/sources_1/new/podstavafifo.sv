module podstavafifo
#(
    parameter N,
    parameter DATA_WIDTH = 16
)
(
    input  logic clk_i,
    input  logic rst_i,
    input  logic push,
    input  logic pop,
    output logic empty
);

logic [DATA_WIDTH-1:0] fifo_buf [N];
logic [$clog2(N):0] ptr;

always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        ptr <= '0;
    end
    else if (push & (ptr < N-1)) begin
        ptr = ptr + 1'd1;
        
    end
end

assign empty = ptr == '0;
endmodule
