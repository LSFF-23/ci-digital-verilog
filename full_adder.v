`timescale 1ns/1ps

module half_adder(
  input a, b,
  output sum, carry
);
  assign sum = a^b;
  assign carry = a&b;
endmodule

module full_adder(
  input a, b, cin,
  output sum, cout
);
  wire fcarry1, fcarry2, fsum;
  half_adder o1 (.a(a), .b(b), .sum(fsum), .carry(fcarry1));
  half_adder o2 (.a(cin), .b(fsum), .sum(sum), .carry(fcarry2));
  assign cout = fcarry1 | fcarry2;
endmodule

module full_adder_tb;
  reg a,b,cin;
  wire sum,cout;
  
  full_adder dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
  
  initial begin
    $display("a | b | cin | sum | cout");
    $monitor("%b | %b | %3d | %3d | %4d", a, b, cin, sum, cout);
    
   	a = 0; b = 0; cin = 0; #5;
    a = 0; b = 0; cin = 1; #5;
    a = 0; b = 1; cin = 0; #5;
    a = 0; b = 1; cin = 1; #5;
    a = 1; b = 0; cin = 0; #5;
    a = 1; b = 0; cin = 1; #5;
    a = 1; b = 1; cin = 0; #5;
    a = 1; b = 1; cin = 1; #5;
    
    $finish;
  end
  
endmodule