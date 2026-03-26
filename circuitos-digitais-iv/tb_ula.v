module tb_ula;
reg [7:0] A, B;
reg [2:0] opcode;
wire [7:0] C;

ula dut (A, B, opcode, C);

initial begin
    // soma
    opcode = 3'b000; A = 8'd200; B = 8'd50; #10;
    // soma no limite
    A = 8'd199; B = 8'd56; #10
    // produto
    opcode = 3'b010; A = 8'd10; B = 8'd20; #10
    // and
    opcode = 3'b100; A = 8'b1111_0000; B = 8'b1010_1010; #10
    // or com os mesmos valores acima
    opcode = 3'b101; #10
    $stop(0);
end

endmodule