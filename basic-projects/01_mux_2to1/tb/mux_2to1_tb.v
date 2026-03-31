`timescale 1ns/1ps

module mux_2to1_tb;
    
    reg a, b, sel;
    wire y;
    reg exp;
    integer errors;

    mux_2to1 dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    task run_case;
        input ta, tb, tsel;
        begin 
            a = ta;
            b = tb;
            sel = tsel;
            #1;

            exp = tsel? tb : ta;

            if(y !== exp) begin 
                $display("FAIL: a = %0b b = %0b sel = %0b expected = %0b", a, b, sel, exp);
                errors = errors + 1;
            end else begin
                $display("PASS: a = %0b b = %0b sel = %0b y = %0b", a, b, sel, y);
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
            $display(" ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %od", errors);

        $finish;
    end

endmodule