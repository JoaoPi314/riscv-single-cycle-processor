module riscv_data_mem(
    input logic clk,
    input logic [31:0] i_addr,
    input logic [31:0] w_data,
    input logic w_en,
    output logic [31:0] r_data
);

    logic [7:0] data_memory [0:8191];

    initial begin
        $readmemh("data_mem.mem", data_memory);
    end

    always_comb begin
        if(~w_en)
            r_data = {data_memory[i_addr], data_memory[i_addr+1], data_memory[i_addr+2], data_memory[i_addr+3]};
        else
            r_data = r_data;
    end

    always @(posedge clk) begin
        if(w_en)
            data_memory[i_addr] <= w_data;
        else
            data_memory[i_addr] <= data_memory[i_addr];
    end

endmodule : riscv_data_mem