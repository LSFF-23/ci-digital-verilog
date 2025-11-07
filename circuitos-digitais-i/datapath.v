module register_4bits (clk, d, q, rst);
input [3:0] d;
output reg [3:0] q;
input clk, rst;

always @(posedge clk or posedge rst) begin
    if (rst) 
        q <= 0;
    else
        q <= d;
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
    if (sel) 
        out1 = in;
    else 
        out0 = in;
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
            if (we)
                A = data_in;
            data_out <= A;
        end
        2'b01: begin
            if (we)
                B = data_in;
            data_out <= B;
        end
        2'b10: begin
            if (we)
                C = data_in;
            data_out <= C;
        end
        2'b11: begin
            if (we)
                D = data_in;
            data_out <= D;
        end
    endcase
end

endmodule

module ula (A, B, carry_in, carry_out, result, sel);
    input [3:0] A, B;
    input carry_in;
    output reg carry_out;
    output reg [3:0] result;
    input [2:0] sel;

    always @(*) begin
        carry_out = 0;
        case (sel)
            3'b000: {carry_out, result} = A + B + carry_in;
            3'b001: {carry_out, result} = A + (~B + 1) + (~carry_in + 1);
            3'b010: result = A & B;
            3'b011: result = A | B;
            3'b100: result = A ^ B;
            3'b101: result = ~(A ^ B);
            3'b111: result = ~A;
            default: result = 0;
        endcase
    end

endmodule

module datapath_4bits (clk, rst, dados, opcode, reg_addr, write_enable, 
sel12, sel21, carry_in, result, carry_out);
input clk, rst, write_enable, sel12, sel21, carry_in;
input [1:0] reg_addr;
input [2:0] opcode;
input [3:0] dados;
output [3:0] result;
output carry_out;

wire [3:0] demux_in, demux_out0, demux_out1, reg0_q, reg1_q, mux_out;

register_4bits r1 (clk, demux_out0, reg0_q, rst);
register_4bits r2 (clk, demux_out1, reg1_q, rst);
register_file rf1 (reg_addr, clk, mux_out, demux_in, write_enable);
demux1x2_4bits demux (demux_in, demux_out1, demux_out0, sel12);
mux2x1_4bits mux (dados, result, mux_out, sel21);
ula u1 (reg0_q, reg1_q, carry_in, carry_out, result, opcode);

endmodule

module datapath_tb;
reg clk, rst, write_enable, sel12, sel21, carry_in;
reg [1:0] reg_addr;
reg [2:0] opcode;
reg [3:0] dados;
wire [3:0] result;
wire carry_out;

always #1 clk = !clk;

datapath_4bits dut (clk, rst, dados, opcode, reg_addr, write_enable, 
sel12, sel21, carry_in, result, carry_out);

initial begin
    $display("dados | opcode | addr | sel12 | sel21 | cin | result | cout");
    $monitor("%5b | %6b | %4b | %5b | %5b | %3b | %6b | %4b", dados, opcode, 
    reg_addr, sel12, sel21, carry_in, result, carry_out);
    clk = 0; write_enable = 1; sel21 = 0; carry_in = 0; opcode = 0; rst = 0;
    #1 sel12 = 0; reg_addr = 0; dados = 7;
    #4 sel12 = 1; reg_addr = 1; dados = 1;
    #4 sel12 = 0; reg_addr = 0; dados = 5;
    #4 sel12 = 1; reg_addr = 1; dados = 3;
    #4 sel12 = 0; reg_addr = 1; dados = 15;
    #4 opcode = 1;
    #4 rst = 1;
    #4 $finish(0);
end

endmodule