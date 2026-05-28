`timescale 1ns/1ps

module tb;

    reg clk, rstn;
    wire [3:0] q;

    reg [3:0] expected_q;
    integer errors;

    ring_counter dut (
        .clk(clk),
        .rstn(rstn),
        .q(q)
    );

    // clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task check_q;
        input [3:0] exp;
        begin
            #1;
            expected_q = exp;
            if (q !== expected_q) begin
                $display("FAIL: q=%b expected=%b", q, expected_q);
                errors = errors + 1;
            end
            else begin
                $display("PASS: q=%b", q);
            end
        end
    endtask

    initial begin
        errors = 0;
        rstn   = 0;

        // async reset check
        check_q(4'b0001);

        // release reset
        @(negedge clk);
        rstn = 1;

        @(posedge clk); check_q(4'b0010);
        @(posedge clk); check_q(4'b0100);
        @(posedge clk); check_q(4'b1000);
        @(posedge clk); check_q(4'b0001);
        @(posedge clk); check_q(4'b0010);

        // assert reset in between clocks
        #2;
        rstn = 0;
        check_q(4'b0001);

        // release reset again
        @(negedge clk);
        rstn = 1;

        @(posedge clk); check_q(4'b0010);
        @(posedge clk); check_q(4'b0100);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule