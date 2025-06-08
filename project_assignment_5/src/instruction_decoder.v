// SIMPLIFIED INSTRUCTION DECODER FOR LAB 5
`timescale 1ns/1ps

module instruction_decoder(
    input wire [31:0] instruction,
    input wire control,  // For compatibility, unused
    output reg [2:0] aluop,
    output reg [4:0] rs, rt, rd,
    output reg [31:0] immediate,
    output reg reg_write,
    output reg alu_src,
    output reg [4:0] write_reg
);

    wire [5:0] opcode = instruction[31:26];
    wire [4:0] rs_field = instruction[25:21];
    wire [4:0] rt_field = instruction[20:16];
    wire [4:0] rd_field = instruction[15:11];
    wire [15:0] imm_field = instruction[15:0];
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

        if (instruction == 32'b0) begin
            // NOOP
            aluop = 3'b000;
            reg_write = 1'b0;
        end else begin
            case (opcode)
                6'b001000: begin // ADDI
                    aluop = 3'b110;
                    reg_write = 1'b1;
                    alu_src = 1'b1;
                    write_reg = rt_field;
                end
                6'b001001: begin // SUBI (custom)
                    aluop = 3'b111;
                    reg_write = 1'b1;
                    alu_src = 1'b1;
                    write_reg = rt_field;
                end
                6'b000000: begin // R-type: ADD, SUB, SHIFTL, SHIFTR
                    reg_write = 1'b1;
                    alu_src = 1'b0;
                    write_reg = rd_field;
                    case (funct)
                        6'b100000: aluop = 3'b010; // ADD
                        6'b100010: aluop = 3'b011; // SUB
                        6'b000000: aluop = 3'b100; // SHIFTL (SLL)
                        6'b000010: aluop = 3'b101; // SHIFTR (SRL)
                        default: aluop = 3'b000;   // Default NOOP
                    endcase
                end
                default: begin
                    aluop = 3'b000;
                    reg_write = 1'b0;
                end
            endcase
        end
    end
endmodule
