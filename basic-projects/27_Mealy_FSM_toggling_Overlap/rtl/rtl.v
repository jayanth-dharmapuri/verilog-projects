module seq_det_toggle_1011010110 (
    input  wire clk,
    input  wire rstn,
    input  wire en,
    input  wire x,
    output reg  z
);

    reg  [3:0] state, next_state;
    wire detect;

    localparam S0 = 4'd0,
               S1 = 4'd1,
               S2 = 4'd2,
               S3 = 4'd3,
               S4 = 4'd4,
               S5 = 4'd5,
               S6 = 4'd6,
               S7 = 4'd7,
               S8 = 4'd8,
               S9 = 4'd9;

    // state register
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            state <= S0;
        else if (en)
            state <= next_state;
    end

    // next-state logic
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S3 : S0;
            S3: next_state = x ? S4 : S2;
            S4: next_state = x ? S1 : S5;
            S5: next_state = x ? S6 : S0;
            S6: next_state = x ? S4 : S7;
            S7: next_state = x ? S8 : S0;
            S8: next_state = x ? S9 : S2;
            S9: next_state = x ? S1 : S5;   // overlap keeps "10110"
            default: next_state = S0;
        endcase
    end

    // detect full pattern 1011010110
    assign detect = en && (state == S9) && (x == 1'b0);

    // toggling output
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            z <= 1'b0;
        else if (detect)
            z <= ~z;
    end

endmodule