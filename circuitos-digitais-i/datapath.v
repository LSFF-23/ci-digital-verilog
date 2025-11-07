module register_4bits (clk, d, q, rst);
input [3:0] d;
output reg [3:0] q;
input clk, rst;

always @(posedge clk or posedge rst) begin
    if (rst) q <= 0;
    else if (we) q <= d;
end

endmodule

module mux2x1_4bits (in0, in1, out, sel);
input [3:0] in1, in0;
output [3:0] out;
input sel;

assign out = sel ? in1 : in0;

endmodule

module demux1x2_4bits (in, out1, out2, sel);
input [3:0] in;
output [3:0] out1, out0;
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

module ula #(parameter N = 4) (a, b, cb_in, sel, result, cb_out)
    input [N-1:0] a, b;
    input cb_in;
    output reg [N-1:0] result;
    output reg cb_out;

    always @(*) begin
        cb_out = 0;
        case (sel)
            3'b000: {cb_out, result} = a + b + cb_in;
            3'b001: {cb_out, result} = a + (~b + 1) + (~cb_in + 1);
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            3'b101: result = ~(a ^ b)
            3'b111: result = ~a;
            default: result = 0;
        endcase
    end

endmodule

