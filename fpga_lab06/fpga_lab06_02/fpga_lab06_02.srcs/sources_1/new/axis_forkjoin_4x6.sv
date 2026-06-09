module axis_forkjoin_4x6
#(
    parameter TDATA_WIDTH = 8
)
(
    input  logic [TDATA_WIDTH-1:0] s0_data_i,
    input  logic                   s0_valid_i,
    output logic                   s0_ready_o,

    input  logic [TDATA_WIDTH-1:0] s1_data_i,
    input  logic                   s1_valid_i,
    output logic                   s1_ready_o,

    input  logic [TDATA_WIDTH-1:0] s2_data_i,
    input  logic                   s2_valid_i,
    output logic                   s2_ready_o,

    input  logic [TDATA_WIDTH-1:0] s3_data_i,
    input  logic                   s3_valid_i,
    output logic                   s3_ready_o,

    output logic [TDATA_WIDTH-1:0] m0_data_o,
    output logic                   m0_valid_o,
    input  logic                   m0_ready_i,

    output logic [TDATA_WIDTH-1:0] m1_data_o,
    output logic                   m1_valid_o,
    input  logic                   m1_ready_i,

    output logic [TDATA_WIDTH-1:0] m2_data_o,
    output logic                   m2_valid_o,
    input  logic                   m2_ready_i,

    output logic [TDATA_WIDTH-1:0] m3_data_o,
    output logic                   m3_valid_o,
    input  logic                   m3_ready_i,

    output logic [TDATA_WIDTH-1:0] m4_data_o,
    output logic                   m4_valid_o,
    input  logic                   m4_ready_i,

    output logic [TDATA_WIDTH-1:0] m5_data_o,
    output logic                   m5_valid_o,
    input  logic                   m5_ready_i
);

logic [3:0] s_req;
logic [3:0] s_grant;
logic [5:0] m_req;
logic [5:0] m_grant;

assign s_req =
{
    s3_valid_i,
    s2_valid_i,
    s1_valid_i,
    s0_valid_i
};

assign m_req = 
{
    m5_ready_i,
    m4_ready_i,
    m3_ready_i,
    m2_ready_i,
    m1_ready_i,
    m0_ready_i    
};

always_comb begin
    casez (s_req[3:0])
        4'b???1 : s_grant = 4'b0001;
        4'b??10 : s_grant = 4'b0010;
        4'b?100 : s_grant = 4'b0100;
        4'b1000 : s_grant = 4'b1000;
        4'b0000 : s_grant = 4'b0000;
    endcase
end

always_comb begin
    casez (m_req[5:0])
        6'b?????1 : m_grant = 6'b000001;
        6'b????10 : m_grant = 6'b000010;
        6'b???100 : m_grant = 6'b000100;
        6'b??1000 : m_grant = 6'b001000;
        4'b?10000 : m_grant = 6'b010000;
        6'b100000 : m_grant = 6'b100000;
        6'b000000 : m_grant = 6'b000000;
    endcase
end

logic m_tvalid, s_tready;

assign m_tvalid = |s_grant;
assign s_tready = |m_grant;

logic [TDATA_WIDTH-1:0] data;

always_comb begin 
    case (s_grant)
        4'b0001: data = s0_data_i;
        4'b0010: data = s1_data_i;
        4'b0100: data = s2_data_i;
        4'b1000: data = s3_data_i;
        default: data = s0_data_i;
    endcase
end

assign m0_data_o = data;
assign m1_data_o = data;
assign m2_data_o = data;
assign m3_data_o = data;
assign m4_data_o = data;
assign m5_data_o = data;

assign m0_valid_o = m_tvalid & (m_grant == 6'b000001);
assign m1_valid_o = m_tvalid & (m_grant == 6'b000010);
assign m2_valid_o = m_tvalid & (m_grant == 6'b000100);
assign m3_valid_o = m_tvalid & (m_grant == 6'b001000);
assign m4_valid_o = m_tvalid & (m_grant == 6'b010000);
assign m5_valid_o = m_tvalid & (m_grant == 6'b100000);

assign s0_ready_o = s_tready & (s_grant == 4'b0001);
assign s1_ready_o = s_tready & (s_grant == 4'b0010);
assign s2_ready_o = s_tready & (s_grant == 4'b0100);
assign s3_ready_o = s_tready & (s_grant == 4'b1000);

endmodule
