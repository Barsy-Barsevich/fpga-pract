module fifo
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
  localparam PTR_WIDTH = $clog2(N);

  logic [D_WIDTH-1:0] fifo_mem [(2**PTR_WIDTH)-1:0];
  logic [PTR_WIDTH:0] rptr_ff;
  logic [PTR_WIDTH:0] wptr_ff;

  logic [PTR_WIDTH-1:0] mem_rptr;
  logic [PTR_WIDTH-1:0] mem_wptr;

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (~rstn_i)
      wptr_ff <= '0;
    else if (push_i)
      if (wptr_ff == PTR_WIDTH'(N-1))
        wptr_ff <= '0;
      else
        wptr_ff <= wptr_ff + 1;
  end

  assign mem_wptr = wptr_ff[PTR_WIDTH-1:0];

  always_ff @(posedge clk_i) begin
    if (push_i)
      fifo_mem[wptr_ff] <= wdata_i;
  end

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (~rstn_i)
      rptr_ff <= '0;
    else if (pop_i)
      if (rptr_ff == PTR_WIDTH'(N-1))
        rptr_ff <= '0;
      else
        rptr_ff <= rptr_ff + 1;
  end

  assign mem_rptr = rptr_ff[PTR_WIDTH-1:0];
  assign rdata_o = fifo_mem[mem_rptr];

  assign full_o = (rptr_ff[PTR_WIDTH]     != wptr_ff[PTR_WIDTH])
                & (rptr_ff[PTR_WIDTH-1:0] == wptr_ff[PTR_WIDTH-1:0]);

  assign empty_o = (rptr_ff == wptr_ff);

endmodule