`timescale 1ns/1ps

module add_subtractor_4bit_tb;

    reg  [3:0] a, b;
    reg        mode;
    wire [3:0] sum;
    wire       cout;

    reg  [4:0] expected;
    integer errors;
    integer i, j, k;

    adder_subtractor_4bit dut (
        .a(a),
        .b(b),
        .mode(mode),
        .sum(sum),
        .cout(cout)
    );

    task run_case;
        input [3:0] ta, tb;
        input       tmode;
        begin
            a    = ta;
            b    = tb;
            mode = tmode;
            #1;

            if (tmode == 1'b0)
                expected = {1'b0, ta} + {1'b0, tb};
            else
                expected = {1'b0, ta} + {1'b0, ~tb} + 5'b00001;

            if ((sum !== expected[3:0]) || (cout !== expected[4])) begin
                $display("FAIL: mode=%0b a=%b b=%b -> sum=%b cout=%b | expected sum=%b cout=%b",
                         mode, a, b, sum, cout, expected[3:0], expected[4]);
                errors = errors + 1;
            end
            else begin
                $display("PASS: mode=%0b a=%b b=%b -> sum=%b cout=%b",
                         mode, a, b, sum, cout);
            end
        end
    endtask

    initial begin
        errors = 0;

        // mode = 0 -> add
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                run_case(i[3:0], j[3:0], 1'b0);
            end
        end

        // mode = 1 -> subtract
        for (i = 0; i < 16; i = i + 1) begin
            for (k = 0; k < 16; k = k + 1) begin
                run_case(i[3:0], k[3:0], 1'b1);
            end
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule