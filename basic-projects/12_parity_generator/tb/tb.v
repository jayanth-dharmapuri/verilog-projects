`timescale 1ns/1ps

module parity_generator_tb;

    reg  [3:0] a;
    wire even_p, odd_p;

    reg expected_even, expected_odd;
    integer errors;
    integer i;

    parity_generator dut (
        .a(a),
        .even_p(even_p),
        .odd_p(odd_p)
    );

    task run_case;
        input [3:0] ta;
        begin
            a = ta;
            #1;

            expected_even = ^ta;
            expected_odd  = ~^ta;

            if ((even_p !== expected_even) || (odd_p !== expected_odd)) begin
                $display("FAIL: a=%b -> even_p=%b odd_p=%b | expected even_p=%b odd_p=%b",
                         a, even_p, odd_p, expected_even, expected_odd);
                errors = errors + 1;
            end
            else begin
                $display("PASS: a=%b -> even_p=%b odd_p=%b",
                         a, even_p, odd_p);
            end
        end
    endtask

    initial begin
        errors = 0;

        for (i = 0; i < 16; i = i + 1) begin
            run_case(i[3:0]);
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule