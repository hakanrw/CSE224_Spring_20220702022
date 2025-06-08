// COMPLETE WORKING TESTBENCH - MODIFIED TO SEE AN MULTIPLEXING

`timescale 1ns / 1ps

module tb_semi_cpu_complete;
    
    // Testbench signals
    reg clk;
    reg control;
    reg reset;
    wire [6:0] seg;
    wire [7:0] an;
    
    // Instantiate the CPU
    semi_cpu_top uut (
        .clk(clk),
        .control(control),
        .reset(reset),
        .seg(seg),
        .an(an)
    );
    
    // Clock generation - 100MHz
    always #5 clk = ~clk;
    
    // Test procedure
    initial begin
        // Initialize all signals
        clk = 0;
        control = 0;
        reset = 0;
        
        $display("=== CPU SIMULATION STARTING ===");
        $display("Time: %0t", $time);
        
        // Wait for initial setup
        #20;
        
        // Apply reset
        $display("\n--- RESET PHASE ---");
        reset = 1;
        #20;
        reset = 0;
        #20;
        
        $display("After reset: PC = %0d", uut.pc);
        
        // Execute first few instructions manually
        $display("\n--- INSTRUCTION EXECUTION ---");
        
        // Step 1: ADDI r10, r0, 10
        $display("\nStep 1: ADDI r10, r0, 10");
        $display("Before: PC=%0d, r10=%0d", uut.pc, uut.rf_inst.registers[10]);
        execute_instruction();
        $display("After: PC=%0d, r10=%0d, ALU_result=%0d", uut.pc, uut.rf_inst.registers[10], uut.alu_result);
        
        // Step 2: ADDI r15, r0, 15
        $display("\nStep 2: ADDI r15, r0, 15");
        $display("Before: PC=%0d, r15=%0d", uut.pc, uut.rf_inst.registers[15]);
        execute_instruction();
        $display("After: PC=%0d, r15=%0d, ALU_result=%0d", uut.pc, uut.rf_inst.registers[15], uut.alu_result);
        
        // Step 3: ADD r25, r10, r15
        $display("\nStep 3: ADD r25, r10, r15");
        $display("Before: PC=%0d, r25=%0d, r10=%0d, r15=%0d", uut.pc, uut.rf_inst.registers[25], uut.rf_inst.registers[10], uut.rf_inst.registers[15]);
        execute_instruction();
        $display("After: PC=%0d, r25=%0d, ALU_result=%0d", uut.pc, uut.rf_inst.registers[25], uut.alu_result);
        
        // Step 4: SUBI r20, r25, 5
        $display("\nStep 4: SUBI r20, r25, 5");
        $display("Before: PC=%0d, r20=%0d, r25=%0d", uut.pc, uut.rf_inst.registers[20], uut.rf_inst.registers[25]);
        execute_instruction();
        $display("After: PC=%0d, r20=%0d, ALU_result=%0d", uut.pc, uut.rf_inst.registers[20], uut.alu_result);
        
        // Step 5: ADDI r21, r0, 2
        $display("\nStep 5: ADDI r21, r0, 2");
        $display("Before: PC=%0d, r21=%0d", uut.pc, uut.rf_inst.registers[21]);
        execute_instruction();
        $display("After: PC=%0d, r21=%0d, ALU_result=%0d", uut.pc, uut.rf_inst.registers[21], uut.alu_result);
        
        // Step 6: J 12 (Jump)
        $display("\nStep 6: J 12 (Jump to address 12)");
        $display("Before: PC=%0d", uut.pc);
        execute_instruction();
        $display("After: PC=%0d (should be 12)", uut.pc);
        
        // Continue with a few more steps
        repeat(5) begin
            $display("\nNext instruction at PC=%0d", uut.pc);
            execute_instruction();
            $display("PC now = %0d, ALU_result = %0d", uut.pc, uut.alu_result);
        end
        
        // Final register dump
        $display("\n=== FINAL REGISTER STATE ===");
        display_registers();

        // Test 7-segment display
        $display("\n=== 7-SEGMENT DISPLAY TEST ===");
        $display("Current ALU result: %0d (0x%h)", uut.alu_result, uut.alu_result);
        $display("7-segment seg = %b, an = %b", seg, an);

        // ADD THIS LINE: Wait long enough to see display multiplexing
        $display("\n=== WAITING TO OBSERVE DISPLAY MULTIPLEXING ===");
        $display("Waiting 10ms to see AN[7:0] cycling through different patterns...");

        
        $display("\n=== SIMULATION COMPLETE ===");
        $finish;
    end
    
    // Task to execute one instruction
    task execute_instruction;
        begin
            #10;
            control = 1;
            #10;
            control = 0;
            #10;
        end
    endtask
    
    // Task to display non-zero registers
    task display_registers;
        integer i;
        begin
            for (i = 0; i < 32; i = i + 1) begin
                if (uut.rf_inst.registers[i] != 0) begin
                    $display("r%0d = %0d (0x%h)", i, uut.rf_inst.registers[i], uut.rf_inst.registers[i]);
                end
            end
        end
    endtask
    
    // Monitor AN changes to see multiplexing in console
    always @(an) begin
        case (an)
            8'b11111110: $display("Time %0t: Display showing digit 0 (rightmost) - AN=%b", $time, an);
            8'b11111101: $display("Time %0t: Display showing digit 1 - AN=%b", $time, an);
            8'b11111011: $display("Time %0t: Display showing digit 2 - AN=%b", $time, an);
            8'b11110111: $display("Time %0t: Display showing digit 3 - AN=%b", $time, an);
            8'b11101111: $display("Time %0t: Display showing digit 4 - AN=%b", $time, an);
            8'b11011111: $display("Time %0t: Display showing digit 5 - AN=%b", $time, an);
            8'b10111111: $display("Time %0t: Display showing digit 6 - AN=%b", $time, an);
            8'b01111111: $display("Time %0t: Display showing digit 7 (leftmost) - AN=%b", $time, an);
            default: $display("Time %0t: Display AN pattern: %b", $time, an);
        endcase
    end
    
    // Continuous monitoring
    always @(posedge uut.control_pulse) begin
        $display("CONTROL PULSE detected at time %0t", $time);
    end
    
    // VCD dump for waveform viewing
    initial begin
        $dumpfile("cpu_simulation.vcd");
        $dumpvars(0, tb_semi_cpu_complete);
    end
    
endmodule