`timescale 1ns/1ps

module tb;

    reg t, clk, rstn;
    wire q;

    reg expected_q;
    integer errors;

    tff dut (
        .t(t),
        .clk(clk),
        .rstn(rstn),
        .q(q)
    );

    // clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task run_case;
        input tt;
        input trstn;
        input expq;
        begin
            @(negedge clk);
            t    = tt;
            rstn = trstn;

            @(posedge clk);
            #1;

            expected_q = expq;

            if (q !== expected_q) begin
                $display("FAIL: rstn=%b t=%b -> q=%b | expected q=%b",
                         rstn, t, q, expected_q);
                errors = errors + 1;
            end
            else begin
                $display("PASS: rstn=%b t=%b -> q=%b",
                         rstn, t, q);
            end
        end
    endtask

    task check_async_reset;
        begin
            rstn = 0;
            #1;

            if (q !== 1'b0) begin
                $display("FAIL: async reset -> q=%b | expected q=0", q);
                errors = errors + 1;
            end
            else begin
                $display("PASS: async reset -> q=%b", q);
            end
        end
    endtask

    initial begin
        errors     = 0;
        t          = 0;
        rstn       = 0;
        expected_q = 0;

        // check async reset at start
        check_async_reset();

        // release reset
        @(negedge clk);
        rstn = 1;

        // t=0 -> hold at 0
        run_case(0, 1, 0);

        // t=1 -> toggle 0 to 1
        run_case(1, 1, 1);

        // t=0 -> hold at 1
        run_case(0, 1, 1);

        // t=1 -> toggle 1 to 0
        run_case(1, 1, 0);

        // t=1 -> toggle 0 to 1
        run_case(1, 1, 1);

        // assert async reset between clocks
        #2;
        check_async_reset();

        // release reset again
        @(negedge clk);
        t    = 0;
        rstn = 1;

        // after reset, q=0, t=0 -> hold
        run_case(0, 1, 0);

        // t=1 -> toggle 0 to 1
        run_case(1, 1, 1);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule
