module updown_counter (
    input  wire       clk,
    input  wire       rstn,
    input  wire       up_down,
    output reg  [3:0] count
);

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        count <= 4'b0000;
    else if (up_down)
        count <= count + 1'b1;
    else
        count <= count - 1'b1;
end

endmodule