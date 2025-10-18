`timescale 1ns/1ps

module mux_comportamental (
    input [1:0] D,
    input sel,
    output reg y
);

always @(*)
begin
  if (sel == 0)
    y = D[0];
  else
    y = D[1];
end

endmodule

module mux_tb;
reg [1:0] D;
reg sel;
wire y;

mux_rtl dut (.D(D), .sel(sel), .y(y));

always #1 D[0] = !D[0];
always #2 D[1] = !D[1];
always #4 sel = !sel;

initial begin
    sel = 1'b0;
    D = 2'd0;
    #8 $stop;
end

endmodule