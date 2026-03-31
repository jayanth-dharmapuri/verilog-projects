module dec(
    input wire [2:0] ip,
    output reg [7:0] y
);
    always @(*) begin
    case (ip)
        3'd0 : y = 8'd1;
        3'd1 : y = 8'd2;
        3'd2 : y = 8'd4;
        3'd3 : y = 8'd8;
        3'd4 : y = 8'd16;
        3'd5 : y = 8'd32;
        3'd6 : y = 8'd64;
        3'd7 : y = 8'd128;
        default: y = 8'd0;
    endcase
    end
endmodule

/*
module dec(
    input  wire [2:0] ip,
    output wire [7:0] y
);

assign y = 8'b00000001 << ip;

endmodule
*/