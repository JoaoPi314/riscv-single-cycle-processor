module riscv_datapath(input logic clk, input logic a_rstn);

    
    logic [31:0] pc;
    logic [31:0] next_pc;

    logic [31:0] instr;
    
    logic [31:0] imm_extend;
    logic [31:0] r_output_a;
    logic [31:0] alu_output;
    logic [31:0] data_mem_output;

    // Controls
    logic [2:0] alu_control;
    logic       reg_write;
    logic       imm_src;
    logic       mem_write;


    initial begin
        alu_control = 3'b000;
        reg_write = 1'b1;
        mem_write = 1'b0;
        @(posedge clk);
    end

    // Update PC register
    riscv_update_pc update_pc(
        .clk(clk),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Increment PC register
    always_comb begin
        next_pc = pc + 4;
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
        .r_write(instr[11:7]),
        .w_data(data_mem_output),
        .w_en(reg_write),
        .rd_a(r_output_a)
    );

    // Extend immediate
    assign imm_extend = {{24{instr[31]}}, instr[31:20]};

    // ALU
    riscv_alu alu(
        .op_a(r_output_a),
        .op_b(imm_extend),
        .alu_control(alu_control),
        .o_data(alu_output)
    );

    // Data memory
    riscv_data_mem data_mem(
        .clk(clk),
        .i_addr(alu_output),
        .w_en(mem_write),
        .r_data(data_mem_output)
    );
    

endmodule : riscv_datapath