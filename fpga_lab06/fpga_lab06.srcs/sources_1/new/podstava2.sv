module podstava2
#(
    parameter DATA_WIDTH = 16,
    parameter N = 5
)
(
    input  logic clk_i,
    input  logic rst_i,
    
    input  logic [DATA_WIDTH-1:0] data_i,
    input  logic valid_i,
    output logic ready_o,
    
    output logic [DATA_WIDTH-1:0] data_o,
    output logic valid_o,
    input logic  ready_i
);

// (1) -=2
// (2) += (-3)
// (3) *= 9
// (4) += 76
// (5) %= 1024

logic [DATA_WIDTH+0:0] data_stage_1;
logic [DATA_WIDTH+1:0] data_stage_2;
logic [DATA_WIDTH+5:0] data_stage_3;
logic [DATA_WIDTH+6:0] data_stage_4;
logic [DATA_WIDTH+6:0] data_stage_5;

logic [DATA_WIDTH+0:0] data_stage_1_prev1;
logic [DATA_WIDTH+0:0] data_stage_1_prev2;
logic [DATA_WIDTH+0:0] data_stage_1_prev3;

logic [2:0] credit_counter;
logic pipeline_enable;
logic credit_return;

logic [DATA_WIDTH+6:0] fifo_data_i;
logic [DATA_WIDTH+6:0] fifo_data_o;
logic fifo_push;
logic fifo_pop;
logic fifo_empty;
logic fifo_full;

assign ready_o = credit_counter != '0;
assign pipeline_enable = valid_i & (credit_counter != '0);
assign credit_return = ready_i & valid_o;

always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        data_stage_1_prev1 <= '0;
        data_stage_1_prev2 <= '0;
        data_stage_1_prev3 <= '0;
    end
    else if (pipeline_enable) begin
        data_stage_1_prev3 <= data_stage_1_prev2;
        data_stage_1_prev2 <= data_stage_1_prev1;
        data_stage_1_prev1 <= data_stage_1;
        
        data_stage_1 <= data_i - (DATA_WIDTH)'(2);
        data_stage_2 <= data_stage_1 + data_stage_1_prev3;
        data_stage_3 <= data_stage_2 * 9;
        data_stage_4 <= data_stage_3 + (DATA_WIDTH+5)'(76);
        data_stage_5 <= data_stage_4 % (DATA_WIDTH+6)'(1024);
    end
end

assign fifo_data_i = data_stage_5;
assign fifo_push = pipeline_enable;
assign data_o = fifo_data_o;
assign valid_o = ~fifo_empty;
assign fifo_pop = credit_return;

always_ff @(posedge rst_i or posedge clk_i) begin
    if (rst_i) begin
        credit_counter <= N;
    end
    else if (pipeline_enable) begin
        credit_counter <= credit_counter - 1'd1;
    end
    else if (credit_return) begin
        credit_counter <= credit_counter + 1'd1;
    end
end

//FIFO
simple_fifo
#(
    .D_WIDTH (DATA_WIDTH+6+1),
    .N (N)
) fifo (
    .clk_i (clk_i),
    .rstn_i (~rst_i),
    .push_i (fifo_push),
    .wdata_i (fifo_data_i),
    .pop_i (fifo_pop),
    .rdata_o (fifo_data_o),
    .full_o (fifo_full),
    .empty_o (fifo_empty)
);

endmodule
