module data_mem(
    input logic clk,
    input logic [31:0] i_addr,
    input logic [31:0] w_data,
    input logic w_en,
    output logic [31:0] r_data
);

    logic [31:0] data_memory [0:8191];

    initial begin
        $readmemh("data_mem.mem", memory);
    end


    always_comb begin
        if(~w_en)
            r_data = data_memory[i_addr];
        else
            r_data = r_data;
    end

    always @(posedge clk) begin
        if(w_en)
            memory[i_addr] <= w_data;
        else
            memory[i_addr] <= memory[i_addr];
    end

endmodule : data_mem