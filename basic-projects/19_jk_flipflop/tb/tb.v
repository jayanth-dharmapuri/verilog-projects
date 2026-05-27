`timescale 1ns/1ps

module tb;

    reg j, k, clk, rstn;
    wire q;

    reg expected_q;
    integer errors;

    jk_flipflop dut (
        .j(j),
        .k(k),
        .clk(clk),
        .rstn(rstn),
        .q(q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task run_case;
        input tj;
        input tk;
        input trstn;
        input expq;
        begin
            @(negedge clk);
            j    = tj;
            k    = tk;
            rstn = trstn;

            @(posedge clk);
            #1;

            expected_q = expq;

            if (q !== expected_q) begin
                $display("FAIL: rstn=%b j=%b k=%b -> q=%b | expected q=%b",
                         rstn, j, k, q, expected_q);
                errors = errors + 1;
            end
            else begin
                $display("PASS: rstn=%b j=%b k=%b -> q=%b",
                         rstn, j, k, q);
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
        j          = 0;
        k          = 0;
        rstn       = 0;
        expected_q = 0;

        check_async_reset();

        @(negedge clk);
        j    = 0;
        k    = 0;
        rstn = 1;

        run_case(0, 0, 1, 0);
        run_case(1, 0, 1, 1);
        run_case(0, 0, 1, 1);
        run_case(0, 1, 1, 0);
        run_case(1, 1, 1, 1);
        run_case(1, 1, 1, 0);

        #2;
        check_async_reset();

        @(negedge clk);
        j    = 0;
        k    = 0;
        rstn = 1;

        run_case(1, 0, 1, 1);
        run_case(0, 1, 1, 0);
        run_case(1, 1, 1, 1);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule
