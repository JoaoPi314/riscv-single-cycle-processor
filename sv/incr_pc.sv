module incr_pc(
    input logic clk,
    input logic a_rstn,
    input logic [31:0] next_pc,
    output logic [31:0] pc
);

    always_ff @(posedge clk, negedge a_rstn) begin
        if(!a_rstn) begin
            pc <= 32'h0000_0000;
        end else begin
            pc <= next_pc;
        end
    end
    
endmodule : incr_pc