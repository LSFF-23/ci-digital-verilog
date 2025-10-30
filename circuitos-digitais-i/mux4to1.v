module mux4to1 #(parameter N = 8) (
    input [3:0][N-1:0] in,
    input [1:0] sel,
    output reg [N-1:0] out
);

always @* out = in[sel];

endmodule

module mux4to1_tb;
parameter N = 4;
reg [3:0][N-1:0] in;
reg [1:0] sel;
wire [N-1:0] out;

mux4to1#(N) dut (in, sel, out);

always #1 sel[0] = !sel[0];
always #2 sel[1] = !sel[1];

initial begin
    $display("in[3] | in[2] | in[1] | in[0] | sel | out ");
    $monitor("%5b | %5b | %5b | %5b | %3b | %b", in[3], in[2], in[1], in[0], sel, out);
    sel = 0;
    in[3] = 4'b1111; in[2] = 4'b0111; in[1] = 4'b0011; in[0] = 4'b0001;
    #4 $finish(0);
end

endmodule