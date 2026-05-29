`timescale 1ns/1ps

module tb;

    reg clk, rst_n, d;
    wire x;

fsm_110100_moore dut (
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

            @(posedge clk);
            #1;
            $display("rst_n=%b d=%b x=%b state=%0d next_state=%0d",
                     rst_n, d, x, dut.st, dut.nst);
        end
    endtask

    initial begin
        rst_n = 0;
        d     = 0;

        $display("Applying reset...");
        #2;

        @(negedge clk);
        rst_n = 1;

        $display("Sending 110100");
        drive(1);
        drive(1);
        drive(0);
        drive(1);
        drive(0);
        drive(0);   // x becomes 1 here

        $display("One extra bit after detect");
        drive(1);   // x goes back to 0

        $display("Sending 110100 again");
        drive(1);
        drive(1);
        drive(0);
        drive(1);
        drive(0);
        drive(0);   // x becomes 1 again

        $finish;
    end

endmodule