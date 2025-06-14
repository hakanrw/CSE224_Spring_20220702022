// CORRECTED PROGRAM COUNTER WITH DEBUG
`timescale 1ns/1ps

module program_counter(
    input wire clk,
    input wire reset,
    input wire control,
    input wire jump,
    input wire branch,
    input wire [31:0] jump_address,
    input wire [31:0] branch_address,
    output reg [31:0] pc
);
    
    always @(posedge clk) begin
        if (reset) begin
            pc <= 32'b0;
            $display("PC RESET to 0");
        end else if (control) begin
            if (jump) begin
                pc <= jump_address;
                $display("PC JUMP to %0d", jump_address);
            end else if (branch) begin
                pc <= pc + branch_address;  // PC-relative branch
                $display("PC BRANCH to %0d (PC + %0d)", pc + branch_address, branch_address);
            end else begin
                pc <= pc + 1;
                $display("PC INCREMENT to %0d", pc + 1);
            end
        end
    end
    
    // Initialize PC
    initial begin
        pc = 32'b0;
    end
    
endmodule