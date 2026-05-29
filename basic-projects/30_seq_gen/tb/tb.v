`timescale 1ns/1ps

module tb;

    reg clk, rst;
    wire seq_out;

    integer errors;

    seq_generator_1011010110 dut (
        .clk(clk),
        .rst(rst),
        .seq_out(seq_out)
    );

    // clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task check_bit;
        input expected;
        begin
            #1;
            if (seq_out !== expected) begin
                $display("FAIL: rst=%b seq_out=%b expected=%b", rst, seq_out, expected);
                errors = errors + 1;
            end
            else begin
                $display("PASS: rst=%b seq_out=%b", rst, seq_out);
            end
        end
    endtask

    task step_and_check;
        input expected;
        begin
            @(posedge clk);
            check_bit(expected);
        end
    endtask

    initial begin
        errors = 0;
        rst    = 1'b0;

        // proper reset pulse
        #2;
        rst = 1'b1;
        check_bit(1'b1);   // count=0 -> first bit = 1

        @(negedge clk);
        rst = 1'b0;
        check_bit(1'b1);   // still first bit until next clock

        // sequence = 1011010110
        step_and_check(1'b0); // bit2
        step_and_check(1'b1); // bit3
        step_and_check(1'b1); // bit4
        step_and_check(1'b0); // bit5
        step_and_check(1'b1); // bit6
        step_and_check(1'b0); // bit7
        step_and_check(1'b1); // bit8
        step_and_check(1'b1); // bit9
        step_and_check(1'b0); // bit10
        step_and_check(1'b1); // repeat bit1

        // reset again in middle
        #2;
        rst = 1'b1;
        check_bit(1'b1);

        @(negedge clk);
        rst = 1'b0;
        check_bit(1'b1);

        // few more bits after reset
        step_and_check(1'b0);
        step_and_check(1'b1);
        step_and_check(1'b1);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule