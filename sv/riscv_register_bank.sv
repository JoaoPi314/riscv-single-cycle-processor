module riscv_register_bank(
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

    initial begin
        registers[0] = 32'h0000_0000;
        registers[1] = 32'hCAFE_F0DA;
        registers[2] = 32'hCAFE_F0DA;
        registers[3] = 32'hCAFE_F0DA;
        registers[4] = 32'hFFFF_0000;
        registers[5] = 32'h0000_FFFF;
        registers[6] = 32'hCAFE_F0DA;
        registers[7] = 32'hDEAD_B0DE;
        registers[8] = 32'hDEAD_B0DE;
        registers[9] = 32'h0000_1004;
        registers[10] = 32'hDEAD_B0DE;
        registers[11] = 32'hDEAD_B0DE;
        registers[12] = 32'hDEAD_B0DE;
        registers[13] = 32'hF0DA_DEAD;
        registers[14] = 32'hF0DA_DEAD;
        registers[15] = 32'hF0DA_DEAD;
        registers[16] = 32'hF0DA_DEAD;
        registers[17] = 32'hF0DA_DEAD;
        registers[18] = 32'hF0DA_DEAD;
        registers[19] = 32'hF0DA_F0DA;
        registers[20] = 32'hF0DA_F0DA;
        registers[21] = 32'hF0DA_F0DA;
        registers[22] = 32'hF0DA_F0DA;
        registers[23] = 32'hF0DA_F0DA;
        registers[24] = 32'hF0DA_F0DA;
        registers[25] = 32'hDEAD_DEAD;
        registers[26] = 32'hDEAD_DEAD;
        registers[27] = 32'hDEAD_DEAD;
        registers[28] = 32'hDEAD_DEAD;
        registers[29] = 32'hDEAD_DEAD;
        registers[30] = 32'hDEAD_DEAD;
        registers[31] = 32'hFFFF_FFFF;
    end


    assign rd_a = registers[r_op_a];
    assign rd_b = registers[r_op_b];

    always@(posedge clk) begin
        if(w_en && r_write)
            registers[r_write] <= w_data;
        else
            registers[r_write] <= registers[r_write];
    end

endmodule : riscv_register_bank