module riscv_alu(
    input logic [31:0] op_a,
    input logic [31:0] op_b,
    input logic [2:0] alu_control,
    output logic [31:0] o_data
);

    always_comb begin
        case(alu_control)
            3'b000: o_data = op_a + op_b;
        endcase
    end




endmodule : riscv_alu