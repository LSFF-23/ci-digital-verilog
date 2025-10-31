module demux1to2 (in, sel, out);
input in;
input sel;
output reg [1:0] out;

always @* begin
    out = 0;
    out[sel] = in;
end

endmodule

module demux1to4 (in, sel, out);
input in;
input [1:0] sel;
output reg [3:0] out;

always @* begin
    out = 0;
    out[sel] = 1;
end

endmodule

module cdemux1to8 (in, sel, out);
input in;
input [2:0] sel;
output [7:0] out;

input w1, w2;

demux1to2 d1 (in, sel[2], {w2, w1});
demux1to4 d2 (w2, sel[2] & sel[1:0], out[7:4]);
demux1to4 d3 (w1, !sel & sel[1:0], out[3:0]);

endmodule

module cdemux1to8_tb;
parameter IN_TB = 8'b1x01_x010;
reg in;
reg [2:0] sel;
wire [7:0] out;

cdemux1to8 dut (in, sel, out);

always #1 sel[0] = !sel[0];
always #2 sel[1] = !sel[1];
always #4 sel[2] = !sel[2];
always #1 begin
    in = IN_TB[$time];
end

initial begin
    $display("t | in | sel |   out  ");
    $monitor("%0d | %2b | %b | %b", $time, in, sel, out);
    sel = 0; in = IN_TB[0];
    #8 $finish(0);
end

endmodule
