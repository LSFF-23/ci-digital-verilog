module decodificador_2x4 (B, A, Y3, Y2, Y1, Y0);
input B, A; // B = MSB
output reg Y3, Y2, Y1, Y0; // Y3 = MSB

always @* begin
    {Y3, Y2, Y1, Y0} = 4'b0;
    case ({B, A})
        2'b00: Y0 = 1;
        2'b01: Y1 = 1;
        2'b10: Y2 = 1;
        2'b11: Y3 = 1;
        default: {Y3, Y2, Y1, Y0} = 4'bx;
    endcase
end

endmodule

module decodificador_2x4_tb;
reg B, A;
wire Y3, Y2, Y1, Y0;

always #1 A = !A;
always #2 B = !B;

decodificador_2x4 dut (B, A, Y3, Y2, Y1, Y0);

initial begin
    $display("BA | Y3 | Y2 | Y1 | Y0");
    $monitor("%b%b | %2b | %2b | %2b | %2b", B, A, Y3, Y2, Y1, Y0);
    B = 0; A = 0;
    #4 $finish(0);
end

endmodule