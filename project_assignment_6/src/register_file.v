// FIXED REGISTER FILE MODULE
`timescale 1ns/1ps

module register_file(
    input wire clk,
    input wire we3,
    input wire [4:0] a1, a2, a3,
    input wire [31:0] wd3,
    output wire [31:0] rd1, rd2
);
    reg [31:0] registers [0:31];
    
    // Asynchronous read
    assign rd1 = (a1 == 5'b0) ? 32'b0 : registers[a1];
    assign rd2 = (a2 == 5'b0) ? 32'b0 : registers[a2];
    
    // Synchronous write - Register 0 is always 0
    always @(posedge clk) begin
        if (we3 && a3 != 5'b0) begin
            registers[a3] <= wd3;
        end
    end
    
    // Initialize all registers to 0
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end
endmodule