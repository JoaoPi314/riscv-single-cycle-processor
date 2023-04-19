module riscv_datapath(
    input logic clk, 
    input logic a_rstn,
    input logic [2:0] alu_control,
    input logic alu_src,
    input logic reg_write,
    input logic [1:0] imm_src,
    input logic mem_write,
    input logic [2:0] result_src,
    input logic pc_src,
    output logic zero,
    output logic [6:0] op,
    output logic [2:0]funct3,
    output logic funct7
);

    logic [31:0] pc;
    logic [31:0] next_pc;

    logic [31:0] instr;
    
    logic [31:0] imm_extend;
    logic [31:0] r_output_a;
    logic [31:0] r_output_b;
    logic [31:0] alu_input_b;
    logic [31:0] alu_output;
    logic [31:0] r_input_write;
    logic [31:0] data_mem_output;
    logic [31:0] pc_target;
    logic [31:0] pc_plus_4;

    // Assign output to control unit
    always_comb begin
        op = instr[6:0];
        funct3 = instr[14:12];
        funct7 = instr[30];
    end

    // Update PC register
    riscv_update_pc update_pc(
        .clk(clk),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Increment PC register
    always_comb begin
        pc_plus_4 = pc + 4;
    end

    // Instruction memory
    riscv_instr_mem instr_mem(
        .i_addr(pc),
        .o_instr(instr)
    );

    // Resgiter bank
    riscv_register_bank register_bank(
        .clk(clk),
        .r_op_a(instr[19:15]),
        .r_op_b(instr[24:20]),
        .r_write(instr[11:7]),
        .w_data(r_input_write),
        .w_en(reg_write),
        .rd_a(r_output_a),
        .rd_b(r_output_b)
    );

    // Extend immediate
    always_comb begin
        imm_extend = 31'h0000_0000;
        case(imm_src)
            2'b00: imm_extend = {{20{instr[31]}}, instr[31:20]};
            2'b01: imm_extend = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            2'b10: imm_extend = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            2'b11: imm_extend = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
        endcase
            
    end

    // Mux to select register o immediate to ALU
    always_comb begin
        if(alu_src)
            alu_input_b = imm_extend;
        else
            alu_input_b = r_output_b;
    end

    // ALU
    riscv_alu alu(
        .op_a(r_output_a),
        .op_b(alu_input_b),
        .alu_control(alu_control),
        .o_data(alu_output),
        .zero(zero)
    );

    // Mux to select register output from alu or memory
    always_comb begin
        case(result_src)
            2'b00: r_input_write = alu_output;
            2'b01: r_input_write = data_mem_output;
            2'b10: r_input_write = pc_plus_4;
        endcase
    end

    // Data memory
    riscv_data_mem data_mem(
        .clk(clk),
        .i_addr(alu_output),
        .w_data(r_output_b),
        .w_en(mem_write),
        .r_data(data_mem_output)
    );


    // Branch adder
    always_comb begin
        pc_target = pc + imm_extend;
    end
    
    // Mux to select PC from branch or normal increment
    always_comb begin
        case(pc_src)
            1'b0: next_pc = pc_plus_4;
            1'b1: next_pc = pc_target;
        endcase
    end

endmodule : riscv_datapath