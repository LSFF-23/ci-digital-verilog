module keyboard_xs3 (
    input [9:0] in,
    output reg [3:0] out
);

always @(*) begin
    casex (in)
    16'b00_0000_0001: out = 4'b0011;
    16'b00_0000_001x: out = 4'b0100;
    16'b00_0000_01xx: out = 4'b0101;
    16'b00_0000_1xxx: out = 4'b0110;
    16'b00_0001_xxxx: out = 4'b0111;
    16'b00_001x_xxxx: out = 4'b1000;
    16'b00_01xx_xxxx: out = 4'b1001;
    16'b00_1xxx_xxxx: out = 4'b1010;
    16'b01_xxxx_xxxx: out = 4'b1011;
    16'b1x_xxxx_xxxx: out = 4'b1100;
    default: out = 4'b0000;
    endcase
end

endmodule

module keyboard_xs3_tb;
reg [9:0] in;
wire [3:0] out;

keyboard_xs3 dut (in, out);

always #1 in = in << 1;

initial begin
    $display("     in     |  out ");
    $monitor(" %b | %b", in, out);
    in = 1;
    #10 $finish(0);
end

endmodule