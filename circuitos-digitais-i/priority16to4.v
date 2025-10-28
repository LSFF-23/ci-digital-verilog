module priority16to4 (in, out);
input [15:0] in;
output reg [3:0] out;

always @* begin
  casex (in)
    16'b0000_0000_0000_0001: out = 4'b0000;
    16'b0000_0000_0000_001x: out = 4'b0001;
    16'b0000_0000_0000_01xx: out = 4'b0010;
    16'b0000_0000_0000_1xxx: out = 4'b0011;
    16'b0000_0000_0001_xxxx: out = 4'b0100;
    16'b0000_0000_001x_xxxx: out = 4'b0101;
    16'b0000_0000_01xx_xxxx: out = 4'b0110;
    16'b0000_0000_1xxx_xxxx: out = 4'b0111;
    16'b0000_0001_xxxx_xxxx: out = 4'b1000;
    16'b0000_001x_xxxx_xxxx: out = 4'b1001;
    16'b0000_01xx_xxxx_xxxx: out = 4'b1010;
    16'b0000_1xxx_xxxx_xxxx: out = 4'b1011;
    16'b0001_xxxx_xxxx_xxxx: out = 4'b1100;
    16'b001x_xxxx_xxxx_xxxx: out = 4'b1101;
    16'b01xx_xxxx_xxxx_xxxx: out = 4'b1110;
    16'b1xxx_xxxx_xxxx_xxxx: out = 4'b1111;
    default: out = 4'bxxxx;
  endcase
end

endmodule

module priority16to4_tb;
reg [15:0] in;
wire [3:0] out;

priority16to4 dut (in, out);

always #1 in = in << 1;

initial begin
    $display("        in        |  out ");
    $monitor(" %b | %b", in, out);
    in = 1;
    #16 $finish(0);
end

endmodule