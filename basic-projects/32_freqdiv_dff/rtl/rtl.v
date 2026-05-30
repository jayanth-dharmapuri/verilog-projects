module dff (
    input  wire clk,
    input  wire rst,
    input  wire d,
    output reg  q
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule


module clk_div_by_4_dff (
    input  wire clk,
    input  wire rst,
    output wire clk_div2,
    output wire clk_div4
);

    wire d1, d2;

    // make each DFF toggle by feeding back inverted Q
    assign d1 = ~clk_div2;
    assign d2 = ~clk_div4;

    // first stage: divide by 2
    dff ff0 (
        .clk(clk),
        .rst(rst),
        .d(d1),
        .q(clk_div2)
    );

    // second stage: divide by 4
    dff ff1 (
        .clk(clk_div2),
        .rst(rst),
        .d(d2),
        .q(clk_div4)
    );

endmodule