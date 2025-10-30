module muxNto1 #(parameter N = 8) (in, sel, out);
localparam M = $clog2(N);
input [N-1:0] in;
input [M-1:0] sel;
output reg out;

always @* out = in[sel];

endmodule

module muxNto1_tb;
parameter N = 4;
reg [3:0] in;
reg [1:0] sel;
wire out;

muxNto1#(N) dut (in, sel, out);

always #1 sel[0] = !sel[0];
always #2 sel[1] = !sel[1];

initial begin
    $display("  in  | sel | out ");
    $monitor(" %4b | %3b | %4b ", in, sel, out);
    in = 4'b1x01; sel = 0;
    #4 $finish(0);
end

endmodule