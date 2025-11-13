module register_file #(parameter INPUT_SIZE = 8) (data_in, data_out, sel, write_enable);
input [INPUT_SIZE-1:0] data_in;
input [1:0] sel;
output reg [INPUT_SIZE-1:0] data_out;
input write_enable;

reg [INPUT_SIZE-1:0] A, B, C, D;

always @(negedge write_enable) begin
    case (sel)
        2'b00: A = data_in;
        2'b01: B = data_in;
        2'b10: C = data_in;
        2'b10: D = data_in;
    endcase
end

always @(sel) begin
    case (sel)
        2'b00: data_out = A;
        2'b01: data_out = B;
        2'b10: data_out = C;
        2'b11: data_out = D;
    endcase
end

endmodule

module register_file_tb;
localparam INPUT_SIZE = 8;
reg [INPUT_SIZE-1:0] data_in;
wire [INPUT_SIZE-1:0] data_out;
reg [1:0] sel;
reg write_enable;

register_file dut (data_in, data_out, sel, write_enable);

always #1 write_enable = !write_enable;

initial begin
    $display("write_enable | %8s | sel | %8s | %8s | %8s | %8s | %8s", "data_in", "data_out", "A", "B", "C", "D");
    $monitor("%12b | %b | %3b | %b | %b | %b | %b | %b", write_enable, data_in, sel, data_out, dut.A, dut.B, dut.C, dut.D);
    write_enable = 1;
    #1 sel = 0; data_in = 42;
    #2 sel = 1; data_in = 13;
    #2 sel = 2; data_in = 31;
    #2 sel = 0;
    #2 $finish(0);
end

endmodule