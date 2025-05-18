module register_file (
    input wire clk,
    input wire we3,
    input wire [4:0] a1, a2, a3,
    input wire [31:0] wd3,
    output wire [31:0] rd1, rd2
);
    // Define 32 registers, each 32 bits wide
    reg [31:0] registers [0:31];
    
    // Read operations (asynchronous)
    assign rd1 = registers[a1];
    assign rd2 = registers[a2];
    
    // Write operation (synchronous)
    always @(posedge clk) begin
        if (we3) begin
            registers[a3] <= wd3;
        end
    end
    
    // Initialize registers to 0 (for simulation)
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end
endmodule
