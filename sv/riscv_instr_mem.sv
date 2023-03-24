module riscv_instr_mem(
    input logic [31:0] i_addr,
    output logic [31:0] o_instr);

    logic [7:0] memory [0: 4091];

    initial begin
        $readmemh("instr_mem.mem", memory);
    end

    assign o_instr = {memory[i_addr], memory[i_addr+1], memory[i_addr+2], memory[i_addr+3]};

endmodule : riscv_instr_mem