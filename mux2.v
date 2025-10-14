`timescale 1ns/1ps

module mux2 #(parameter IN_SIZE = 2) (
  	input [IN_SIZE-1:0] a, b, 
  	input sel,
  	output reg [IN_SIZE-1:0] out
);

always @ (a or b or sel)
begin
  	if (sel == 0)
		out = a;
	else
		out = b;
end

endmodule

module mux2_tb #(parameter IN_SIZE = 2);
  	reg [IN_SIZE-1:0] a, b;
  	reg sel;
  	wire [IN_SIZE-1:0] out;
	
	mux2 dut (.a(a),.b(b),.sel(sel),.out(out));
	
	initial begin
    	$display("a | b | sel | out");
      $monitor("%d | %d | %3d | %3d", a, b, sel, out);
		a = 2'd3; b = 2'd0; sel = 0; #5;
		a = 2'd2; b = 2'd1; #5;
		a = 2'd1; b = 2'd2; #5;
		a = 2'd0; b = 2'd3; sel = 1; #5;
		$finish;
	end
endmodule