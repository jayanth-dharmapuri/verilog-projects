module comp4 (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire lt, eq, gt
);

    assign lt = (a < b);
    assign eq = (a==b);
    assign gt = (a>b);

endmodule