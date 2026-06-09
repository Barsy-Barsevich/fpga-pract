module fifo_wrapper
#(
    parameter D_WIDTH = 8,
    parameter N = 5
)
(
  input  logic               clk_i,
  input  logic               rstn_i,

  // Slave port
  input  logic               s_valid_i,
  input  logic [D_WIDTH-1:0] s_data_i,
  output logic               s_ready_o,

  // Master port
  output logic               m_valid_o,
  output logic [D_WIDTH-1:0] m_data_o,
  input  logic               m_ready_i
);

  logic full;
  logic empty;
  logic push;
  logic pop;

  assign push = s_valid_i & ~full;
  assign pop  = m_ready_i & ~empty;

  fifo
  #(
    .D_WIDTH (D_WIDTH),
    .N (N)
  ) i_simple_fifo(
    .clk_i   (clk_i),
    .rstn_i  (rstn_i),

    .push_i  (push),
    .wdata_i (s_data_i),

    .pop_i   (pop),
    .rdata_o (m_data_o),

    .full_o  (full),
    .empty_o (empty)
  );

  assign s_ready_o = ~full;
  assign m_valid_o = ~empty;

endmodule