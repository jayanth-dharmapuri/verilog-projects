module parity_generator (
    input  wire [3:0] a,
    output wire even_p,
    output wire odd_p
);

assign even_p = ^a;   // reduction XOR
assign odd_p  = ~^a;  // reduction XNOR

endmodule