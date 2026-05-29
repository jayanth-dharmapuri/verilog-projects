`timescale 1ns/1ps

module tb;

    reg clk, rst_n, d;
    wire x;

    fsm dut (
        .clk(clk),
        .rst_n(rst_n),
        .d(d),
        .x(x)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task drive;
        input din;
        begin
            @(negedge clk);
            d = din;

            #1;
            $display("BEFORE posedge : rst_n=%b d=%b x=%b st=%0d nst=%0d", rst_n, d, x, dut.st, dut.nst);

            @(posedge clk);
            #1;
            $display("AFTER  posedge : rst_n=%b d=%b x=%b st=%0d nst=%0d", rst_n, d, x, dut.st, dut.nst);
        end
    endtask

    initial begin
        rst_n = 0;
        d     = 0;

        #2;
        @(negedge clk);
        rst_n = 1;

        $display("Sending 110100");
        drive(1);
        drive(1);
        drive(0);
        drive(1);
        drive(0);
        drive(0);

        $display("Sending 110100 again");
        drive(1);
        drive(1);
        drive(0);
        drive(1);
        drive(0);
        drive(0);

        $finish;
    end

endmodule