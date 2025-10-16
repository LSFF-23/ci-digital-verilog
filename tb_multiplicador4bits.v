module tb_multiplicador4bits;
reg clk_100M;
reg [3:0] a;
reg [3:0] b;
wire [7:0] c;

Multiplicador4bits sm0 (.clk_100M(clk_100M), .a(a), .b(b), .c(c));

always #10 clk_100M = ~clk_100M;

initial
begin
	clk_100M <= 0;
	#40
	clk_100M <= 0;
	a <= 4'b0000;
	b <= 4'b0000;
	#40
	a <= 4'b0000;
	b <= 4'b0001;
	#40
	a <= 4'b0001;
	b <= 4'b0001;
	#40
	a <= 4'b0011;
	b <= 4'b0001;
	#40
	a <= 4'b0011;
	b <= 4'b0011;
	#40
	a <= 4'b0100;
	b <= 4'b0011;
	#40
	a <= 4'b0111;
	b <= 4'b0111;
	#40
	a <= 4'b1111;
	b <= 4'b0111;
	#40
	a <= 4'b1111;
	b <= 4'b1111;
	#40
	a <= 4'b0001;
	b <= 4'b0111;
	#40
	a <= 4'b0000;
	b <= 4'b0000;
	$finish;
end

endmodule