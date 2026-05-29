module fsm_110100_moore (
    input  wire clk,
    input  wire rst_n,
    input  wire d,
    output reg  x
);

    reg [2:0] st, nst;

    localparam S0 = 3'd0,  // no match
               S1 = 3'd1,  // 1
               S2 = 3'd2,  // 11
               S3 = 3'd3,  // 110
               S4 = 3'd4,  // 1101
               S5 = 3'd5,  // 11010
               S6 = 3'd6;  // 110100 detected

    // present state register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            st <= S0;
        else
            st <= nst;
    end

    // next state logic
    always @(*) begin
        case (st)
            S0: nst = d ? S1 : S0;
            S1: nst = d ? S2 : S0;
            S2: nst = d ? S2 : S3;
            S3: nst = d ? S4 : S0;
            S4: nst = d ? S2 : S5;  // overlap on "11"
            S5: nst = d ? S1 : S6;  // got full 110100
            S6: nst = d ? S1 : S0;  // move out of detect state
            default: nst = S0;
        endcase
    end

    // output logic
    always @(*) begin
        if (st == S6)
            x = 1'b1;
        else
            x = 1'b0;
    end

endmodule