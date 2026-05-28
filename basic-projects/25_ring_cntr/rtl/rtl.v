module ring_counter (
    input  wire       clk,
    input  wire       rstn,
    output reg  [3:0] q
);

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        q <= 4'b0001;
    else
        q <= {q[2:0], q[3]};
end

endmodule