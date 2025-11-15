module dcba27segments (
    input [3:0] dcba,
    output reg [6:0] segments 
);

always @ (*) begin
    case (dcba)
        4'b0000: segments = 7'b0000001;
        4'b0001: segments = 7'b1001111;
        4'b0010: segments = 7'b0010010;
        4'b0011: segments = 7'b0000110;
        4'b0100: segments = 7'b1001100;
        4'b0101: segments = 7'b0100100;
        4'b0110: segments = 7'b0100000;
        4'b0111: segments = 7'b0001111;
        4'b1000: segments = 7'b0000000;
        4'b1001: segments = 7'b0000100;
        4'b1010: segments = 7'b0001000; // A
        4'b1011: segments = 7'b1100000; // b
        4'b1100: segments = 7'b0110001; // C
        4'b1101: segments = 7'b1000010; // d
        4'b1110: segments = 7'b0110000; // E
        4'b1111: segments = 7'b0111000; // F
        default: segments = 7'b1111111;
    endcase
end

endmodule

module somador (clk, a, b, cout, sum, d2, d1);
input clk;
input [3:0] a, b;
output cout;
output [3:0] sum;
output [6:0] d2, d1;

reg [3:0] digit2, digit1;
reg [4:0] mid_sum;

always @(posedge clk) begin
    mid_sum = a + b;
    digit2 <= mid_sum / 10;
    digit1 <= mid_sum % 10;
end

assign {cout, sum} = mid_sum;

dcba27segments set_d2 (digit2, d2);
dcba27segments set_d1 (digit1, d1);

endmodule

module somador_tb;
reg clk;
reg [3:0] a, b;
wire cout;
wire [3:0] sum;
wire [6:0] d2, d1;

always #1 clk = !clk;

somador dut (clk, a, b, cout, sum, d2, d1);

initial begin
    $monitor("%b %b %b %b %b %b", a, b, cout, sum, d2, d1);
    clk = 0;
    #1 a = 7; b = 5;
    #2 a = 10; b = 11;
    #2 a = 15; b = 15;
    #2 $finish(0);
end

endmodule