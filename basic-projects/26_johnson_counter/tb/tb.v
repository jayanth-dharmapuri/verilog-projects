`timescale 1ns/1ps

module tb;

    reg clk, rstn;
    wire [3:0] q;

    integer errors;
    reg [3:0] expected_q;

    johnson_counter dut (
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
                $display("FAIL: rstn=%b q=%b expected=%b", rstn, q, expected_q);
                errors = errors + 1;
            end
            else begin
                $display("PASS: rstn=%b q=%b", rstn, q);
            end
        end
    endtask

    initial begin
        errors = 0;
        rstn   = 1'b1;

        // apply reset at start
        rstn = 1'b0;
        check_q(4'b0000);

        // release reset
        @(negedge clk);
        rstn = 1'b1;

        // check Johnson sequence
        @(posedge clk); check_q(4'b1000);
        @(posedge clk); check_q(4'b1100);
        @(posedge clk); check_q(4'b1110);
        @(posedge clk); check_q(4'b1111);
        @(posedge clk); check_q(4'b0111);
        @(posedge clk); check_q(4'b0011);
        @(posedge clk); check_q(4'b0001);
        @(posedge clk); check_q(4'b0000);
        @(posedge clk); check_q(4'b1000);

        // assert reset in between clocks
        #2;
        rstn = 1'b0;
        check_q(4'b0000);

        // release reset again
        @(negedge clk);
        rstn = 1'b1;

        @(posedge clk); check_q(4'b1000);
        @(posedge clk); check_q(4'b1100);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule