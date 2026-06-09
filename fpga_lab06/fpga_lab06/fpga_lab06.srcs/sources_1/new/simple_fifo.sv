module simple_fifo
#(
  parameter D_WIDTH = 8,
  parameter N = 5
)
(
  input  logic               clk_i,
  input  logic               rstn_i,

  input  logic               push_i,
  input  logic [D_WIDTH-1:0] wdata_i,

  input  logic               pop_i,
  output logic [D_WIDTH-1:0] rdata_o,

  output logic               full_o,
  output logic               empty_o

);

  logic [D_WIDTH-1:0] fifo_mem [(2**$clog2(N))-1:0];
  logic [$clog2(N):0] rptr_ff;
  logic [$clog2(N):0] wptr_ff;

  logic [$clog2(N)-1:0] mem_rptr;
  logic [$clog2(N)-1:0] mem_wptr;

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (~rstn_i)
      wptr_ff <= '0;
    else if (push_i)
      if (wptr_ff == ($clog2(N))'(N-1))
        wptr_ff <= '0;
      else
        wptr_ff <= wptr_ff + 1;
  end

  assign mem_wptr = wptr_ff[$clog2(N)-1:0];

  always_ff @(posedge clk_i) begin
    if (push_i)
      fifo_mem[wptr_ff] <= wdata_i;
  end

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (~rstn_i)
      rptr_ff <= '0;
    else if (pop_i)
      if (rptr_ff == ($clog2(N))'(N-1))
        rptr_ff <= '0;
      else
        rptr_ff <= rptr_ff + 1;
  end

  assign mem_rptr = rptr_ff[$clog2(N)-1:0];
  assign rdata_o = fifo_mem[mem_rptr];

  assign full_o = (rptr_ff[$clog2(N)]     != wptr_ff[$clog2(N)])
                & (rptr_ff[$clog2(N)-1:0] == wptr_ff[$clog2(N)-1:0]);

  assign empty_o = (rptr_ff == wptr_ff);

endmodule