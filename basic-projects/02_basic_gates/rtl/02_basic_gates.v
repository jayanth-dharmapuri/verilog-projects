module gates (
    input wire a,
    input wire b,
    output wire inv, aand, aor, anand, anor, axor, axnor 
);
    assign inv = ~a;
    assign aand = a & b;
    assign aor = a | b;
    assign anand = ~(a&b);
    assign anor = ~(a|b);
    assign axor = a ^ b;
    assign axnor = ~(a ^ b);

 endmodule