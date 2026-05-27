`timescale 1ns/1ps

module tb;

    reg clk, rst_n, d;
    wire q;

    integer errors;

    d_flipflop_async_negrst dut (
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

    // drive d at negedge, check q after next posedge
    task run_case;
        input td;
        begin
            @(negedge clk);
            d = td;

            @(posedge clk);
            #1;

            if (q !== td) begin
                $display("FAIL: rst_n=%b d=%b -> q=%b | expected q=%b",
                         rst_n, d, q, td);
                errors = errors + 1;
            end
            else begin
                $display("PASS: rst_n=%b d=%b -> q=%b",
                         rst_n, d, q);
            end
        end
    endtask

    // async reset check
    task check_reset;
        begin
            rst_n = 0;
            #1;

            if (q !== 1'b0) begin
                $display("FAIL: reset asserted -> q=%b | expected q=0", q);
                errors = errors + 1;
            end
            else begin
                $display("PASS: reset asserted -> q=%b", q);
            end
        end
    endtask

    initial begin
        errors = 0;
        d      = 0;
        rst_n  = 0;

        // reset active at start
        check_reset();

        // release reset
        @(negedge clk);
        rst_n = 1;

        // normal capture checks
        run_case(0);
        run_case(1);
        run_case(0);
        run_case(1);

        // assert reset between clocks
        #2;
        check_reset();

        // release reset again
        @(negedge clk);
        rst_n = 1;

        // capture again
        run_case(1);
        run_case(0);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule