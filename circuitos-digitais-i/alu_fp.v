module alu_fp (a, b, cin, opcode, result, cout);
input [7:0] a, b;
input cin;
input [1:0] opcode;
output reg [7:0] result;
output reg cout;

always @(*) begin
    case (opcode)
        2'b00: {cout, result} = a + b + cin;
        2'b01: {cout, result} = a - b - cin;
        default: {cout, result} = 8'b0;
    endcase
end

endmodule

module alu_fp_tb;
reg [7:0] a, b;
reg cin;
reg [1:0] opcode;
wire [7:0] result;
wire cout;

alu_fp dut (a, b, cin, opcode, result, cout);

initial begin
    $display("opcode | %8s | %8s | cin | cout | result", "a", "b");
    $monitor("%6b | %b | %b | %3b | %4b | %4b.%4b", opcode, a, b, cin, cout, result[7:4], result[3:0]);
    cin = 0;
    opcode = 0; a = 8'b01111000; b = 8'b00100100;
    #1 opcode = 1; a = 8'b01111000; b = 8'b00100100;
    #1 $finish(0);
end

endmodule