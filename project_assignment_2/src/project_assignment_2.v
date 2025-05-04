
//////////////////////////////////////////////////////////////////////////////////
// Company: Yeditepe University
// Engineer: Hakan Candar, Egemen Aybir, Berk Tahir Kilic
// 
// Create Date: 04.05.2025 19:04:00
// Design Name: 
// Module Name: calculator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module project_assignment_2 (
    input [7:0] A, 
    input [7:0] B, 
    input [2:0] opcode, 
    output reg [7:0] out,
    input clk
);

    always @(*) begin
        case(opcode)
            3'b000: out = A + B;     
            3'b001: out = A - B;     
            3'b010: out = A & B;      
            3'b011: out = A | B;       
            3'b100: out = A ^ B;       
            3'b101: out = ~A;            
            default: out = 8'b0; 
        endcase
    end

endmodule
