module rom8x8 #(parameter NOISE = 8'b0) (clk, address, data_out);
input clk;
input [2:0] address;
output reg [7:0] data_out;

always @(posedge clk) begin
    case (address)
        3'd0: data_out <= 8'd1 + NOISE;
        3'd1: data_out <= 8'd1 + NOISE;
        3'd2: data_out <= 8'd2 + NOISE;
        3'd3: data_out <= 8'd3 + NOISE;
        3'd4: data_out <= 8'd5 + NOISE;
        3'd5: data_out <= 8'd8 + NOISE;
        3'd6: data_out <= 8'd13 + NOISE;
        3'd7: data_out <= 8'd21 + NOISE;
    endcase
end

endmodule

module sram8x8 (clk, we, address, data_in, data_out);
input clk, we;
input [2:0] address;
input [7:0] data_in;
output [7:0] data_out;

reg [7:0] sram [0:7];

always @(posedge clk) if (we) sram[address] <= data_in;

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
        rom8x8#(i[7:0]) rom (clk, address[2:0], rom_wire[i]);
        sram8x8 sram (clk, (we & address[6] & ~(|(address[5:3] ^ i))), address[2:0], din, sram_wire[i]);
    end
endgenerate

assign dout = address[6] ? sram_wire[address[5:3]] : rom_wire[address[5:3]];

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