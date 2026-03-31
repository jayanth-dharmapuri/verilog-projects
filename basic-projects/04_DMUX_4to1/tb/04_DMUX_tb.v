`timescale 1ns/1ps

module dmux_tb;

    reg ip;
    reg s1, s2;
    wire y1, y2, y3, y4;

    reg ey1, ey2, ey3, ey4;
    integer errors;

    dmux dut (
        .ip(ip),
        .s1(s1),
        .s2(s2),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .y4(y4)
    );

    task run_case;
        input tip;
        input ts1, ts2;
        begin
            ip = tip;
            s1 = ts1;
            s2 = ts2;
            #1;

            ey1 = (~ts1) & (~ts2) & tip;
            ey2 = (~ts1) & ( ts2) & tip;
            ey3 = ( ts1) & (~ts2) & tip;
            ey4 = ( ts1) & ( ts2) & tip;

            if ((y1 !== ey1) || (y2 !== ey2) || (y3 !== ey3) || (y4 !== ey4)) begin
                $display("FAIL: ip=%0b s1=%0b s2=%0b -> y1=%0b y2=%0b y3=%0b y4=%0b | expected=%0b %0b %0b %0b",
                         ip, s1, s2, y1, y2, y3, y4, ey1, ey2, ey3, ey4);
                errors = errors + 1;
            end
            else begin
                $display("PASS: ip=%0b s1=%0b s2=%0b -> y1=%0b y2=%0b y3=%0b y4=%0b",
                         ip, s1, s2, y1, y2, y3, y4);
            end
        end
    endtask

    initial begin
        errors = 0;

        run_case(0,0,0);
        run_case(0,0,1);
        run_case(0,1,0);
        run_case(0,1,1);

        run_case(1,0,0);
        run_case(1,0,1);
        run_case(1,1,0);
        run_case(1,1,1);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule