`timescale 1ns/1ps

module four_gates(
	input a, b, c, d,
	output r
);
	wire and_port;
	assign and_port = ~a & b & c;
	assign r = and_port | d;

endmodule

module four_gates_tb;
	reg a, b, c, d;
	wire r;
	
	four_gates dut (.a(a), .b(b), .c(c), .d(d), .r(r));
	
	initial begin
		$display("A | B | C | D | R");
		$monitor("%b | %b | %b | %b | %b", a, b, c, d, r);
		a = 0; b = 0; c = 0; d = 0; #5;
		a = 0; b = 0; c = 0; d = 1; #5;
		a = 0; b = 0; c = 1; d = 0; #5;
		a = 0; b = 0; c = 1; d = 1; #5;
		a = 0; b = 1; c = 0; d = 0; #5;
		a = 0; b = 1; c = 0; d = 1; #5;
		a = 0; b = 1; c = 1; d = 0; #5;
		a = 0; b = 1; c = 1; d = 1; #5;
		a = 1; b = 0; c = 0; d = 0; #5;
		a = 1; b = 0; c = 0; d = 1; #5;
		a = 1; b = 0; c = 1; d = 0; #5;
		a = 1; b = 0; c = 1; d = 1; #5;
		a = 1; b = 1; c = 0; d = 0; #5;
		a = 1; b = 1; c = 0; d = 1; #5;
		a = 1; b = 1; c = 1; d = 0; #5;
		a = 1; b = 1; c = 1; d = 1; #5;
	
		$finish;
	end
endmodule

	