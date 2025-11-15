module ula (
    input [2:0] a, b, sel,
    output reg cout,
    output reg [2:0] result
);

    always @(*) begin
        cout = 0;
        case (sel)
            3'b000: {cout, result} = a + b;
            3'b001: {cout, result} = a - b;
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            3'b101: result = ~a;
            3'b110: result = ~a + 1;
            3'b111: result = a / b;
            default: result = 0;
        endcase
    end

endmodule

module ula_tb;
reg [2:0] a, b, sel;
wire [2:0] result;
wire cout;

ula dut (a, b, sel, cout, result);

initial begin
    $monitor("%b | %b | %b | %b | %b", sel, a, b, cout, result);
    sel = 0; a = 1; b = 2;
    #1 sel = 1; a = 7; b = 2;
    #1 sel = 2; a = 3'b101; b = 3'b010;
    #1 sel = 3; a = 3'b010; b = 3'b101;
    #1 sel = 4; a = 3'b001; b = 3'b110;
    #1 sel = 5; a = 3'b000;
    #1 sel = 6; a = 3'b101;
    #1 sel = 7; a = 6; b = 3;
    #1 sel = 3'bx;
    #1 $finish(0);
end

endmodule