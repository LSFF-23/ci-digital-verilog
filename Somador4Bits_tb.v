`timescale 1ns/1ps

module Somador4Bits_tb;
reg clk;
reg [3:0] a, b;
wire [3:0] sum;
wire carry_out;

Somador4Bits dut (.a(a), .b(b), .sum(sum), .carry_out(carry_out));

always #10 clk = ~clk;

initial begin
	clk <= 0;
	#40 a <= 4'b0000; b <= 4'b0000; // sum = 0
	#40 b <= 4'b0001; // sum = 1
	#40 a <= 4'b0001; // sum = 2
	#40 a <= 4'b0011; // sum = 4
	#40 b <= 4'b0011; // sum = 6
	#40 a <= 4'b0100; // sum = 7
	#40 a <= 4'b0111; b <= 4'b0111; // sum = 14
	#40 a <= 4'b1111; b <= 4'b1111; // sum = 14, carry_out = 1
	#40 a <= 4'b0001; b <= 4'b1111; // sum = 8
	#40 a <= 4'b0000; b <= 4'b0000; // sum = 0
	$finish;
end

endmodule