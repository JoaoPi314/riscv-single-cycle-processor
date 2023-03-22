`timescale 1ns/1ns

module top;

    logic clk;
    logic a_rstn;
    int seed = 1;
    logic [31:0] next_pc, pc;
    logic [31:0] output_instr;
    logic [31:0] aux;

    incr_pc pc_incr(.clk(clk), .a_rstn(a_rstn), .next_pc(next_pc), .pc(pc));
    instr_mem mem_instr(.i_addr(pc), .o_instr(output_instr));

    initial begin
        clk = 1'b0;
        a_rstn = 1'b1;
        #10 a_rstn = 1'b0;
        #10 a_rstn = 1'b1;

        #1000 $finish();
    end

    always@(posedge clk) begin 
        aux = $random(seed);
        next_pc <= (aux % 4092) + (4 - (aux%4));
    end


    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, pc_incr);
        $dumpvars(0, mem_instr);

    end

    always begin
        #10 clk = ~clk;
    end

endmodule : top