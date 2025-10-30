module demux1to8 (in, sel, out);
input in;
input [2:0] sel;
output reg [7:0] out;

always @* begin
    out = 8'b0;
    case (sel)
        3'b000: out[0] = in;
        3'b001: out[1] = in;
        3'b010: out[2] = in;
        3'b011: out[3] = in;
        3'b100: out[4] = in;
        3'b101: out[5] = in;
        3'b110: out[6] = in;
        3'b111: out[7] = in;
        default: out = 8'b0;
    endcase
end

endmodule

module demux1to8_tb;
reg in;
reg [2:0] sel;
wire [7:0] out;

demux1to8 dut (in, sel, out);

always #1 sel[0] = ~sel[0];
always #2 sel[1] = ~sel[1];
always #4 sel[2] = ~sel[2];
always #8 in = ~in;

initial begin
    $display("in | sel |   out   ");
    $monitor("%2b | %b | %b", in, sel, out);
    in = 1; sel = 0;
    #16 $finish(0);
end

endmodule