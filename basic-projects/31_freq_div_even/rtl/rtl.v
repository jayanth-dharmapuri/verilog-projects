module clk_div_by_4 (
    input  wire clk,
    input  wire rst,
    output wire clk_div4
);

    reg [1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 2'b00;
        else
            count <= count + 1'b1;
    end

    assign clk_div4 = count[1];

endmodule