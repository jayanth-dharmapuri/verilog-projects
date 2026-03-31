module dmux (
    input  wire ip,
    input  wire s1,
    input  wire s2,
    output wire y1,
    output wire y2,
    output wire y3,
    output wire y4
);

assign y1 = (~s1) & (~s2) & ip;
assign y2 = (~s1) & ( s2) & ip;
assign y3 = ( s1) & (~s2) & ip;
assign y4 = ( s1) & ( s2) & ip;

endmodule