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

module write_enabler (clk, we, address, result);
input clk, we;
input [3:0] address;
output reg [7:0] result;

always @(posedge clk) begin
    result <= 8'b0;
    result[address[2:0]] <= we & address[3];
end

endmodule

module decoder_rc   (clk, 
                    rom_net0, rom_net1, rom_net2, rom_net3, 
                    rom_net4, rom_net5, rom_net6, rom_net7,
                    sram_net0, sram_net1, sram_net2, sram_net3,
                    sram_net4, sram_net5, sram_net6, sram_net7,
                    address, dout);
input clk;
input [7:0] rom_net0, rom_net1, rom_net2, rom_net3;
input [7:0] rom_net4, rom_net5, rom_net6, rom_net7;
input [7:0] sram_net0, sram_net1, sram_net2, sram_net3;
input [7:0] sram_net4, sram_net5, sram_net6, sram_net7;
input [3:0] address;
output reg [7:0] dout;

always @(posedge clk) begin
    if (!address[3])
        case (address[2:0])
            3'd0: dout <= rom_net0;
            3'd1: dout <= rom_net1;
            3'd2: dout <= rom_net2;
            3'd3: dout <= rom_net3;
            3'd4: dout <= rom_net4;
            3'd5: dout <= rom_net5;
            3'd6: dout <= rom_net6;
            3'd7: dout <= rom_net7;
        endcase
    else
        case (address[2:0])
            3'd0: dout <= sram_net0;
            3'd1: dout <= sram_net1;
            3'd2: dout <= sram_net2;
            3'd3: dout <= sram_net3;
            3'd4: dout <= sram_net4;
            3'd5: dout <= sram_net5;
            3'd6: dout <= sram_net6;
            3'd7: dout <= sram_net7;
        endcase
end

endmodule

module memory4x4 (clk, we, address, din, dout);
input clk, we;
input [6:0] address;
input [7:0] din;
output [7:0] dout;

wire [7:0] rom_wire [0:7];
wire [7:0] sram_wire [0:7];
wire [7:0] we_wire;

write_enabler enabler (clk, we, address[6:3], we_wire);
decoder_rc drc  (clk, 
                rom_wire[0], rom_wire[1], rom_wire[2], rom_wire[3], 
                rom_wire[4], rom_wire[5], rom_wire[6], rom_wire[7],
                sram_wire[0], sram_wire[1], sram_wire[2], sram_wire[3],
                sram_wire[4], sram_wire[5], sram_wire[6], sram_wire[7],
                address[6:3], dout);

generate
    genvar i;
    for (i = 0; i < 8; i = i + 1) begin: CONN_BLOCK
        rom8x8#(i[7:0]) rom (clk, address[2:0], rom_wire[i]);
        sram8x8 sram (clk, we_wire[i], address[2:0], din, sram_wire[i]);
    end
endgenerate

endmodule

module memory4x4_tb;
reg clk, we;
reg [6:0] address;
reg [7:0] din;
wire [7:0] dout;

memory4x4 dut (clk, we, address, din, dout);

initial begin
    clk = 0;
    forever #5 clk = !clk;
end

initial begin
    $stop(0);
end

endmodule
