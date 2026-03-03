module mux2x1 (in0, in1, sel, out);
input [7:0] in0, in1;
input sel;
output [7:0] out;

assign out = (sel) ? in1 : in0;

endmodule

// crossbar switch 2x2
module cbsw2x2 (in0, in1, sel, out0, out1);
input [7:0] in0, in1;
input sel;
output [7:0] out0, out1;

mux2x1 m1 (in0, in1, sel, out0);
mux2x1 m2 (in1, in0, sel, out1);

endmodule