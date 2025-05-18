
//////////////////////////////////////////////////////////////////////////////////
// Company: Yeditepe University
// Engineer: Hakan Candar, Egemen Aybir, Berk Tahir Kilic
//
// Create Date: 18.05.2025 21:54:07
// Design Name:
// Module Name: project_assignment_4
// Project Name:
// Target Devices: basys
// Tool Versions:
// Description:
//
// Dependencies: OpenLane
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module project_assignment_4 (
    input wire [31:0] inputA, inputB,
    input wire [1:0] opcode,
    input wire clk,
    output reg [31:0] result
);
    // ALU operations based on opcode
    always @(*) begin
        case (opcode)
            2'b00: result = inputA + inputB;       // ADD
            2'b01: result = inputA - inputB;       // SUB
            2'b10: result = inputA << inputB;      // SHIFTL
            2'b11: result = inputA >> inputB;      // SHIFTR
            default: result = 32'b0;
        endcase
    end
endmodule
