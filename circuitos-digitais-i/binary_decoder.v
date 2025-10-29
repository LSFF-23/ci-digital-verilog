module binary_decoder #(parameter N = 3) (in, out);
localparam M = 2 ** N;
input [N-1:0] in;
output reg [M-1:0] out;

always @* begin
    out = 0;
    out[in] = 1;
end

endmodule

module binary_decoder_tb;
parameter N = 4;
parameter M = 2 ** N;
reg [N-1:0] in;
wire [M-1:0] out;
integer pot2;

genvar i;

binary_decoder#(N) dut (in, out);

always #1 in[0] = ~in[0];
always #2 in[1] = ~in[1];
always #4 in[2] = ~in[2];
always #8 in[3] = ~in[3];


initial begin
    $monitor("%b | %b", in, out);
    in = 0;
    #16 $finish(0);
end

endmodule