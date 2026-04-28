module pipeline_sum #(DATA_WIDTH = 16) (
    input clk,
    input [DATA_WIDTH-1:0] a, b,
    output [2*DATA_WIDTH-1:0] r
);

logic [DATA_WIDTH-1:0] r_or, r_xor, r_div, r_slb;
assign r_or = a | b;
assign r_xor = a ^ b;
assign r_div = a / b;
assign r_slb = a << b;

logic [DATA_WIDTH-1:0] or_reg, xor_reg, div_reg, slb_reg;
always_ff @(posedge clk) begin
	  or_reg <= r_or;
	  xor_reg <= r_xor;
	  div_reg <= r_div;
	  slb_reg <= r_slb;
end

logic [2*DATA_WIDTH-1:0] partial_sum1, partial_sum2;
always_ff @(posedge clk) begin
	  partial_sum1 <= or_reg + div_reg;
	  partial_sum2 <= xor_reg + slb_reg;
end

logic [2*DATA_WIDTH-1:0] full_sum;
always_ff @(posedge clk) begin
     full_sum <= partial_sum1 + partial_sum2;
end

assign r = full_sum;

endmodule