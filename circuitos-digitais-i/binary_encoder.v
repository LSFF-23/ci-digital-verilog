module binary_encoder #(parameter M = 8) (in, out);
localparam N = $clog2(M);
input [M-1:0] in;
output reg [N-1:0] out;
integer i;

always @* begin
  out = 0;
  for (i = 0; i < M; i = i + 1) begin
    if (in[i] == 1) 
      out = i;
  end
end

endmodule

module binary_encoder_tb;
localparam M = 16;
localparam N = $clog2(M);

reg [M-1:0] in;
wire [N-1:0] out;

binary_encoder#(M) dut (in, out);

always #1 in = in << 1;

initial begin
    $monitor("%b | %b", in, out);
    in = 1;
    #M $finish(0);
end

endmodule