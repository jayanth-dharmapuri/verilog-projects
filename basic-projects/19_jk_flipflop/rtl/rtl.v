module jk_flipflop (
    input  wire j,
    input  wire k,
    input  wire clk,
    input  wire rstn,
    output reg  q
);

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        q <= 1'b0;
    else begin
        case ({j, k})
            2'b00: q <= q;
            2'b01: q <= 1'b0;
            2'b10: q <= 1'b1;
            2'b11: q <= ~q;
            default: q <= q;
        endcase
    end
end

endmodule
