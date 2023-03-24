module riscv_datapath(input logic clk, input logic a_rstn);

    
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


    // Controls
    logic [2:0] alu_control;
    logic       alu_src;
    logic       reg_write;
    logic       imm_src;
    logic       mem_write;
    logic       result_src;


    initial begin
        alu_control = 3'b000;
        reg_write = 1'b1;
        mem_write = 1'b0;
        imm_src = 1'b0;
        alu_src = 1'b1;
        result_src = 1'b1;
        @(posedge clk);
        imm_src = 1'b1;
        mem_write = 1'b1;
        @(posedge clk);
        alu_control = 3'b011;
        alu_src = 0;
        mem_write = 1'b0;
        result_src = 1'b0;
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
        .r_op_b(instr[24:20]),
        .r_write(instr[11:7]),
        .w_data(r_input_write),
        .w_en(reg_write),
        .rd_a(r_output_a),
        .rd_b(r_output_b)
    );

    // Extend immediate
    always_comb begin
        if(imm_src)
            imm_extend = {{24{instr[31]}}, instr[31:25], instr[11:7]};
        else
            imm_extend = {{24{instr[31]}}, instr[31:20]};
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
        .o_data(alu_output)
    );

    // Mux to select register output from alu or memory
    always_comb begin
        if(result_src)
            r_input_write = data_mem_output;
        else
            r_input_write = alu_output;
    end

    // Data memory
    riscv_data_mem data_mem(
        .clk(clk),
        .i_addr(alu_output),
        .w_data(r_output_b),
        .w_en(mem_write),
        .r_data(data_mem_output)
    );
    

endmodule : riscv_datapath