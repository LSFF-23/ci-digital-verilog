`timescale 1ns/1ps

module counter_m100 (
    input clk_100M, rst,
    output reg [6:0] out
);

always @(posedge clk_100M or posedge rst) out <= (rst) ? (7'd0) : (out + 1) % 100;

endmodule

module counter_m100_tb;
reg clk_100M, rst;
wire [6:0] out;

counter_m100 dut (clk_100M, rst, out);

// F = 100Mhz -> T = 10ns -> T/2 = 5ns = 5u.t
always #5 clk_100M = !clk_100M;

initial begin
    clk_100M = 0; rst = 0;
    #1 rst = 1;
    #1 rst = 0;
    #3000 $finish(0);
end

endmodule