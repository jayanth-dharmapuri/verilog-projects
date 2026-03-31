`timescale 1ns/1ps

module mux_tb;

    reg a1, a2, a3, a4;
    reg [1:0] sel;
    wire y;

    reg expected;
    integer errors;

    mux4_1 dut (
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .a4(a4),
        .sel(sel),
        .y(y)
    );

    task run_case;
        input ta1, ta2, ta3, ta4;
        input [1:0] tsl;
        begin
            a1  = ta1;
            a2  = ta2;
            a3  = ta3;
            a4  = ta4;
            sel = tsl;
            #1;

            case (tsl)
                2'b00: expected = ta1;
                2'b01: expected = ta2;
                2'b10: expected = ta3;
                2'b11: expected = ta4;
                default: expected = 1'b0;
            endcase

            if (y !== expected) begin
                $display("FAIL: a1=%0b a2=%0b a3=%0b a4=%0b sel=%0b -> y=%0b expected=%0b",
                         a1, a2, a3, a4, sel, y, expected);
                errors = errors + 1;
            end
            else begin
                $display("PASS: a1=%0b a2=%0b a3=%0b a4=%0b sel=%0b -> y=%0b",
                         a1, a2, a3, a4, sel, y);
            end
        end
    endtask

    initial begin
        errors = 0;

        run_case(0,0,0,0,2'b00);
        run_case(0,1,0,1,2'b00);
        run_case(0,1,0,1,2'b01);
        run_case(0,1,0,1,2'b10);
        run_case(0,1,0,1,2'b11);

        run_case(1,0,0,0,2'b00);
        run_case(0,1,0,0,2'b01);
        run_case(0,0,1,0,2'b10);
        run_case(0,0,0,1,2'b11);

        run_case(1,1,0,0,2'b00);
        run_case(1,1,0,0,2'b01);
        run_case(1,0,1,0,2'b10);
        run_case(1,0,0,1,2'b11);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule