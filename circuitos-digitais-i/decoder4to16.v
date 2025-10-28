module decoder4to16 (in, out);
input [3:0] in;
output reg [15:0] out;

always @* begin
    case (in)
        4'b0000: out = 16'b0000_0000_0000_0001;
        4'b0001: out = 16'b0000_0000_0000_0010;
        4'b0010: out = 16'b0000_0000_0000_0100;
        4'b0011: out = 16'b0000_0000_0000_1000;
        4'b0100: out = 16'b0000_0000_0001_0000;
        4'b0101: out = 16'b0000_0000_0010_0000;
        4'b0110: out = 16'b0000_0000_0100_0000;
        4'b0111: out = 16'b0000_0000_1000_0000;
        4'b1000: out = 16'b0000_0001_0000_0000;
        4'b1001: out = 16'b0000_0010_0000_0000;
        4'b1010: out = 16'b0000_0100_0000_0000;
        4'b1011: out = 16'b0000_1000_0000_0000;
        4'b1100: out = 16'b0001_0000_0000_0000;
        4'b1101: out = 16'b0010_0000_0000_0000;
        4'b1110: out = 16'b0100_0000_0000_0000;
        4'b1111: out = 16'b1000_0000_0000_0000;
        default: out = 16'bx;
    endcase
end

endmodule

module decoder4to16_tb;
reg [3:0] in;
wire [15:0] out;

always #1 in[0] = ~in[0];
always #2 in[1] = ~in[1];
always #4 in[2] = ~in[2];
always #8 in[3] = ~in[3];

decoder4to16 dut (in, out);

initial begin
    $display("DCBA |       out      ");
    $monitor("%b | %b", in, out);
    in = 0;
    #16 $finish(0);
end

endmodule