module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire carry
);

assign sum   = a ^ b ^ cin;
assign carry = (a & b) | (b & cin) | (cin & a);

endmodule


module adder_subtractor_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire mode,          // 0 = add, 1 = subtract
    output wire [3:0] sum,
    output wire cout
);

wire [3:0] bx;
wire c1, c2, c3;

assign bx = b ^ {4{mode}};

full_adder fa0 (
    .a(a[0]),
    .b(bx[0]),
    .cin(mode),
    .sum(sum[0]),
    .carry(c1)
);

full_adder fa1 (
    .a(a[1]),
    .b(bx[1]),
    .cin(c1),
    .sum(sum[1]),
    .carry(c2)
);

full_adder fa2 (
    .a(a[2]),
    .b(bx[2]),
    .cin(c2),
    .sum(sum[2]),
    .carry(c3)
);

full_adder fa3 (
    .a(a[3]),
    .b(bx[3]),
    .cin(c3),
    .sum(sum[3]),
    .carry(cout)
);

endmodule