// crossbar switch interface: cbsw2x2 ins0 (in0, in1, sel, out0, out1)
// banyan switch 8x8
module banyan8x8 (
    input [7:0] in0, in1, in2, in3, in4, in5, in6, in7, 
    input [2:0] sel,
    output [7:0] out0, out1, out2, out3, out4, out5, out6, out7
);

wire [7:0] A10, A11, A20, A21, A30, A31, A40, A41;
wire [7:0] B10, B11, B20, B21, B30, B31, B40, B41;

cbsw2x2 A_1 (in0, in4, sel[2], A10, A11);
cbsw2x2 A_2 (in1, in5, sel[2], A20, A21);
cbsw2x2 A_3 (in2, in6, sel[2], A30, A31);
cbsw2x2 A_4 (in3, in7, sel[2], A40, A41);

cbsw2x2 B_1 (A10, A30, sel[1], B10, B11);
cbsw2x2 B_2 (A20, A40, sel[1], B20, B21);
cbsw2x2 B_3 (A11, A31, sel[1], B30, B31);
cbsw2x2 B_4 (A21, A41, sel[1], B40, B41);

cbsw2x2 C_1 (B10, B20, sel[0], out0, out1);
cbsw2x2 C_2 (B11, B21, sel[0], out2, out3);
cbsw2x2 C_3 (B30, B40, sel[0], out4, out5);
cbsw2x2 C_4 (B31, B41, sel[0], out6, out7);

endmodule

module tb_banyan8x8;
reg [7:0] in0, in1, in2, in3, in4, in5, in6, in7;
reg [2:0] sel;
wire [7:0] out0, out1, out2, out3, out4, out5, out6, out7;

banyan8x8 dut (
    in0, in1, in2, in3, in4, in5, in6, in7, 
    sel, 
    out0, out1, out2, out3, out4, out5, out6, out7
);

integer i;
initial begin
    {in0, in1, in2, in3, in4, in5, in6, in7} = "ABCDEFGH"; #10
    for (i = 0; i < 8; i = i + 1) begin
        sel = i[2:0]; #10;
    end
    $stop(0);
end

endmodule