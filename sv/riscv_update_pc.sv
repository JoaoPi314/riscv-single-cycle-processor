module riscv_update_pc(
    input logic clk,
    input logic [31:0] next_pc,
    output logic [31:0] pc
);

    initial begin
        pc = 32'h0000_0000;
    end

    always @(posedge clk) begin
            pc <= next_pc;
    end
    
endmodule : riscv_update_pc