`timescale 1ns/1ps

module parity_checker_tb;

    reg  [3:0] a;
    reg        parity_bit;
    wire       error;

    reg expected_error;
    integer errors;
    integer i, j;

    parity_checker dut (
        .a(a),
        .parity_bit(parity_bit),
        .error(error)
    );

    task run_case;
        input [3:0] ta;
        input       tp;
        begin
            a = ta;
            parity_bit = tp;
            #1;

            expected_error = ^{ta, tp};

            if (error !== expected_error) begin
                $display("FAIL: a=%b parity_bit=%b -> error=%b | expected error=%b",
                         a, parity_bit, error, expected_error);
                errors = errors + 1;
            end
            else begin
                $display("PASS: a=%b parity_bit=%b -> error=%b",
                         a, parity_bit, error);
            end
        end
    endtask

    initial begin
        errors = 0;

        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 2; j = j + 1) begin
                run_case(i[3:0], j[0]);
            end
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule