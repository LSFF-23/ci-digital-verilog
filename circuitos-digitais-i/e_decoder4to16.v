module e_decoder3to8 (in, out);
input [2:0] in;
output reg [7:0] out;

always @* begin
    case (in)
        3'b000: out = 8'b0000_0001;
        3'b001: out = 8'b0000_0010;
        3'b010: out = 8'b0000_0100;
        3'b011: out = 8'b0000_1000;
        3'b100: out = 8'b0001_0000;
        3'b101: out = 8'b0010_0000;
        3'b110: out = 8'b0100_0000;
        3'b111: out = 8'b1000_0000;
        default: out = 8'bx;
    endcase
end

endmodule

module e_decoder4to16(in, out);
input [3:0] in;
output [15:0] out;

wire [7:0] zero_byte, d_out;
wire flag;

e_decoder3to8 ed1 (in[2:0], d_out);

assign flag = in[3];
assign zero_byte = 8'b0;
assign out = flag ? {d_out, zero_byte} : {zero_byte, d_out};

endmodule

module e_decoder_tb;
reg [3:0] in;
wire [15:0] out;

always #1 in[0] = ~in[0];
always #2 in[1] = ~in[1];
always #4 in[2] = ~in[2];
always #8 in[3] = ~in[3];

e_decoder4to16 dut (in, out);

initial begin
    $display("DCBA |       out      ");
    $monitor("%b | %b", in, out);
    in = 0;
    #16 $finish(0);
end

endmodule