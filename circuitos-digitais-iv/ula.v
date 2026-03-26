module ula (
    input [7:0] A, B,
    input [2:0] opcode,
    output [7:0] C
);

reg [7:0] result;
always @* begin
    case (opcode)
        3'b000: result = A + B;
        3'b001: result = A - B;
        3'b010: result = A * B;
        3'b011: result = A / B;
        3'b100: result = A & B;
        3'b101: result = A | B;
        3'b110: result = ~A;
        3'b111: result = A ^ B;
        default: result = 8'bx;
    endcase
end

assign C = result;

endmodule