tyepedef enum bit[4:0] { ZERO, RA, SP, GP, TP, T0, T1, T2, S0, S1, A0, A1, A2, A3, A4, A5, A6, A7, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, T3, T4, T5, T6} register_labels;

module register_bank(
    input logic         clk,
    input logic [4:0]   r_op_a,
    input logic [4:0]   r_op_b,
    input logic [4:0]   r_write,
    input logic [31:0]  w_data,
    input logic         w_en,
    output logic [31:0] rd_a,
    output logic [31:0] rd_b
);

    logic [31:0] registers [0:31];

    assign rd_a = registers[r_op_a];
    assign rd_b = registers[r_op_b];

    always@(posedge clk) begin
        if(w_en)
            registers[r_write] <= w_data;
    end

endmodule : register_bank