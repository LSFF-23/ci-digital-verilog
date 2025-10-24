module dcba27segments (
    input [3:0] dcba,
    output reg [6:0] segments 
);

always @ (*) begin
    case (dcba)
        4'b0000: segments = 7'b0000001;
        4'b0001: segments = 7'b1001111;
        4'b0010: segments = 7'b0010010;
        4'b0011: segments = 7'b0000110;
        4'b0100: segments = 7'b1001100;
        4'b0101: segments = 7'b0100100;
        4'b0110: segments = 7'b0100000;
        4'b0111: segments = 7'b0001111;
        4'b1000: segments = 7'b0000000;
        4'b1001: segments = 7'b0000100;
        4'b1010: segments = 7'b0001000; // A
        4'b1011: segments = 7'b1100000; // b
        4'b1100: segments = 7'b0110001; // C
        4'b1101: segments = 7'b1000010; // d
        4'b1110: segments = 7'b0110000; // E
        4'b1111: segments = 7'b0111000; // F
        default: segments = 7'b1111111;
    endcase
end

endmodule

module dcba27segments_tb;
reg [3:0] dcba;
wire [6:0] segments;

dcba27segments dut (dcba, segments);

always #1 dcba[0] = !dcba[0];
always #2 dcba[1] = !dcba[1];
always #4 dcba[2] = !dcba[2];
always #8 dcba[3] = !dcba[3];

initial begin
    $display("DCBA | SEGMENT");
    $monitor("%b | %b", dcba, segments);
    dcba = 4'b0000;
    #16 $finish;
end

endmodule