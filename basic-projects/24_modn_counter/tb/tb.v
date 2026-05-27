`timescale 1ns/1ps

module tb;

    reg        clk, rstn;
    reg        mode, load_en;
    reg  [3:0] load;
    wire [3:0] count;

    integer errors;

    // Change module name here if your RTL module name is different
    mod13_loadable_updown_counter dut (
        .clk(clk),
        .rstn(rstn),
        .mode(mode),
        .load_en(load_en),
        .load(load),
        .count(count)
    );

    // clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Apply inputs at negedge, check output after next posedge
    task run_case;
        input       trstn;
        input       tmode;
        input       tload_en;
        input [3:0] tload;
        input [3:0] expected_count;
        begin
            @(negedge clk);
            rstn    = trstn;
            mode    = tmode;
            load_en = tload_en;
            load    = tload;

            @(posedge clk);
            #1;

            if (count !== expected_count) begin
                $display("FAIL: rstn=%b mode=%b load_en=%b load=%d -> count=%d | expected=%d",
                         rstn, mode, load_en, load, count, expected_count);
                errors = errors + 1;
            end
            else begin
                $display("PASS: rstn=%b mode=%b load_en=%b load=%d -> count=%d",
                         rstn, mode, load_en, load, count);
            end
        end
    endtask

    // Async reset check
    task check_async_reset;
        input [3:0] expected_count;
        begin
            rstn = 0;
            #1;
            if (count !== expected_count) begin
                $display("FAIL: ASYNC RESET -> count=%d | expected=%d",
                         count, expected_count);
                errors = errors + 1;
            end
            else begin
                $display("PASS: ASYNC RESET -> count=%d", count);
            end
        end
    endtask

    initial begin
        errors  = 0;
        rstn    = 1;
        mode    = 1'b1;
        load_en = 1'b0;
        load    = 4'd0;

        // -------------------------------------------------
        // RESET
        // -------------------------------------------------
        check_async_reset(4'd0);

        // release reset and count up from 0
        run_case(1'b1, 1'b1, 1'b0, 4'd0, 4'd1);
        run_case(1'b1, 1'b1, 1'b0, 4'd0, 4'd2);
        run_case(1'b1, 1'b1, 1'b0, 4'd0, 4'd3);

        // -------------------------------------------------
        // VALID LOAD
        // -------------------------------------------------
        run_case(1'b1, 1'b1, 1'b1, 4'd7, 4'd7);

        // count up after load
        run_case(1'b1, 1'b1, 1'b0, 4'd0, 4'd8);
        run_case(1'b1, 1'b1, 1'b0, 4'd0, 4'd9);

        // -------------------------------------------------
        // LOAD PRIORITY OVER MODE
        // even if mode says down, load should happen first
        // -------------------------------------------------
        run_case(1'b1, 1'b0, 1'b1, 4'd5, 4'd5);

        // now count down
        run_case(1'b1, 1'b0, 1'b0, 4'd0, 4'd4);
        run_case(1'b1, 1'b0, 1'b0, 4'd0, 4'd3);

        // -------------------------------------------------
        // DOWN WRAP: 0 -> 12
        // -------------------------------------------------
        run_case(1'b1, 1'b1, 1'b1, 4'd0, 4'd0);  // load 0
        run_case(1'b1, 1'b0, 1'b0, 4'd0, 4'd12); // wrap down
        run_case(1'b1, 1'b0, 1'b0, 4'd0, 4'd11);

        // -------------------------------------------------
        // UP WRAP: 12 -> 0
        // -------------------------------------------------
        run_case(1'b1, 1'b1, 1'b1, 4'd12, 4'd12); // load 12
        run_case(1'b1, 1'b1, 1'b0, 4'd0, 4'd0);   // wrap up
        run_case(1'b1, 1'b1, 1'b0, 4'd0, 4'd1);

        // -------------------------------------------------
        // INVALID LOAD
        // Based on corrected RTL: invalid load (>12) -> 0
        // -------------------------------------------------
        run_case(1'b1, 1'b1, 1'b1, 4'd13, 4'd0);
        run_case(1'b1, 1'b1, 1'b1, 4'd15, 4'd0);

        // -------------------------------------------------
        // RESET IN BETWEEN CLOCKS
        // -------------------------------------------------
        #2;
        check_async_reset(4'd0);

        // release reset and verify restart
        run_case(1'b1, 1'b1, 1'b0, 4'd0, 4'd1);
        run_case(1'b1, 1'b1, 1'b0, 4'd0, 4'd2);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule