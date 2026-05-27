module sr_flipflop (
    input  wire s,
    input  wire r,
    input  wire clk,
    input  wire rstn,
    output reg  q
);

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        q <= 1'b0;
    else begin
        case ({s, r})
            2'b00: q <= q;
            2'b01: q <= 1'b0;
            2'b10: q <= 1'b1;
            2'b11: q <= 1'bx;
            default: q <= q;
        endcase
    end
end

endmodule
