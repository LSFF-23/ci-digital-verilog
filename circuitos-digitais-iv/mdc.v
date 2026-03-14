module mdc (clk, rst_n, start, A, B, out, done);
input clk, rst_n, start;
input [7:0] A, B;
output reg [7:0] out;
output reg done;

reg [1:0] state;
reg [7:0] A_aux, B_aux;

localparam IDLE = 2'b00;
localparam SUBTRACT = 2'b01;
localparam FINISHED = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        out <= 0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                state <= IDLE;
                if (start) begin
                    state <= SUBTRACT;
                    A_aux <= A;
                    B_aux <= B;
                end
            end
            SUBTRACT: begin
                state <= SUBTRACT;
                if (A_aux > B_aux)
                    A_aux <= A_aux - B_aux;
                else if (B_aux > A_aux)
                    B_aux <= B_aux - A_aux;
                else
                    state <= FINISHED;
            end
            FINISHED: begin
                state <= IDLE;
                done <= 1;
                out <= A_aux;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule