module booth #(parameter N = 4) (a, b, result);
input [N-1:0] a, b;
output reg [2*N-1:0] result;

reg [N-1:0] A, Q, M;
reg QM1, sign;
integer i;

always @* begin
    Q = a; M = b;
    A = 0; QM1 = 0;
    for (i = 0; i < N; i = i + 1) begin
        case ({Q[0], QM1})
            2'b00, 2'b11: result = 0;
            2'b01: A = A + M;
            2'b10: A = A - M;
        endcase
        sign = A[N-1];
        {A, Q, QM1} = {A, Q, QM1} >> 1;
        A[N-1] = sign;
    end
    result = {A, Q};
end

endmodule

module booth_tb;
reg [3:0] a, b;
wire [7:0] result;

booth dut (a, b, result);

initial begin
    a = 3; b = 2; #5;
    a = 4; b = 3; #5;
    a = -2; b = 5; #5;
    a = -8; b = -8; #5;
    $finish(0);
end

endmodule