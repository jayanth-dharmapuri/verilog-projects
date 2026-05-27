module siso_shift_register (
    input  wire clk,
    input  wire rst_n,
    input  wire sin,
    output wire sout
);

reg [3:0] shreg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shreg <= 4'b0000;
    else
        shreg <= {shreg[2:0], sin};
end

assign sout = shreg[3];

endmodule


module sipo_shift_register (
    input  wire clk,
    input  wire rst_n,
    input  wire sin,
    output reg  [3:0] pout
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        pout <= 4'b0000;
    else
        pout <= {pout[2:0], sin};
end

endmodule


module piso_shift_register (
    input  wire clk,
    input  wire rst_n,
    input  wire load,
    input  wire [3:0] pin,
    output wire sout
);

reg [3:0] shreg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shreg <= 4'b0000;
    else if (load)
        shreg <= pin;
    else
        shreg <= {shreg[2:0], 1'b0};
end

assign sout = shreg[3];

endmodule


module pipo_register (
    input  wire clk,
    input  wire rst_n,
    input  wire [3:0] pin,
    output reg  [3:0] pout
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        pout <= 4'b0000;
    else
        pout <= pin;
end

endmodule