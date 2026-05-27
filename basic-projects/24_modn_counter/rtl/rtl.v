module mod13_loadable_updown_counter (
    input  wire       clk,
    input  wire       rstn,
    input  wire       mode,      // 1 = up, 0 = down
    input  wire       load_en,
    input  wire [3:0] load,
    output reg  [3:0] count
);

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        count <= 4'd0;
    else if (load_en) begin
        if (load <= 4'd12)
            count <= load;
        else
            count <= 4'd0;
    end
    else if (mode) begin
        if (count == 4'd12)
            count <= 4'd0;
        else
            count <= count + 1'b1;
    end
    else begin
        if (count == 4'd0)
            count <= 4'd12;
        else
            count <= count - 1'b1;
    end
end

endmodule