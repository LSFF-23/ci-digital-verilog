module encoder8to3 (in, out);
input [7:0] in;
output reg [2:0] out;

always @* begin
  casex (in)
    8'b0000_0001: out = 3'b000;
    8'b0000_001x: out = 3'b001;
    8'b0000_01xx: out = 3'b010;
    8'b0000_1xxx: out = 3'b011;
    8'b0001_xxxx: out = 3'b100;
    8'b001x_xxxx: out = 3'b101;
    8'b01xx_xxxx: out = 3'b110;
    8'b1xxx_xxxx: out = 3'b111;
    default: out = 3'b000;
  endcase
end

endmodule

module encoder16to4 (in, out);
input [15:0] in;
output [3:0] out;

wire [2:0] left_part, right_part, selected_part;
wire flag;

encoder8to3 left(.in(in[15:8]), .out(left_part));
encoder8to3 right(.in(in[7:0]), .out(right_part));

assign flag = |in[15:8]; // X =| X : OR entre todos os bits
assign selected_part = ({4{flag}} & left_part) | (~{4{flag}} & right_part);
assign out = {flag, selected_part};

endmodule

module encoder16to4_tb;
reg [15:0] in;
wire [3:0] out;

encoder16to4 dut (in, out);

always #1 in = in << 1;

initial begin
    $display("        in        |  out ");
    $monitor(" %b | %b", in, out);
    in = 1;
    #16 $finish(0);
end

endmodule