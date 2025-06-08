// CORRECTED ALU WITH PROPER ZERO FLAG
`timescale 1ns/1ps

module alu(
    input wire [31:0] inputA, inputB,
    input wire [2:0] aluop,
    output reg [31:0] result,
    output wire zero
);
    
    always @(*) begin
        case (aluop)
            3'b000: result = 32'b0;                    // NOOP
            3'b001: result = 32'b0;                    // NOOP
            3'b010: result = inputA + inputB;          // ADD
            3'b011: result = inputA - inputB;          // SUB
            3'b100: result = inputA << inputB[4:0];    // SHIFTL (SLL)
            3'b101: result = inputA >> inputB[4:0];    // SHIFTR (SRL)
            3'b110: result = inputA + inputB;          // ADDI (same as ADD)
            3'b111: result = inputA - inputB;          // SUBI (same as SUB)
            default: result = 32'b0;
        endcase
    end
    
    // Zero flag for branch instructions
    assign zero = (result == 32'b0);
    
    // Debug output
    always @(*) begin
        if (aluop != 3'b000) begin // Don't spam with NOOPs
            $display("ALU: %0d op(%0d) %0d = %0d, zero=%b", inputA, aluop, inputB, result, zero);
        end
    end
    
endmodule