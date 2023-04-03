module riscv_alu(
    input logic [31:0] op_a,
    input logic [31:0] op_b,
    input logic [2:0] alu_control,
    output logic [31:0] o_data,
    output logic zero
);

    always_comb begin
        case(alu_control)
            3'b000: o_data = op_a + op_b;
            3'b001: o_data = op_a - op_b;
            3'b010: o_data = op_a & op_b;
            3'b011: o_data = op_a | op_b;
            3'b101: o_data = (op_a < op_b);
        endcase
    end

    assign zero = (~(|o_data)) ? 1'b1 : 1'b0;


endmodule : riscv_alu