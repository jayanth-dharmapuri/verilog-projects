`timescale 1ns/1ps

module gates_tb;

    reg a, b;
    wire inv, aand, aor, anand, anor, axor, axnor;

    gates gt (
        .a(a),
        .b(b),
        .inv(inv),
        .aand(aand),
        .aor(aor),
        .anand(anand),
        .anor(anor),
        .axor(axor),
        .axnor(axnor)
    );

    task run_case;
        input ta, tb;
        begin
            a = ta;
            b = tb;
            #1;

            $display("a=%0b b=%0b | inv=%0b and=%0b or=%0b nand=%0b nor=%0b xor=%0b xnor=%0b",
                     a, b, inv, aand, aor, anand, anor, axor, axnor);
        end
    endtask

    initial begin
        run_case(0,0);
        run_case(0,1);
        run_case(1,0);
        run_case(1,1);
        $finish;
    end

endmodule