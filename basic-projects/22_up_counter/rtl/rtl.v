module upc (
    input  wire clk,
    input  wire rstn,
    output reg  [3:0] count
);

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        count <= 4'd0;
    else
        count <= count + 1'b1;
end

endmodule