module register_4bits (clk, d, q, rst);
input [3:0] d;
output reg [3:0] q;
input clk, rst;

always @(posedge clk or posedge rst) begin
    if (rst) q <= 0;
    else q <= d;
end

endmodule

module mux2x1_4bits (in0, in1, out, sel);
input [3:0] in1, in0;
output [3:0] out;
input sel;

assign out = sel ? in1 : in0;

endmodule

module demux1x2_4bits (in, out1, out0, sel);
input [3:0] in;
output reg [3:0] out1, out0;
input sel;

always @* begin
    out1 = 0; out0 = 0;
    if (sel) out1 = in;
    else out0 = in;
end

endmodule

module register_file (addr, clk, data_in, data_out, we);
input [1:0] addr;
input clk, we;
input [3:0] data_in;
output reg [3:0] data_out;

reg [3:0] A, B, C, D;

always @(posedge clk) begin
    case (addr)
        2'b00: begin
            if (we) A <= data_in;
            data_out <= A;
        end
        2'b01: begin
            if (we) B <= data_in;
            data_out <= B;
        end
        2'b10: begin
            if (we) C <= data_in;
            data_out <= C;
        end
        2'b11: begin
            if (we) D <= data_in;
            data_out <= D;
        end
    endcase
end

endmodule

module ula (A, B, carry_in, carry_out, resultado, seletor);
    input [3:0] A, B;
    input carry_in;
    output reg carry_out;
    output reg [3:0] resultado;
    input [2:0] seletor;

    always @(*) begin
        carry_out = 0;
        case (seletor)
            3'b000: {carry_out, resultado} = A + B + carry_in;
            3'b001: {carry_out, resultado} = A + (~B + 1) + (~carry_in + 1);
            3'b010: resultado = A & B;
            3'b011: resultado = A | B;
            3'b100: resultado = A ^ B;
            3'b101: resultado = ~(A ^ B);
            3'b111: resultado = ~A;
            default: resultado = 0;
        endcase
    end

endmodule

