module mul_fp (a, b, result);
input [7:0] a, b;
output reg [7:0] result;

reg [15:0] mid_mult;
reg rounding_bit;

always @(*) begin
    mid_mult = a * b;
    rounding_bit = mid_mult[2];
    result = mid_mult[10:3] + rounding_bit;
end

endmodule

module mul_fp_tb;
reg [7:0] a, b;
wire [7:0] result;

mul_fp dut (a, b, result);

initial begin
    $display("%9s | %9s | %9s", "a", "b", "result");
    $monitor("%5b.%3b | %5b.%3b | %5b.%3b", a[7:3], a[2:0], b[7:3], b[2:0], result[7:3], result[2:0]);
    a = 8'b00001010; b = 8'b00001100;
    #1 a = 8'b00010_000; b = 8'b01010_000;
    #1 a = 8'b00001_010; b = 8'b01000_000;
    #1 $finish(0);
end

endmodule