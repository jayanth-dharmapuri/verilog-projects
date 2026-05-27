`timescale 1ns/1ps

module tb;

    reg clk, rstn, up_down;
    wire [3:0] count;

    integer errors;

    updown_counter dut (
        .clk(clk),
        .rstn(rstn),
        .up_down(up_down),
        .count(count)
    );

    // clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task apply_inputs;
        input trstn;
        input tup_down;
        begin
            @(negedge clk);
            rstn    = trstn;
            up_down = tup_down;
        end
    endtask

    task check_output;
        input [3:0] expected;
        begin
            @(posedge clk);
            #1;
            if (count !== expected) begin
                $display("FAIL: rstn=%b up_down=%b count=%b expected=%b",
                         rstn, up_down, count, expected);
                errors = errors + 1;
            end
            else begin
                $display("PASS: rstn=%b up_down=%b count=%b",
                         rstn, up_down, count);
            end
        end
    endtask

    initial begin
        errors  = 0;
        rstn    = 0;
        up_down = 1'b1;

        // check reset immediately
        #1;
        if (count !== 4'b0000) begin
            $display("FAIL: async reset count=%b expected=0000", count);
            errors = errors + 1;
        end
        else begin
            $display("PASS: async reset count=%b", count);
        end

        // count up
        apply_inputs(1, 1); check_output(4'b0001);
        apply_inputs(1, 1); check_output(4'b0010);
        apply_inputs(1, 1); check_output(4'b0011);
        apply_inputs(1, 1); check_output(4'b0100);

        // count down
        apply_inputs(1, 0); check_output(4'b0011);
        apply_inputs(1, 0); check_output(4'b0010);
        apply_inputs(1, 0); check_output(4'b0001);
        apply_inputs(1, 0); check_output(4'b0000);
        apply_inputs(1, 0); check_output(4'b1111);

        // count up again
        apply_inputs(1, 1); check_output(4'b0000);
        apply_inputs(1, 1); check_output(4'b0001);

        // async reset in between clocks
        #2;
        rstn = 0;
        #1;
        if (count !== 4'b0000) begin
            $display("FAIL: async reset count=%b expected=0000", count);
            errors = errors + 1;
        end
        else begin
            $display("PASS: async reset count=%b", count);
        end

        // restart after reset
        apply_inputs(1, 1); check_output(4'b0001);
        apply_inputs(1, 0); check_output(4'b0000);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule