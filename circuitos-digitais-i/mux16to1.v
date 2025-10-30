module mux16to1 (in, sel, out);
input [15:0] in;
input [3:0] sel;
output reg out;

always @* out = in[sel];

endmodule

module mux16to1_tb;
reg [15:0] in;
reg [3:0] sel;
wire out;

mux16to1 dut (in, sel, out);

always #1 sel[0] = !sel[0];
always #2 sel[1] = !sel[1];
always #4 sel[2] = !sel[2];
always #8 sel[3] = !sel[3];

initial begin
    $display("       in        |  sel | out");
    $monitor("%b | %b | %3b", in, sel, out);
    in = 16'b01x1_1x01_x0x1_10x1; sel = 0;
    #16 $finish(0);
end

endmodule