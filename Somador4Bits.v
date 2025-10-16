`timescale 1ns/1ps

module Somador4Bits (
	input clk,
	input [3:0] a, b,
	output reg [3:0] sum,
	output reg carry_out
);

always @(posedge clk)
begin
	{carry_out, sum} <= a + b;
end

endmodule