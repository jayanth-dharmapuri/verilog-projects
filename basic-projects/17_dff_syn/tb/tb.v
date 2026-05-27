`timescale 1ns/1ps

module tb;

    reg clk, rst_n, d;
    wire q;

    integer errors;

    d_flipflop_sync_reset dut (
        .clk(clk),
        .rst_n(rst_n),
        .d(d),
        .q(q)
    );

    // clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // apply d and rst_n at negedge, check q after next posedge
    task run_case;
        input td;
        input trst_n;
        input expected_q;
        begin
            @(negedge clk);
            d     = td;
            rst_n = trst_n;

            @(posedge clk);
            #1;

            if (q !== expected_q) begin
                $display("FAIL: rst_n=%b d=%b -> q=%b | expected q=%b",
                         rst_n, d, q, expected_q);
                errors = errors + 1;
            end
            else begin
                $display("PASS: rst_n=%b d=%b -> q=%b",
                         rst_n, d, q);
            end
        end
    endtask

    initial begin
        errors = 0;
        d      = 0;
        rst_n  = 1;

        // normal capture
        run_case(0, 1, 0);
        run_case(1, 1, 1);
        run_case(0, 1, 0);

        // apply reset -> q should become 0 only at clock edge
        run_case(1, 0, 0);

        // while reset remains active, q should stay 0
        run_case(1, 0, 0);
        run_case(0, 0, 0);

        // release reset, normal capture resumes
        run_case(1, 1, 1);
        run_case(0, 1, 0);
        run_case(1, 1, 1);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule