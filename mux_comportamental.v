`timescale 1ns/1ps

module mux (
  input [1:0] D,
  input sel,
  output y
);

reg y_reg;

always @(*)
begin
  if (sel == 0)
    y_reg = D[0];
  else
    y_reg = D[1];
end

assign y = y_reg;

endmodule

// mux_comportamental_tb.v
module mux_tb;
reg [1:0] D;
reg sel;
wire y;

mux dut (.D(D), .sel(sel), .y(y));

always #1 D[0] = !D[0];
always #2 D[1] = !D[1];
always #4 sel = !sel;

initial begin
    $display("sel | D[1] | D[0] | y");
    $monitor("%3d | %4d | %4d | %b", sel, D[1], D[0], y);
    sel = 1'b0;
    D = 2'd0;
    #8 $finish;
end

endmodule