`timescale 1ns/1ps

module tb;

    reg clk, rst;
    wire clk_div4;

    integer errors;

    clk_div_by_4 dut (
        .clk(clk),
        .rst(rst),
        .clk_div4(clk_div4)
    );

    // clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task check_vals;
        input [1:0] exp_count;
        input       exp_div4;
        begin
            #1;
            if ((dut.count !== exp_count) || (clk_div4 !== exp_div4)) begin
                $display("FAIL: rst=%b count=%b clk_div4=%b | expected count=%b clk_div4=%b",
                         rst, dut.count, clk_div4, exp_count, exp_div4);
                errors = errors + 1;
            end
            else begin
                $display("PASS: rst=%b count=%b clk_div4=%b",
                         rst, dut.count, clk_div4);
            end
        end
    endtask

    task step_and_check;
        input [1:0] exp_count;
        input       exp_div4;
        begin
            @(posedge clk);
            check_vals(exp_count, exp_div4);
        end
    endtask

    initial begin
        errors = 0;

        // keep reset active from start
        rst = 1'b1;

        // while reset is active, count should be 00
        #1;
        check_vals(2'b00, 1'b0);

        // release reset safely at negedge
        @(negedge clk);
        rst = 1'b0;

        // now check count progression
        step_and_check(2'b01, 1'b0);
        step_and_check(2'b10, 1'b1);
        step_and_check(2'b11, 1'b1);
        step_and_check(2'b00, 1'b0);
        step_and_check(2'b01, 1'b0);
        step_and_check(2'b10, 1'b1);
        step_and_check(2'b11, 1'b1);
        step_and_check(2'b00, 1'b0);

        // apply reset again in the middle
        @(negedge clk);
        rst = 1'b1;
        #1;
        check_vals(2'b00, 1'b0);

        // release reset again
        @(negedge clk);
        rst = 1'b0;

        step_and_check(2'b01, 1'b0);
        step_and_check(2'b10, 1'b1);
        step_and_check(2'b11, 1'b1);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule