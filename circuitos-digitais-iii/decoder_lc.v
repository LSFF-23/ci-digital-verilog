module rom8x8 (clk, address, data_out);
input clk;
input [2:0] address;
output [7:0] data_out;

reg [7:0] rom [0:7];

initial begin
    rom[0] = 1;
    rom[1] = 1;
    rom[2] = 2;
    rom[3] = 3;
    rom[4] = 5;
    rom[5] = 8;
    rom[6] = 13;
    rom[7] = 21;
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

module decoder_lc (clk, we, address, din, dout);
input clk, we;
input [6:0] address;
input [7:0] din;
output [7:0] dout;

wire [7:0] rom_wire [0:7];
wire [7:0] sram_wire [0:7];

generate
    genvar i;

    for (i = 0; i < 8; i = i + 1) begin: ROM_BLOCK
        rom8x8 rom (clk, address[2:0], rom_wire[i]);
    end

    for (i = 0; i < 8; i = i + 1) begin: SRAM_BLOCK
        sram8x8 sram (clk, we, address[2:0], din, sram_wire[i]);
    end
endgenerate

assign dout = address[6:5] < 2 ? rom_wire[address[4:3]] : sram_wire[address[4:3]];

endmodule