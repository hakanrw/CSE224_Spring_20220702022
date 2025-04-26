
//////////////////////////////////////////////////////////////////////////////////
// Company: Yeditepe University
// Engineer: Hakan Candar, Egemen Aybir, Berk Tahir Kilic
// 
// Create Date: 20.03.2025 13:04:51
// Design Name: 
// Module Name: two_complement
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


module project_assignment_1(
    input [7:0] in,
    output [7:0] out,
    input clk
);
    assign out = ~in + 8'b00000001; // 2 complement al
endmodule
