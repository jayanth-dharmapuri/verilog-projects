`timescale 1ns/1ps

module tb;

    reg clk, rstn;
    wire [3:0] count;

    reg [3:0] expected_count;
    integer errors;
    integer i;

    upc dut (
        .clk(clk),
        .rstn(rstn),
        .count(count)
    );

    // clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // check current count
    task check_count;
        input [3:0] exp;
        begin
            #1;
            expected_count = exp;
            if (count !== expected_count) begin
                $display("FAIL: rstn=%b count=%b expected=%b",
                         rstn, count, expected_count);
                errors = errors + 1;
            end
            else begin
                $display("PASS: rstn=%b count=%b",
                         rstn, count);
            end
        end
    endtask

    initial begin
        errors = 0;
        rstn   = 0;

        // async reset check
        check_count(4'b0000);

        // release reset at negedge so next posedge counts cleanly
        @(negedge clk);
        rstn = 1;

        // check 16 increments: 0->1->2 ... ->15->0
        for (i = 1; i <= 16; i = i + 1) begin
            @(posedge clk);
            check_count(i[3:0]);
        end

        // assert async reset between clocks
        #2;
        rstn = 0;
        check_count(4'b0000);

        // release reset and verify count restarts from 1
        @(negedge clk);
        rstn = 1;

        @(posedge clk);
        check_count(4'b0001);

        @(posedge clk);
        check_count(4'b0010);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule