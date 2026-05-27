`timescale 1ns/1ps

module tb;

    reg a, b, cin;
    reg [1:0] sel;
    wire y, cout;

    reg expy, expcout;
    integer err;
    integer i, j, k, l;

    alu1bit al (
        .a(a),
        .b(b),
        .cin(cin),
        .sel(sel),
        .y(y),
        .cout(cout)
    );

    task run_case;
        input ax, bx, cx;
        input [1:0] selx;
        begin
            a   = ax;
            b   = bx;
            cin = cx;
            sel = selx;
            #5;

            case (sel)
                2'b00: begin
                    expy = ax & bx;
                    expcout = 0;
                end
                2'b01: begin
                    expy = ax | bx;
                    expcout = 0;
                end
                2'b10: begin
                    expy = ax ^ bx;
                    expcout = 0;
                end
                2'b11: begin
                    expy = ax ^ bx ^ cx;
                    expcout = (ax & bx) | (bx & cx) | (cx & ax);
                end
                default: begin
                    expy = 0;
                    expcout = 0;
                end
            endcase

            if ((y !== expy) || (cout !== expcout)) begin
                $display("FAIL: a=%b b=%b cin=%b sel=%b y=%b cout=%b | expected y=%b cout=%b",
                         a, b, cin, sel, y, cout, expy, expcout);
                err = err + 1;
            end
            else begin
                $display("PASS: a=%b b=%b cin=%b sel=%b y=%b cout=%b",
                         a, b, cin, sel, y, cout);
            end
        end
    endtask

    initial begin
        err = 0;

        for (i = 0; i < 2; i = i + 1) begin
            for (j = 0; j < 2; j = j + 1) begin
                for (k = 0; k < 2; k = k + 1) begin
                    for (l = 0; l < 4; l = l + 1) begin
                        run_case(i, j, k, l[1:0]);
                    end
                end
            end
        end

        if (err == 0)
            $display("NO ERRORS");
        else
            $display("TOTAL FAILURES = %0d", err);

        $finish;
    end

endmodule