module alu_4bit_extended (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    input  wire [5:0] sel,
    output reg  [3:0] y,
    output reg        cout
);

always @(*) begin
    y    = 4'b0000;
    cout = 1'b0;

    case (sel)

        // Arithmetic
        6'd0:  {cout, y} = {1'b0, a} + {1'b0, b} + cin;         // ADD
        6'd1:  {cout, y} = {1'b0, a} + {1'b0, ~b} + 5'b00001;   // SUB
        6'd2:  y = a * b;                                        // MUL (lower 4 bits only)
        6'd3:  y = (b != 0) ? (a / b) : 4'b0000;                 // DIV
        6'd4:  y = (b != 0) ? (a % b) : 4'b0000;                 // MOD

        // Bitwise
        6'd5:  y = a & b;                                        // AND
        6'd6:  y = a | b;                                        // OR
        6'd7:  y = a ^ b;                                        // XOR
        6'd8:  y = ~(a ^ b);                                     // XNOR
        6'd9:  y = ~(a & b);                                     // NAND
        6'd10: y = ~(a | b);                                     // NOR
        6'd11: y = ~a;                                           // NOT A

        // Shift
        6'd12: y = a << 1;                                       // Logical left shift
        6'd13: y = a >> 1;                                       // Logical right shift
        6'd14: y = $signed(a) >>> 1;                             // Arithmetic right shift

        // Reduction
        6'd15: y = {3'b000, &a};                                 // Reduction AND
        6'd16: y = {3'b000, |a};                                 // Reduction OR
        6'd17: y = {3'b000, ^a};                                 // Reduction XOR
        6'd18: y = {3'b000, ~&a};                                // Reduction NAND
        6'd19: y = {3'b000, ~|a};                                // Reduction NOR
        6'd20: y = {3'b000, ~^a};                                // Reduction XNOR

        // Relational / equality
        6'd21: y = {3'b000, (a == b)};                           // EQ
        6'd22: y = {3'b000, (a != b)};                           // NE
        6'd23: y = {3'b000, (a <  b)};                           // LT
        6'd24: y = {3'b000, (a <= b)};                           // LE
        6'd25: y = {3'b000, (a >  b)};                           // GT
        6'd26: y = {3'b000, (a >= b)};                           // GE

        // Logical
        6'd27: y = {3'b000, (a && b)};                           // Logical AND
        6'd28: y = {3'b000, (a || b)};                           // Logical OR
        6'd29: y = {3'b000, (!a)};                               // Logical NOT of vector a

        // Conditional
        6'd30: y = cin ? a : b;                                  // Ternary operator

        // Concatenation / replication
        6'd31: y = {a[1:0], b[1:0]};                             // Concatenation
        6'd32: y = {4{a[0]}};                                    // Replication

        default: begin
            y    = 4'b0000;
            cout = 1'b0;
        end
    endcase
end

endmodule