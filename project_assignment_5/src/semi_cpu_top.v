// FIXED TOP MODULE FOR LAB 5 (NO JUMP/BRANCH)
`timescale 1ns/1ps

module semi_cpu_top(
    input wire clk,
    input wire control,    // Control input (button)
    input wire reset,      // Reset input (button)
    output wire [6:0] seg, // 7-segment display segments
    output wire [7:0] an   // 7-segment display anodes
);

    // Internal CPU signals
    wire [31:0] pc;
    wire [31:0] instruction;
    wire [2:0] aluop;
    wire [4:0] rs, rt, rd;
    wire [31:0] immediate;
    wire reg_write;
    wire alu_src;
    wire [4:0] write_reg;
    wire [31:0] read_data1, read_data2;
    wire [31:0] alu_input_b;
    wire [31:0] alu_result;

    // Button edge detection for control
    reg control_prev, reset_prev;
    wire control_pulse, reset_pulse;

    always @(posedge clk) begin
        control_prev <= control;
        reset_prev <= reset;
    end

    assign control_pulse = control & ~control_prev;
    assign reset_pulse = reset & ~reset_prev;

    // 1. PROGRAM COUNTER (Simplified - no jump/branch)
    program_counter pc_inst(
        .clk(clk),
        .reset(reset_pulse),
        .control(control_pulse),
        .pc(pc)
    );

    // 2. INSTRUCTION MEMORY
    instruction_memory imem_inst(
        .address(pc),
        .instruction(instruction)
    );

    // 3. INSTRUCTION DECODER (Simplified)
    instruction_decoder decoder_inst(
        .instruction(instruction),
        .control(1'b1),
        .aluop(aluop),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .immediate(immediate),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .write_reg(write_reg)
    );

    // 4. REGISTER FILE
    register_file rf_inst(
        .clk(clk),
        .we3(reg_write & control_pulse),
        .a1(rs),
        .a2(rt),
        .a3(write_reg),
        .wd3(alu_result),
        .rd1(read_data1),
        .rd2(read_data2)
    );

    // 5. ALU INPUT MUX
    assign alu_input_b = alu_src ? immediate : read_data2;

    // 6. ALU
    alu alu_inst(
        .inputA(read_data1),
        .inputB(alu_input_b),
        .aluop(aluop),
        .result(alu_result)
    );

    // 7. 7-SEGMENT DISPLAY
    seven_segment_display display_inst(
        .clk(clk),
        .number(alu_result),
        .seg(seg),
        .an(an)
    );

endmodule
