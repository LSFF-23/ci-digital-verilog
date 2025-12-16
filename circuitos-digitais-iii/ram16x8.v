module ram16x8 (clk, address, data_in, we, data_out);
input clk, we;
input [3:0] address;
input [7:0] data_in;
output [7:0] data_out;

reg [7:0] ram[0:15];

always @(posedge clk) if (we) ram[address] <= data_in;

assign data_out = ram[address];

endmodule

module ram16x8_tb;
reg clk, we;
reg [3:0] address;
reg [7:0] data_in;
wire [7:0] data_out;
integer i;

ram16x8 dut (.clk(clk), 
            .we(we), 
            .address(address), 
            .data_in(data_in),
            .data_out(data_out));

initial begin
    clk = 0;
    forever #5 clk = !clk;
end

initial begin
    we = 1;
    for (i = 0; i < 16; i = i + 1) begin
        address = i; data_in = i * 2; #10;
    end
    we = 0;
    for (i = 0; i < 16; i = i + 1) begin
        address = i; #10;
    end
	 $stop(0);
end

endmodule