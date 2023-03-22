`timescale 1ns/1ns

module top;

    logic clk;
    logic a_rstn;
    int seed = 1;
    logic [31:0] next_pc, pc;

    incr_pc pc_incr(.clk(clk), .a_rstn(a_rstn), .next_pc(next_pc), .pc(pc));

    initial begin
        clk = 1'b0;
        a_rstn = 1'b1;
        #10 a_rstn = 1'b0;
        #10 a_rstn = 1'b1;

        #1000 $finish();
    end

    always@(posedge clk) begin 
        next_pc <= $random(seed);
    end


    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, pc_incr);
    end

    always begin
        #10 clk = ~clk;
    end

endmodule : top