`timescale 1ns/1ps

module penc_tb;

    reg  [7:0] ip;
    wire [2:0] op;

    reg  [2:0] expected;
    integer errors;

    penc dut (
        .ip(ip),
        .op(op)
    );

    task run_case;
        input [7:0] tip;
        input [2:0] top;
        begin
            ip = tip;
            expected = top;
            #1;

            if (op !== expected) begin
                $display("FAIL: ip=%b op=%b expected=%b", ip, op, expected);
                errors = errors + 1;
            end
            else begin
                $display("PASS: ip=%b op=%b", ip, op);
            end
        end
    endtask

    initial begin
        errors = 0;

        // single 1 cases
        run_case(8'b00000001, 3'b000);
        run_case(8'b00000010, 3'b001);
        run_case(8'b00000100, 3'b010);
        run_case(8'b00001000, 3'b011);
        run_case(8'b00010000, 3'b100);
        run_case(8'b00100000, 3'b101);
        run_case(8'b01000000, 3'b110);
        run_case(8'b10000000, 3'b111);

        // multiple 1 cases: highest priority wins
        run_case(8'b00001010, 3'b011); // bits 3 and 1 set -> 3 wins
        run_case(8'b00110000, 3'b101); // bits 5 and 4 set -> 5 wins
        run_case(8'b10000001, 3'b111); // bits 7 and 0 set -> 7 wins
        run_case(8'b01100110, 3'b110); // highest set bit is 6

        // no input active
        run_case(8'b00000000, 3'b000);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule