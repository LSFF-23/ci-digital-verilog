module mux2to1 (in, sel, out);
input [1:0] in;
input sel;
output out;

assign out = (!sel & in[0]) | (sel & in[1]);

endmodule

module mux4to1 (in, sel, out);
input [3:0] in;
input [1:0] sel;
output reg out;

always @* out = in[sel];

endmodule

module mux8to1 (in, sel, out);
input [7:0] in;
input [2:0] sel;
output out;

wire w1, w2;

mux4to1 m1 (.in(in[3:0]), .sel(sel[1:0]), .out(w1));
mux4to1 m2 (.in(in[7:4]), .sel(sel[1:0]), .out(w2));
mux2to1 m3 (.in({w2, w1}), .sel(sel[2]), .out(out));

endmodule

module mux8to1_tb;
reg [7:0] in;
reg [2:0] sel;
wire out;

mux8to1 dut (in, sel, out);

always #1 sel[0] = !sel[0];
always #2 sel[1] = !sel[1];
always #4 sel[2] = !sel[2];

initial begin
    $display("   in    | sel | out");
    $monitor("%b | %b | %3b", in, sel, out);
    in = 8'bx10x_01x1; sel = 0;
    #8 $finish(0);
end

endmodule