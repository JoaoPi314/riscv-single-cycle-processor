module riscv_cpu(input logic clk, input logic a_rstn);

    //Datapath signals
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

    // Control signals
    logic [2:0] alu_control;
    logic alu_src;
    logic reg_write;
    logic [1:0] imm_src;
    logic mem_write;
    logic result_src;
    logic pc_src;
    logic zero;
    logic [6:0] op;
    logic [2:0] funct3;
    logic funct7;

    // control unit
     // Control
    riscv_control control(
        .zero(zero),
        .op(op),
        .funct3(funct3),
        .funct7(funct7),
        .pc_src(pc_src),
        .result_src(result_src),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .imm_src(imm_src),
        .reg_write(reg_write),
        .alu_control(alu_control)
    );

    //Datapath
    riscv_datapath datapath(
        .clk(clk),
        .a_rstn(a_rstn),
        .alu_control(alu_control),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .imm_src(imm_src),
        .mem_write(mem_write),
        .result_src(result_src),
        .pc_src(pc_src),
        .zero(zero),
        .op(op),
        .funct3(funct3),
        .funct7(funct7)
    );

endmodule : riscv_cpu