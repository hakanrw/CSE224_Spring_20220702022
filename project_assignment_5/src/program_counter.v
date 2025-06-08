// SIMPLIFIED PROGRAM COUNTER FOR LAB 5
`timescale 1ns/1ps

module program_counter(
    input wire clk,
    input wire reset,
    input wire control,
    output reg [31:0] pc
);

    always @(posedge clk) begin
        if (reset)
            pc <= 32'b0;
        else if (control)
            pc <= pc + 4;
    end

endmodule
