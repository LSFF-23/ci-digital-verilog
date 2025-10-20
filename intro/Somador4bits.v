module Somador4bits (
	input clk_100M,
	input [3:0] a,
	input [3:0] b,
	output reg [3:0] c,
	output reg carry_out
);

always @(posedge clk_100M)
begin
	{carry_out, c} <= a + b;
end

endmodule

