module mux4_1(
    input  wire a1,
    input  wire a2,
    input  wire a3,
    input  wire a4,
    input  wire [1:0] sel,
    output reg  y
);

always @(*) begin
    case (sel)
        2'b00: y = a1;
        2'b01: y = a2;
        2'b10: y = a3;
        2'b11: y = a4;
        default: y = 1'b0;
    endcase
end

endmodule

/*
module mux4_1 (
    input  wire a1,
    input  wire a2,
    input  wire a3,
    input  wire a4,
    input  wire s1,
    input  wire s2,
    output reg  y
);

always @(*) begin
    case ({s1, s2})
        2'b00: y = a1;
        2'b01: y = a2;
        2'b10: y = a3;
        2'b11: y = a4;
        default: y = 1'b0;
    endcase
end

endmodule
*/

/*
module mux4_1 (
    input  wire a1,
    input  wire a2,
    input  wire a3,
    input  wire a4,
    input  wire s1,
    input  wire s2,
    output wire y
);

assign y = (~s1 & ~s2 & a1) |
           (~s1 &  s2 & a2) |
           ( s1 & ~s2 & a3) |
           ( s1 &  s2 & a4);

endmodule
*/