module rom16x8 (address, data_out);
input [3:0] address;
output reg [7:0] data_out;

always @* begin
	case (address)
        0: data_out = 8'h00;
        1: data_out = 8'h11;
        2: data_out = 8'h22;
        3: data_out = 8'h33;
        4: data_out = 8'h44;
        5: data_out = 8'h55;
        6: data_out = 8'h66;
        7: data_out = 8'h77;
        8: data_out = 8'h88;
        9: data_out = 8'h99;
        10: data_out = 8'hAA;
        11: data_out = 8'hBB;
        12: data_out = 8'hCC;
        13: data_out = 8'hDD;
        14: data_out = 8'hEE;
        15: data_out = 8'hFF;
		default: data_out = 8'h00;
	endcase
end

endmodule

module rom16x8_tb;
reg [3:0] address;
wire [7:0] data_out;
integer i;

rom16x8 dut (address, data_out);

initial begin
    for (i = 0; i < 16; i = i + 1) begin
        address = i; #10;
    end
    $stop(0);
end

endmodule