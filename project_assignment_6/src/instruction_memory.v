// INSTRUCTION MEMORY - FIXED FOR VIVADO 2014.4 COMPATIBILITY
`timescale 1ns/1ps

module instruction_memory(
    input wire [31:0] address,
    output reg [31:0] instruction
);
    reg [31:0] memory [0:31];
    
    always @(*) begin
        instruction = memory[address[4:0]];
    end
    
    // Initialize memory - Fixed for older Vivado versions
    initial begin
        // Lab 6 Instruction Sequence
        
        // 1. ADDI r10, r0, 10
        memory[0] = 32'b00100000000010100000000000001010;
        
        // 2. ADDI r15, r0, 15  
        memory[1] = 32'b00100000000011110000000000001111;
        
        // 3. ADD r25, r10, r15
        memory[2] = 32'b00000001010011111100100000100000;
        
        // 4. SUBI r20, r25, 5
        memory[3] = 32'b00100111001101000000000000000101;
        
        // 5. ADDI r21, r0, 2
        memory[4] = 32'b00100000000101010000000000000010;
        
        // 6. J 12 (Jump to address 12)
        memory[5] = 32'b00001000000000000000000000001100;
        
        // 7. SHIFTL r30, r7, r21 (This will be skipped by jump)
        memory[6] = 32'b00000010101001111111000000000000;
        
        // 8-11. NOP instructions
        memory[7] = 32'b0;
        memory[8] = 32'b0;
        memory[9] = 32'b0;
        memory[10] = 32'b0;
        memory[11] = 32'b0;
        
        // 12. ADDI r4, r0, 4
        memory[12] = 32'b00100000000001000000000000000100;
        
        // 13. ADD r5, r0, r0
        memory[13] = 32'b00000000000000000010100000100000;
        
        // 14. BEQ r4, r5, 7 (Branch to address 21 if r4 == r5)
        memory[14] = 32'b00010000100001010000000000000111;
        
        // 15. ADDI r6, r0, 1
        memory[15] = 32'b00100000000001100000000000000001;
        
        // 16. ADDI r7, r0, 1
        memory[16] = 32'b00100000000001110000000000000001;
        
        // 17. ADD r8, r6, r7
        memory[17] = 32'b00000000110001110100000000100000;
        
        // 18. ADD r6, r7, r0 (Fibonacci sequence)
        memory[18] = 32'b00000000111000000011000000100000;
        
        // 19. ADD r7, r8, r0
        memory[19] = 32'b00000001000000000011100000100000;
        
        // 20. ADDI r5, r5, 1 (increment counter)
        memory[20] = 32'b00100000101001010000000000000001;
        
        // 21. J 14 (Jump back to address 14 - loop)
        memory[21] = 32'b00001000000000000000000000001110;
        
        // Initialize remaining memory - Compatible with Vivado 2014.4
        memory[22] = 32'b0;
        memory[23] = 32'b0;
        memory[24] = 32'b0;
        memory[25] = 32'b0;
        memory[26] = 32'b0;
        memory[27] = 32'b0;
        memory[28] = 32'b0;
        memory[29] = 32'b0;
        memory[30] = 32'b0;
        memory[31] = 32'b0;
    end
endmodule