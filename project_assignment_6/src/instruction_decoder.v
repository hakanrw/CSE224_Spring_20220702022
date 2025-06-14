// FIXED INSTRUCTION DECODER - ALWAYS DECODE CURRENT INSTRUCTION
`timescale 1ns/1ps

module instruction_decoder(
    input wire [31:0] instruction,
    input wire control,  // Keep for compatibility
    output reg [2:0] aluop,
    output reg [4:0] rs, rt, rd,
    output reg [31:0] immediate,
    output reg reg_write,
    output reg alu_src,
    output reg [4:0] write_reg,
    output reg jump,
    output reg branch,
    output reg [31:0] jump_address,
    output reg [31:0] branch_address
);
    wire [5:0] opcode = instruction[31:26];
    wire [4:0] rs_field = instruction[25:21];
    wire [4:0] rt_field = instruction[20:16];
    wire [4:0] rd_field = instruction[15:11];
    wire [15:0] imm_field = instruction[15:0];
    wire [25:0] jump_field = instruction[25:0];
    wire [5:0] funct = instruction[5:0];
    
    always @(*) begin
        // Default values
        aluop = 3'b000;
        rs = rs_field;
        rt = rt_field;
        rd = rd_field;
        immediate = {{16{imm_field[15]}}, imm_field};
        reg_write = 1'b0;
        alu_src = 1'b0;
        write_reg = 5'b0;
        jump = 1'b0;
        branch = 1'b0;
        jump_address = 32'b0;
        branch_address = 32'b0;
        
        // ALWAYS decode the instruction
        if (instruction == 32'b0) begin
            // NOP instruction (all zeros)
            aluop = 3'b000;
            reg_write = 1'b0;
        end else begin
            case (opcode)
                6'b001000: begin // ADDI
                    aluop = 3'b110;
                    reg_write = 1'b1;
                    alu_src = 1'b1;
                    write_reg = rt_field;
                    rs = rs_field;
                    immediate = {{16{imm_field[15]}}, imm_field};
                end
                
                6'b001001: begin // SUBI (Note: Your memory uses 0010011 for SUBI)
                    aluop = 3'b111;
                    reg_write = 1'b1;
                    alu_src = 1'b1;
                    write_reg = rt_field;
                    rs = rs_field;
                    immediate = {{16{imm_field[15]}}, imm_field};
                end
                
                6'b001001: begin // Alternative SUBI encoding
                    aluop = 3'b111;
                    reg_write = 1'b1;
                    alu_src = 1'b1;
                    write_reg = rt_field;
                    rs = rs_field;
                    immediate = {{16{imm_field[15]}}, imm_field};
                end
                
                6'b000000: begin // R-type instructions
                    reg_write = 1'b1;
                    alu_src = 1'b0;
                    write_reg = rd_field;
                    rs = rs_field;
                    rt = rt_field;
                    case (funct)
                        6'b100000: aluop = 3'b010; // ADD
                        6'b100010: aluop = 3'b011; // SUB
                        6'b000000: aluop = 3'b100; // SLL (SHIFTL)
                        6'b000010: aluop = 3'b101; // SRL (SHIFTR)
                        default: aluop = 3'b000;
                    endcase
                end
                
                6'b000010: begin // J (Jump)
                    jump = 1'b1;
                    jump_address = {6'b0, jump_field};
                    aluop = 3'b000; // NOP for ALU
                    reg_write = 1'b0; // Don't write for jump
                end
                
                6'b000100: begin // BEQ (Branch Equal)
                    branch = 1'b1;
                    branch_address = {{16{imm_field[15]}}, imm_field};
                    aluop = 3'b011; // SUB to compare (rs - rt)
                    alu_src = 1'b0; // Use register for comparison
                    reg_write = 1'b0; // Don't write for branch
                    rs = rs_field;
                    rt = rt_field;
                end
                
                default: begin
                    // Unknown instruction - NOOP
                    aluop = 3'b000;
                    reg_write = 1'b0;
                end
            endcase
        end
    end
endmodule