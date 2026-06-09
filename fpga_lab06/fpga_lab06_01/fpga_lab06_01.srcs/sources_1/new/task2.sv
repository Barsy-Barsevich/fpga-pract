module task2
#(
    parameter D_WIDTH = 16
)
(
    input  logic               clk_i,
    input  logic               rst_i,
    input  logic [D_WIDTH-1:0] data_i,
    output logic [9:0]         data_o,
    input  logic               valid_i,
    output logic               valid_o,
    input  logic               ready_i,
    output logic               ready_o
);

logic [D_WIDTH+0:0] data_stage1;
logic [D_WIDTH+1:0] data_stage2;
logic [D_WIDTH+5:0] data_stage3;
logic [D_WIDTH+6:0] data_stage4;
logic [9:0] data_stage5;
logic pipeline_valid;
logic stage1_valid;
logic stage2_valid;
logic stage3_valid;
logic stage4_valid;
logic stage5_valid;
logic credit_return;
logic fifo_full;
logic fifo_empty;
logic [2:0] credit_counter;


stage1
#(
    .D_WIDTH_I (D_WIDTH)
) s1 (
    .clk_i (clk_i),
    .rst_i (rst_i),
    .data_i (data_i),
    .data_o (data_stage1),
    .valid_i (pipeline_valid),
    .ready_o (stage1_valid)
);

stage2
#(
    .D_WIDTH_I (D_WIDTH+1)
) s2 (
    .clk_i (clk_i),
    .rst_i (rst_i),
    .data_i (data_stage1),
    .data_o (data_stage2),
    .valid_i (stage1_valid),
    .ready_o (stage2_valid)
);

stage3
#(
    .D_WIDTH_I (D_WIDTH+2)
) s3 (
    .clk_i (clk_i),
    .rst_i (rst_i),
    .data_i (data_stage2),
    .data_o (data_stage3),
    .valid_i (stage2_valid),
    .ready_o (stage3_valid)
);

stage4
#(
    .D_WIDTH_I (D_WIDTH+6)
) s4 (
    .clk_i (clk_i),
    .rst_i (rst_i),
    .data_i (data_stage3),
    .data_o (data_stage4),
    .valid_i (stage3_valid),
    .ready_o (stage4_valid)
);

stage5
#(
    .D_WIDTH_I (D_WIDTH+6)
) s5 (
    .clk_i (clk_i),
    .rst_i (rst_i),
    .data_i (data_stage4),
    .data_o (data_stage5),
    .valid_i (stage4_valid),
    .ready_o (stage5_valid)
);

fifo
#(
    .D_WIDTH (10),
    .N (50)
) this_fifo (
    .clk_i (clk_i),
    .rstn_i (~rst_i),
    .push_i (stage5_valid),
    .wdata_i (data_stage5),
    .pop_i (credit_return),
    .rdata_o (data_o),
    .full_o (fifo_full),
    .empty_o (fifo_empty)
);

assign valid_o = ~fifo_empty;
assign credit_return = ready_i & valid_o;
assign pipeline_valid = valid_i & ready_o;
assign ready_o = (credit_counter != '0);

always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        credit_counter <= 3'd5;
    end
    else if (credit_return) begin
        credit_counter <= credit_counter - 3'd1;
    end
    else if (pipeline_valid) begin
        credit_counter <= credit_counter + 3'd1;
    end
end

endmodule
