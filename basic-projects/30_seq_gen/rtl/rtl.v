module seq_generator_1011010110 (
    input  wire clk,
    input  wire rst,
    output reg  seq_out
);

    reg [3:0] count;

    // counter
    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 4'd0;
        else if (count == 4'd9)
            count <= 4'd0;
        else
            count <= count + 1'b1;
    end

    // output logic
    always @(*) begin
        case (count)
            4'd0: seq_out = 1'b1;
            4'd1: seq_out = 1'b0;
            4'd2: seq_out = 1'b1;
            4'd3: seq_out = 1'b1;
            4'd4: seq_out = 1'b0;
            4'd5: seq_out = 1'b1;
            4'd6: seq_out = 1'b0;
            4'd7: seq_out = 1'b1;
            4'd8: seq_out = 1'b1;
            4'd9: seq_out = 1'b0;
            default: seq_out = 1'b0;
        endcase
    end

endmodule