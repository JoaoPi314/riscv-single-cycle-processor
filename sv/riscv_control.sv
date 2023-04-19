module riscv_control(
    input logic zero,
    input logic [6:0] op,
    input logic [2:0] funct3,
    input logic funct7,
    output logic pc_src,
    output logic [1:0]result_src,
    output logic mem_write,
    output logic alu_src,
    output logic [1:0] imm_src,
    output logic reg_write,
    output logic [2:0] alu_control
);

    logic [1:0] alu_op;
    logic branch;
    logic jump;

    assign pc_src = (branch & zero)|jump;

    // Main decoder
    always_comb begin
        case(op)
            7'b0000_011: begin
                result_src = 2'b01;
                mem_write = 1'b0;
                alu_src = 1'b1;
                imm_src = 2'b00;
                reg_write = 1'b1;
                alu_op = 2'b00;
                branch = 1'b0;
                jump = 1'b0;
            end
            7'b0100_011: begin
                result_src = 2'b00;
                mem_write = 1'b1;
                alu_src = 1'b1;
                imm_src = 2'b01;
                reg_write = 1'b0;
                alu_op = 2'b00;
                branch = 1'b0;
                jump = 1'b0;
            end
            7'b0110_011: begin
                result_src = 2'b00;
                mem_write = 1'b0;
                alu_src = 1'b0;
                imm_src = 2'b01;
                reg_write = 1'b1;
                alu_op = 2'b10;
                branch = 1'b0;
                jump = 1'b0;
            end
            7'b1100_011: begin
                result_src = 2'b00;
                mem_write = 1'b0;
                alu_src = 1'b0;
                imm_src = 2'b10;
                reg_write = 1'b0;
                alu_op = 2'b01;
                branch = 1'b1;
                jump = 1'b0;
            end
            7'b0010_011: begin
                result_src = 2'b00;
                mem_write = 1'b0;
                alu_src = 1'b1;
                imm_src = 2'b00;
                reg_write = 1'b1;
                alu_op = 2'b10;
                branch = 1'b0;
                jump = 1'b0;
            end
            7'b1101_111: begin
                result_src = 2'b10;
                mem_write = 1'b0;
                alu_src = 1'b0;
                imm_src = 2'b11;
                reg_write = 1'b1;
                alu_op = 2'b00;
                branch = 1'b0;
                jump = 1'b1;
            end
        endcase
    end

    // ALU decoder

    always_comb begin
        alu_control = 3'b000;
        case(alu_op)
            2'b01: alu_control = 3'b001;
            2'b10: begin
                case(funct3)
                    3'b000: begin
                        if(~(&{op[5], funct7})) 
                            alu_control = 3'b000;
                        else
                            alu_control = 3'b001; 
                    end
                    3'b010: alu_control = 3'b101;
                    3'b110: alu_control = 3'b011;
                    3'b111: alu_control = 3'b010;
                endcase
            end
        endcase
    end


endmodule : riscv_control