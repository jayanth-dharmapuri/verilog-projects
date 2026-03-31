`timescale 1ns/1ps

module dec_tb;

    reg  [2:0] ip;
    wire [7:0] y;

    reg  [7:0] expected;
    integer errors;

    dec dut (
        .ip(ip),
        .y(y)
    );

    task run_case;
        input [2:0] tip;
        begin
            ip = tip;
            #1;

            case (tip)
                3'b000: expected = 8'b00000001;
                3'b001: expected = 8'b00000010;
                3'b010: expected = 8'b00000100;
                3'b011: expected = 8'b00001000;
                3'b100: expected = 8'b00010000;
                3'b101: expected = 8'b00100000;
                3'b110: expected = 8'b01000000;
                3'b111: expected = 8'b10000000;
                default: expected = 8'b00000000;
            endcase

            if (y !== expected) begin
                $display("FAIL: ip=%0b y=%0b expected=%0b", ip, y, expected);
                errors = errors + 1;
            end
            else begin
                $display("PASS: ip=%0b y=%0b", ip, y);
            end
        end
    endtask

    initial begin
        errors = 0;

        run_case(3'b000);
        run_case(3'b001);
        run_case(3'b010);
        run_case(3'b011);
        run_case(3'b100);
        run_case(3'b101);
        run_case(3'b110);
        run_case(3'b111);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule