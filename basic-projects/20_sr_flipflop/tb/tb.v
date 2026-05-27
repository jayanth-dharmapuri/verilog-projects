`timescale 1ns/1ps

module tb;

    reg s, r, clk, rstn;
    wire q;

    reg expected_q;
    integer errors;

    sr_flipflop dut (
        .s(s),
        .r(r),
        .clk(clk),
        .rstn(rstn),
        .q(q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task run_case;
        input ts;
        input tr;
        input trstn;
        input expq;
        begin
            @(negedge clk);
            s    = ts;
            r    = tr;
            rstn = trstn;

            @(posedge clk);
            #1;

            expected_q = expq;

            if (q !== expected_q) begin
                $display("FAIL: rstn=%b s=%b r=%b -> q=%b | expected q=%b",
                         rstn, s, r, q, expected_q);
                errors = errors + 1;
            end
            else begin
                $display("PASS: rstn=%b s=%b r=%b -> q=%b",
                         rstn, s, r, q);
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
        s          = 0;
        r          = 0;
        rstn       = 0;
        expected_q = 0;

        check_async_reset();

        @(negedge clk);
        s    = 0;
        r    = 0;
        rstn = 1;

        run_case(0, 0, 1, 0);
        run_case(1, 0, 1, 1);
        run_case(0, 0, 1, 1);
        run_case(0, 1, 1, 0);
        run_case(1, 0, 1, 1);
        run_case(1, 1, 1, 1'bx);

        check_async_reset();

        @(negedge clk);
        s    = 0;
        r    = 0;
        rstn = 1;

        run_case(1, 0, 1, 1);
        run_case(0, 1, 1, 0);
        run_case(0, 0, 1, 0);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule
