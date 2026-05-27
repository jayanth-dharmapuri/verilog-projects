module alu1bit (
    input wire a,b,cin,
    input wire [1:0] sel,
    output reg y,
    output reg cout
);

always @(*) begin 
    case (sel)
        2'b00 : begin 
            y = a & b;
            cout = 1'b0;
        end 
        2'b01 : begin 
            y = a | b;
            cout = 1'b0;
        end 
        2'b10 : begin 
            y = a ^ b;
            cout = 1'b0;
        end 
        2'b11 : begin 
            y = a ^ b ^ cin;
            cout = (a&b) | (cin&b) | (cin&a) ;
        end 
        default: begin
            y    = 1'b0;
            cout = 1'b0;
        end
    endcase
end 
endmodule