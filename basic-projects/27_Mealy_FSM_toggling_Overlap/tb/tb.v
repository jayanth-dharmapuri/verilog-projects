`timescale 1ns/1ps

module tb;

    reg clk, rstn, en, x;
    wire z;

    integer errors;

    seq_det_toggle_1011010110 dut (
        .clk(clk),
        .rstn(rstn),
        .en(en),
        .x(x),
        .z(z)
    );

    // clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task check_reset;
        begin
            #1;
            if (z !== 1'b0) begin
                $display("FAIL RESET: z=%b expected=0", z);
                errors = errors + 1;
            end
            else begin
                $display("PASS RESET: z=%b", z);
            end
        end
    endtask

    task send_bit;
        input bit_in;
        input exp_z;
        begin
            @(negedge clk);
            x = bit_in;

            @(posedge clk);
            #1;

            if (z !== exp_z) begin
                $display("FAIL: en=%b x=%b z=%b expected=%b", en, x, z, exp_z);
                errors = errors + 1;
            end
            else begin
                $display("PASS: en=%b x=%b z=%b", en, x, z);
            end
        end
    endtask

    task hold_check;
        input bit_in;
        input exp_z;
        begin
            @(negedge clk);
            x = bit_in;

            @(posedge clk);
            #1;

            if (z !== exp_z) begin
                $display("FAIL HOLD: en=%b x=%b z=%b expected=%b", en, x, z, exp_z);
                errors = errors + 1;
            end
            else begin
                $display("PASS HOLD: en=%b x=%b z=%b", en, x, z);
            end
        end
    endtask

    task report_summary;
        begin
            if (errors == 0)
                $display("ALL TESTS PASSED");
            else
                $display("TOTAL FAILURES = %0d", errors);
        end
    endtask

    initial begin
        errors = 0;
        rstn   = 0;
        en     = 0;
        x      = 0;

        // reset at start
        check_reset();

        // release reset and enable
        @(negedge clk);
        rstn = 1;
        en   = 1;

        // stream = 101101011010110
        // detections at bit10 and bit15
        // z : 0 -> 1 at bit10, 1 -> 0 at bit15

        send_bit(1, 0);  // 1
        send_bit(0, 0);  // 2
        send_bit(1, 0);  // 3
        send_bit(1, 0);  // 4
        send_bit(0, 0);  // 5
        send_bit(1, 0);  // 6
        send_bit(0, 0);  // 7
        send_bit(1, 0);  // 8
        send_bit(1, 0);  // 9
        send_bit(0, 1);  // 10 -> first detect

        send_bit(1, 1);  // 11
        send_bit(0, 1);  // 12
        send_bit(1, 1);  // 13
        send_bit(1, 1);  // 14
        send_bit(0, 0);  // 15 -> overlapping second detect

        // disable and check hold
        @(negedge clk);
        en = 0;

        hold_check(1, 0);
        hold_check(0, 0);
        hold_check(1, 0);

        // enable again
        @(negedge clk);
        en = 1;

        // one full pattern again -> z toggles 0 -> 1
        send_bit(1, 0);
        send_bit(0, 0);
        send_bit(1, 0);
        send_bit(1, 0);
        send_bit(0, 0);
        send_bit(1, 0);
        send_bit(0, 0);
        send_bit(1, 0);
        send_bit(1, 0);
        send_bit(0, 1);

        // reset again
        #2;
        rstn = 0;
        en   = 0;
        check_reset();

        report_summary();
        $finish;
    end

endmodule