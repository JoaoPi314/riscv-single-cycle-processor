`timescale 1ns/1ns

module top;

    logic clk;
    logic a_rstn;

    riscv_datapath datapath(
        .clk(clk),
        .a_rstn(a_rstn)
    );

    initial begin
        clk = 1'b0;
        a_rstn = 1'b1;
        #10 a_rstn = 1'b0;
        #10 a_rstn = 1'b1;

        #100 $finish();
    end

    initial begin
        $dumpfile("waves.vcd");
        $dumpvars;
        // for(int i = 0; i < 32; i++) begin
        //     $dumpvars(1, datapath.register_bank.registers[i]);
        // end
        // for(int i = 0; i < 8192; i++) begin
        //     $dumpvars(1, datapath.data_mem.data_memory[i]);
        // end
    end

    always begin
        #10 clk = ~clk;
    end

endmodule : top