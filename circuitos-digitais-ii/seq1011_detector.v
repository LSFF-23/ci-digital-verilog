module seq1011_detector (clk, rst, id, out);
input clk, rst, id;
output reg out;

localparam S0 = 0;
localparam S1 = 1;
localparam S2 = 2;
localparam S3 = 3;
localparam S4 = 4;

reg [2:0] state;

always @(posedge clk) begin
    out <= 0;
    if (rst) begin
        state <= S0;
    end else begin
        case (state)
            S0: state <= id ? S1 : S0;
            S1: state <= id ? S1 : S2;
            S2: state <= id ? S3 : S0;
            S3: begin 
                if (id) begin
                    out <= 1;
                    state <= S4;
                end else begin
                    state <= S2;
                end
            end
            S4: state <= id ? S1 : S2;
            default: out <= 0;
        endcase
    end
end

endmodule