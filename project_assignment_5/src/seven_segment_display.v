// FAST 7-SEGMENT DISPLAY FOR SIMULATION - TO SEE AN MULTIPLEXING
`timescale 1ns/1ps

module seven_segment_display(
    input wire clk,
    input wire [31:0] number,
    output reg [6:0] seg,
    output reg [7:0] an
);
    // MUCH FASTER clock divider for simulation visibility
    reg [10:0] clk_div;  // Reduced from 19 bits to 10 bits for FAST refresh
    always @(posedge clk) begin
        clk_div <= clk_div + 1;
    end
    
    // VERY fast refresh clock for simulation
    wire refresh_clk = clk_div[8]; // Very fast refresh - changes every 256*10ns = 2.56?s
    
    // Display counter (cycles through 8 displays)
    reg [2:0] display_counter;
    always @(posedge refresh_clk) begin
        display_counter <= display_counter + 1;
    end
    
    // Safe number handling
    wire [31:0] safe_number;
    assign safe_number = (^number === 1'bx) ? 32'b0 : number;
    
    // Current digit to display (extract 4-bit hex digits)
    reg [3:0] current_digit;
    always @(*) begin
        case (display_counter)
            3'b000: current_digit = safe_number[3:0];     // Rightmost digit (AN0)
            3'b001: current_digit = safe_number[7:4];     // AN1
            3'b010: current_digit = safe_number[11:8];    // AN2
            3'b011: current_digit = safe_number[15:12];   // AN3
            3'b100: current_digit = safe_number[19:16];   // AN4
            3'b101: current_digit = safe_number[23:20];   // AN5
            3'b110: current_digit = safe_number[27:24];   // AN6
            3'b111: current_digit = safe_number[31:28];   // AN7 (leftmost)
            default: current_digit = 4'b0;
        endcase
    end
    
    // Anode control (active low) - All 8 digits
    always @(*) begin
        case (display_counter)
            3'b000: an = 8'b11111110; // AN0 active (rightmost)
            3'b001: an = 8'b11111101; // AN1 active
            3'b010: an = 8'b11111011; // AN2 active
            3'b011: an = 8'b11110111; // AN3 active
            3'b100: an = 8'b11101111; // AN4 active
            3'b101: an = 8'b11011111; // AN5 active
            3'b110: an = 8'b10111111; // AN6 active
            3'b111: an = 8'b01111111; // AN7 active (leftmost)
            default: an = 8'b11111111; // All off
        endcase
    end
    
    // 7-segment decoder (active low segments)
    always @(*) begin
        case (current_digit)
            4'h0: seg = 7'b1000000; // 0
            4'h1: seg = 7'b1111001; // 1  
            4'h2: seg = 7'b0100100; // 2
            4'h3: seg = 7'b0110000; // 3
            4'h4: seg = 7'b0011001; // 4
            4'h5: seg = 7'b0010010; // 5
            4'h6: seg = 7'b0000010; // 6
            4'h7: seg = 7'b1111000; // 7
            4'h8: seg = 7'b0000000; // 8
            4'h9: seg = 7'b0010000; // 9
            4'hA: seg = 7'b0001000; // A
            4'hB: seg = 7'b0000011; // b
            4'hC: seg = 7'b1000110; // C
            4'hD: seg = 7'b0100001; // d
            4'hE: seg = 7'b0000110; // E
            4'hF: seg = 7'b0001110; // F
            default: seg = 7'b1111111; // All segments off
        endcase
    end
    
    // Initialize all registers to prevent 'x' values
    initial begin
        display_counter = 3'b000;
        clk_div = 11'b0;
    end
    
    // Debug output to show what's happening
    always @(posedge refresh_clk) begin
        $display("Display refresh: counter=%d, AN=%b, digit=%h, seg=%b", 
                 display_counter, an, current_digit, seg);
    end
    
endmodule