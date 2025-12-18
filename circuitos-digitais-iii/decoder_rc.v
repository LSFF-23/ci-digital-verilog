module rom8x8 #(parameter NOISE = 0) (clk, address, data_out);
input clk;
input [2:0] address;
output [7:0] data_out;

reg [7:0] rom [0:7];

initial begin
    rom[0] = 1 + NOISE;
    rom[1] = 1 + NOISE;
    rom[2] = 2 + NOISE;
    rom[3] = 3 + NOISE;
    rom[4] = 5 + NOISE;
    rom[5] = 8 + NOISE;
    rom[6] = 13 + NOISE;
    rom[7] = 21 + NOISE;
end

assign data_out = rom[address];

endmodule

module sram8x8 (clk, we, address, data_in, data_out);
input clk, we;
input [2:0] address;
input [7:0] data_in;
output [7:0] data_out;

reg [7:0] sram [0:7];

always @(posedge clk) begin
    if (we) sram[address] <= data_in;
end

assign data_out = sram[address];

endmodule

module decoder_rc (clk, we, address, din, dout);
input clk, we;
input [6:0] address;
input [7:0] din;
output [7:0] dout;

wire [7:0] rom_wire [0:7];
wire [7:0] sram_wire [0:7];

generate
    genvar i;
    for (i = 0; i < 8; i = i + 1) begin: CONN_BLOCK
        rom8x8#(i) rom (clk, address[2:0], rom_wire[i]);
        sram8x8 sram (clk, (address[6:5] >= 2 && address[4:3] == i), address[2:0], din, sram_wire[i]);
    end
endgenerate

assign dout = (address[6:5] < 2) ? rom_wire[address[4:3]] : sram_wire[address[4:3]];

endmodule

module decoder_rc_tb;
reg clk, we;
reg [6:0] address;
reg [7:0] din;
wire [7:0] dout;

decoder_rc dut (clk, we, address, din, dout);

initial begin
    clk = 0;
    forever #5 clk = !clk;
end

initial begin
    we = 1; address = 7'b00_00_000; din = 5; #10;
    we = 0; #10;
    we = 1; address = 7'b10_00_000; din = 10; #10;
    we = 0; #10;
    we = 1; address = 7'b11_01_001; din = 15; #10;
    we = 0; address = 7'b00_00_111; #10;
    we = 1; din = 20; #10;
    $stop(0);
end

endmodule