module Multiplicador4bits (
	input clk_100M,
	input [3:0] a,
	input [3:0] b,
	output reg [7:0] c
);

always @(posedge clk_100M)
begin
	c <= a * b;
end

endmodule