`timescale 1ns/1ps

module rc_adder_tb;

    reg  [3:0] a, b;
    wire [3:0] sum, carry;

    reg  [4:0] expected_total;
    reg  [3:0] expected_sum;
    reg  [3:0] expected_carry;

    integer errors;

    rc_adder dut (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );

    task run_case;
        input [3:0] ta, tb;
        reg c0, c1, c2, c3;
        begin
            a = ta;
            b = tb;
            #1;

            expected_total = ta + tb;
            expected_sum   = expected_total[3:0];

            c0 = ((ta[0] & tb[0]) | ((ta[0] ^ tb[0]) & 1'b0));
            c1 = ((ta[1] & tb[1]) | ((ta[1] ^ tb[1]) & c0));
            c2 = ((ta[2] & tb[2]) | ((ta[2] ^ tb[2]) & c1));
            c3 = ((ta[3] & tb[3]) | ((ta[3] ^ tb[3]) & c2));

            expected_carry = {c3, c2, c1, c0};

            if ((sum !== expected_sum) || (carry !== expected_carry)) begin
                $display("FAIL: a=%b b=%b -> sum=%b carry=%b | expected sum=%b carry=%b",
                         a, b, sum, carry, expected_sum, expected_carry);
                errors = errors + 1;
            end
            else begin
                $display("PASS: a=%b b=%b -> sum=%b carry=%b",
                         a, b, sum, carry);
            end
        end
    endtask

    initial begin
        errors = 0;
        /*
        run_case(4'b0000, 4'b0000);
        run_case(4'b0001, 4'b0001);
        run_case(4'b0011, 4'b0101);
        run_case(4'b0111, 4'b0001);
        run_case(4'b1111, 4'b0001);
        run_case(4'b1111, 4'b1111);
        run_case(4'b1010, 4'b0101);
        run_case(4'b1001, 4'b0110);
        */

        for ( integer i = 0 ; i < 16  ; i = i+1 ) begin
            for (integer j = 0; j < 16; j = j+1 ) begin 
                run_case(i,j);
            end
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule