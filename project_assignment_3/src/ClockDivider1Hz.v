module ClockDivider1Hz(
    input clk,
    input rst,
    output reg clk_1hz
);

reg [26:0] counter;

parameter MAX_COUNT = 100_000_000 - 1;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        clk_1hz <= 0;
    end else begin
        if (counter == MAX_COUNT) begin
            counter <= 0;
            clk_1hz <= ~clk_1hz;
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule
