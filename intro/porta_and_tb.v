`timescale 1ns/1ps
module porta_and_tb;

reg a, b;
wire y;

porta_and dut (.a(a), .b(b), .y(y));

initial begin
  $display("Testando porta AND");
  $display("a b | y ");
  $monitor("%d %d | %d", a, b, y);
  a=0; b=0; #5;
  a=0; b=1; #5;
  a=1; b=0; #5;
  a=1; b=1; #5;
  $display("Teste concluido!");
  #5;
  $finish;
end
  
endmodule