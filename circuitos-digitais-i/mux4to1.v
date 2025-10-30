module mux4to1 #(parameter N = 8) (
    input [N-1:0] D3, D2, D1, D0,
    input [1:0] sel,
    output reg [N-1:0] out
);

always @* begin
    case (sel)
        2'b00: out = D0;
        2'b01: out = D1;
        2'b10: out = D2;
        2'b11: out = D3;
        default: out = {N{1'bx}};
    endcase
end

endmodule

module mux4to1_tb;
parameter N = 4;
reg [N-1:0] D3, D2, D1, D0;
reg [1:0] sel;
wire [N-1:0] out;

mux4to1#(N) dut (D3, D2, D1, D0, sel, out);

always #1 sel[0] = !sel[0];
always #2 sel[1] = !sel[1];

initial begin
    $display("  D3  |  D2  |  D1  |  D0  | sel | out ");
    $monitor(" %4b | %4b | %4b | %4b | %3b | %b", D3, D2, D1, D0, sel, out);
    sel = 0;
    D3 = 4'b1111; D2 = 4'b0111; D1 = 4'b0011; D0 = 4'b0001;
    #4 $finish(0);
end

endmodule
