module parity_checker (
    input  wire [3:0] a,
    input  wire       parity_bit,
    output wire       error
);

assign error = ^{a, parity_bit};

endmodule