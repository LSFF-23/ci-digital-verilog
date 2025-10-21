module dcba2gray (
    input [3:0] bcd,
    output reg [3:0] gray
);

always @(*)
begin
  case (bcd)
    4'b0000: gray = 4'b0000;
    4'b0001: gray = 4'b0001;
    4'b0010: gray = 4'b0011;
    4'b0011: gray = 4'b0010;
    4'b0100: gray = 4'b0110;
    4'b0101: gray = 4'b0111;
    4'b0110: gray = 4'b0101;
    4'b0111: gray = 4'b0100;
    4'b1000: gray = 4'b1100;
    4'b1001: gray = 4'b1101;
    4'b1010: gray = 4'b1111;
    4'b1011: gray = 4'b1110;
    4'b1100: gray = 4'b1010;
    4'b1101: gray = 4'b1011;
    4'b1110: gray = 4'b1001;
    4'b1111: gray = 4'b1000;
    default: gray = 4'bxxxx;
  endcase
end

endmodule

module dcba2gray_tb;
reg [3:0] bcd;
wire [3:0] gray;


always #1 bcd[0] = !bcd[0];
always #2 bcd[1] = !bcd[1];
always #4 bcd[2] = !bcd[2];
always #8 bcd[3] = !bcd[3];

dcba2gray dut(bcd, gray);

initial begin
    $display("DCBA | WXYZ");
    $monitor("%4b | %4b", bcd, gray);
    bcd = 4'b0000;
    #16 $finish;
end

endmodule