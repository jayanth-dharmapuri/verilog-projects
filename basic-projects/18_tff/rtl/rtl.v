module tff (
    input  wire t,
    input  wire clk,
    input  wire rstn,
    output reg  q
);

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        q <= 1'b0;
    else if (t)
        q <= ~q;
    else
        q <= q;
end

endmodule