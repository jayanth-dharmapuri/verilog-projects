module penc (
    input  wire [7:0] ip,
    output reg  [2:0] op
);

always @(*) begin
    casex (ip)
        8'b1xxxxxxx: op = 3'b111;
        8'b01xxxxxx: op = 3'b110;
        8'b001xxxxx: op = 3'b101;
        8'b0001xxxx: op = 3'b100;
        8'b00001xxx: op = 3'b011;
        8'b000001xx: op = 3'b010;
        8'b0000001x: op = 3'b001;
        8'b00000001: op = 3'b000;
        default:     op = 3'b000;
    endcase
end

endmodule