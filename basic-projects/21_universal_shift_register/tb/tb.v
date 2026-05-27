`timescale 1ns/1ps

module tb;

    reg clk, rst_n;
    reg sin;
    reg load;
    reg [3:0] pin;

    wire siso_sout;
    wire [3:0] sipo_pout;
    wire piso_sout;
    wire [3:0] pipo_pout;

    reg [3:0] exp_serial;
    reg [3:0] exp_piso;
    reg [3:0] exp_pipo;

    integer errors;

    siso_shift_register u_siso (
        .clk(clk),
        .rst_n(rst_n),
        .sin(sin),
        .sout(siso_sout)
    );

    sipo_shift_register u_sipo (
        .clk(clk),
        .rst_n(rst_n),
        .sin(sin),
        .pout(sipo_pout)
    );

    piso_shift_register u_piso (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .pin(pin),
        .sout(piso_sout)
    );

    pipo_register u_pipo (
        .clk(clk),
        .rst_n(rst_n),
        .pin(pin),
        .pout(pipo_pout)
    );

    // clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task check_reset_outputs;
        begin
            #1;
            if (siso_sout !== 1'b0) begin
                $display("FAIL SISO RESET: sout=%b expected=0", siso_sout);
                errors = errors + 1;
            end
            else begin
                $display("PASS SISO RESET: sout=%b", siso_sout);
            end

            if (sipo_pout !== 4'b0000) begin
                $display("FAIL SIPO RESET: pout=%b expected=0000", sipo_pout);
                errors = errors + 1;
            end
            else begin
                $display("PASS SIPO RESET: pout=%b", sipo_pout);
            end

            if (piso_sout !== 1'b0) begin
                $display("FAIL PISO RESET: sout=%b expected=0", piso_sout);
                errors = errors + 1;
            end
            else begin
                $display("PASS PISO RESET: sout=%b", piso_sout);
            end

            if (pipo_pout !== 4'b0000) begin
                $display("FAIL PIPO RESET: pout=%b expected=0000", pipo_pout);
                errors = errors + 1;
            end
            else begin
                $display("PASS PIPO RESET: pout=%b", pipo_pout);
            end
        end
    endtask

    task apply_reset;
        begin
            rst_n      = 0;
            sin        = 0;
            load       = 0;
            pin        = 4'b0000;
            exp_serial = 4'b0000;
            exp_piso   = 4'b0000;
            exp_pipo   = 4'b0000;

            check_reset_outputs();
        end
    endtask

    // One serial shift for SISO + SIPO
    task shift_serial;
        input bit_in;
        begin
            @(negedge clk);
            sin = bit_in;

            @(posedge clk);
            exp_serial = {exp_serial[2:0], bit_in};
            #1;

            if (sipo_pout !== exp_serial) begin
                $display("FAIL SIPO: sin=%b pout=%b expected=%b",
                         bit_in, sipo_pout, exp_serial);
                errors = errors + 1;
            end
            else begin
                $display("PASS SIPO: sin=%b pout=%b",
                         bit_in, sipo_pout);
            end

            if (siso_sout !== exp_serial[3]) begin
                $display("FAIL SISO: sin=%b sout=%b expected=%b",
                         bit_in, siso_sout, exp_serial[3]);
                errors = errors + 1;
            end
            else begin
                $display("PASS SISO: sin=%b sout=%b",
                         bit_in, siso_sout);
            end
        end
    endtask

    // Load parallel data into PISO
    task load_piso;
        input [3:0] data;
        begin
            @(negedge clk);
            load = 1'b1;
            pin  = data;

            @(posedge clk);
            exp_piso = data;
            #1;

            if (piso_sout !== exp_piso[3]) begin
                $display("FAIL PISO LOAD: pin=%b sout=%b expected=%b",
                         data, piso_sout, exp_piso[3]);
                errors = errors + 1;
            end
            else begin
                $display("PASS PISO LOAD: pin=%b sout=%b",
                         data, piso_sout);
            end
        end
    endtask

    // Shift one bit out of PISO
    task shift_piso;
        begin
            @(negedge clk);
            load = 1'b0;

            @(posedge clk);
            exp_piso = {exp_piso[2:0], 1'b0};
            #1;

            if (piso_sout !== exp_piso[3]) begin
                $display("FAIL PISO SHIFT: sout=%b expected=%b",
                         piso_sout, exp_piso[3]);
                errors = errors + 1;
            end
            else begin
                $display("PASS PISO SHIFT: sout=%b",
                         piso_sout);
            end
        end
    endtask

    // Load/check PIPO
    task load_pipo;
        input [3:0] data;
        begin
            @(negedge clk);
            pin = data;

            @(posedge clk);
            exp_pipo = data;
            #1;

            if (pipo_pout !== exp_pipo) begin
                $display("FAIL PIPO: pin=%b pout=%b expected=%b",
                         data, pipo_pout, exp_pipo);
                errors = errors + 1;
            end
            else begin
                $display("PASS PIPO: pin=%b pout=%b",
                         data, pipo_pout);
            end
        end
    endtask

    initial begin
        errors = 0;
        rst_n  = 1;
        sin    = 0;
        load   = 0;
        pin    = 4'b0000;
        exp_serial = 4'b0000;
        exp_piso   = 4'b0000;
        exp_pipo   = 4'b0000;

        // ---------------- RESET ----------------
        $display("---- RESET CHECK ----");
        apply_reset();

        @(negedge clk);
        rst_n = 1;

        // ---------------- SISO + SIPO ----------------
        $display("---- TESTING SISO + SIPO ----");
        shift_serial(1'b1);
        shift_serial(1'b0);
        shift_serial(1'b1);
        shift_serial(1'b1);
        shift_serial(1'b0);

        // ---------------- RESET AGAIN ----------------
        $display("---- RESET CHECK ----");
        apply_reset();

        @(negedge clk);
        rst_n = 1;

        // ---------------- PISO ----------------
        $display("---- TESTING PISO ----");
        load_piso(4'b1011);  // expect serial out MSB first
        shift_piso();        // next
        shift_piso();        // next
        shift_piso();        // next
        shift_piso();        // zero after all bits shifted out

        // ---------------- RESET AGAIN ----------------
        $display("---- RESET CHECK ----");
        apply_reset();

        @(negedge clk);
        rst_n = 1;

        // ---------------- PIPO ----------------
        $display("---- TESTING PIPO ----");
        load_pipo(4'b1100);
        load_pipo(4'b0011);
        load_pipo(4'b1010);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule