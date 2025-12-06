module shift_add #(parameter N = 4) (a, b, result);
input [N-1:0] a, b;
output [2*N-1:0] result;

reg [2*N-1:0] A;
reg [$clog2(N)-1:0] counter;

always @* begin
    A = 0;
    for (counter = 0; {1'b0, counter} < N - 1; counter = counter + 1) begin
        A = b[counter] ? A + ({{N{1'b0}}, a} << counter) : A;
    end
    A = b[N - 1] ? A + ({{N{1'b0}}, a} << (N - 1)) : A;
end

assign result = A;

endmodule