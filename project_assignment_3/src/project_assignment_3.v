
//////////////////////////////////////////////////////////////////////////////////
// Company: Yeditepe University
// Engineer: Hakan Candar, Egemen Aybir, Berk Tahir Kilic
//
// Create Date: 18.05.2025 21:54:07
// Design Name:
// Module Name: project_assignment_3
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


module project_assignment_3 (
    input clk,
    input btn,
    output [6:0] seg,
    output [7:0] an
);

wire clk_1hz;
wire [3:0] count;

assign an = 8'b11111110; // only enable first display


ClockDivider1Hz div (
    .clk(clk),
    .rst(btn),       // optionally reset the divider too
    .clk_1hz(clk_1hz)
);

ZeroToFiveCounter counter (
    .clk(clk_1hz),
    .rst(btn),
    .count(count)
);

SevenSegmentDisplay display (
    .binary_in(count),
    .seg(seg)
);


endmodule
