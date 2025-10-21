module bcd2xs3 (
    input [3:0] bcd,
    output [3:0] xs3
);

reg [3:0] xs3_reg;

always @(*) begin
    case (bcd)
    4'b0000: xs3_reg = 4'b0011;
    4'b0001: xs3_reg = 4'b0100;
    4'b0010: xs3_reg = 4'b0101;
    4'b0011: xs3_reg = 4'b0110;
    4'b0100: xs3_reg = 4'b0111;
    4'b0101: xs3_reg = 4'b1000;
    4'b0110: xs3_reg = 4'b1001;
    4'b0111: xs3_reg = 4'b1010;
    4'b1000: xs3_reg = 4'b1011;
    4'b1001: xs3_reg = 4'b1100;
    default: xs3_reg = 4'b0000;
    endcase
end

assign xs3 = xs3_reg;

endmodule

module bcd2xs3_tb;
reg [3:0] bcd;
wire [3:0] xs3;

bcd2xs3 dut (bcd, xs3);

initial begin
    $display("DCBA | WXYZ");
    $monitor("%4b | %4b", bcd, xs3);
    bcd = 4'b0000; #10;
    bcd = 4'b0001; #10;
    bcd = 4'b0010; #10;
    bcd = 4'b0011; #10;
    bcd = 4'b0100; #10;
    bcd = 4'b0101; #10;
    bcd = 4'b0110; #10;
    bcd = 4'b0111; #10;
    bcd = 4'b1000; #10;
    bcd = 4'b1001; #10;
end

endmodule