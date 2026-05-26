`timescale 1ns/1ps

module ha_fa_tb;

    // Half adder signals
    reg ha_a, ha_b;
    wire ha_sum, ha_carry;

    // Full adder signals
    reg fa_a, fa_b, fa_cin;
    wire fa_sum, fa_carry;

    // Expected values
    reg exp_ha_sum, exp_ha_carry;
    reg exp_fa_sum, exp_fa_carry;

    integer errors;

    // DUT: half adder
    half_adder ha (
        .a(ha_a),
        .b(ha_b),
        .sum(ha_sum),
        .carry(ha_carry)
    );

    // DUT: full adder using half adders
    full_adder_using_ha fa (
        .a(fa_a),
        .b(fa_b),
        .cin(fa_cin),
        .sum(fa_sum),
        .carry(fa_carry)
    );

    task test_half_adder;
        input ta, tb;
        begin
            ha_a = ta;
            ha_b = tb;
            #1;

            exp_ha_sum   = ta ^ tb;
            exp_ha_carry = ta & tb;

            if ((ha_sum !== exp_ha_sum) || (ha_carry !== exp_ha_carry)) begin
                $display("HA FAIL: a=%0b b=%0b -> sum=%0b carry=%0b | expected sum=%0b carry=%0b",
                         ha_a, ha_b, ha_sum, ha_carry, exp_ha_sum, exp_ha_carry);
                errors = errors + 1;
            end
            else begin
                $display("HA PASS: a=%0b b=%0b -> sum=%0b carry=%0b",
                         ha_a, ha_b, ha_sum, ha_carry);
            end
        end
    endtask

    task test_full_adder;
        input ta, tb, tcin;
        begin
            fa_a   = ta;
            fa_b   = tb;
            fa_cin = tcin;
            #1;

            exp_fa_sum   = ta ^ tb ^ tcin;
            exp_fa_carry = (ta & tb) | (tb & tcin) | (ta & tcin);

            if ((fa_sum !== exp_fa_sum) || (fa_carry !== exp_fa_carry)) begin
                $display("FA FAIL: a=%0b b=%0b cin=%0b -> sum=%0b carry=%0b | expected sum=%0b carry=%0b",
                         fa_a, fa_b, fa_cin, fa_sum, fa_carry, exp_fa_sum, exp_fa_carry);
                errors = errors + 1;
            end
            else begin
                $display("FA PASS: a=%0b b=%0b cin=%0b -> sum=%0b carry=%0b",
                         fa_a, fa_b, fa_cin, fa_sum, fa_carry);
            end
        end
    endtask

    initial begin
        errors = 0;

        $display("----- HALF ADDER TESTS -----");
        test_half_adder(0,0);
        test_half_adder(0,1);
        test_half_adder(1,0);
        test_half_adder(1,1);

        $display("----- FULL ADDER USING HALF ADDERS TESTS -----");
        test_full_adder(0,0,0);
        test_full_adder(0,0,1);
        test_full_adder(0,1,0);
        test_full_adder(0,1,1);
        test_full_adder(1,0,0);
        test_full_adder(1,0,1);
        test_full_adder(1,1,0);
        test_full_adder(1,1,1);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule