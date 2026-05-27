`timescale 1ns/1ps

module tb;

    reg  [3:0] a, b;
    reg        cin;
    reg  [5:0] sel;
    wire [3:0] y;
    wire       cout;

    reg  [3:0] expected_y;
    reg        expected_cout;
    reg  [4:0] temp;

    integer errors;
    integer i, j, k, s;

    alu_4bit_extended dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sel(sel),
        .y(y),
        .cout(cout)
    );

    task run_case;
        input [3:0] ta, tb;
        input       tcin;
        input [5:0] tsel;
        begin
            a   = ta;
            b   = tb;
            cin = tcin;
            sel = tsel;
            #1;

            expected_y    = 4'b0000;
            expected_cout = 1'b0;
            temp          = 5'b00000;

            case (tsel)

                // Arithmetic
                6'd0: begin
                    temp          = {1'b0, ta} + {1'b0, tb} + tcin;
                    expected_y    = temp[3:0];
                    expected_cout = temp[4];
                end

                6'd1: begin
                    temp          = {1'b0, ta} + {1'b0, ~tb} + 5'b00001;
                    expected_y    = temp[3:0];
                    expected_cout = temp[4];
                end

                6'd2: begin
                    expected_y    = ta * tb;
                    expected_cout = 1'b0;
                end

                6'd3: begin
                    expected_y    = (tb != 0) ? (ta / tb) : 4'b0000;
                    expected_cout = 1'b0;
                end

                6'd4: begin
                    expected_y    = (tb != 0) ? (ta % tb) : 4'b0000;
                    expected_cout = 1'b0;
                end

                // Bitwise
                6'd5: begin expected_y = ta & tb; expected_cout = 1'b0; end
                6'd6: begin expected_y = ta | tb; expected_cout = 1'b0; end
                6'd7: begin expected_y = ta ^ tb; expected_cout = 1'b0; end
                6'd8: begin expected_y = ~(ta ^ tb); expected_cout = 1'b0; end
                6'd9: begin expected_y = ~(ta & tb); expected_cout = 1'b0; end
                6'd10: begin expected_y = ~(ta | tb); expected_cout = 1'b0; end
                6'd11: begin expected_y = ~ta; expected_cout = 1'b0; end

                // Shift
                6'd12: begin expected_y = ta << 1; expected_cout = 1'b0; end
                6'd13: begin expected_y = ta >> 1; expected_cout = 1'b0; end
                6'd14: begin expected_y = $signed(ta) >>> 1; expected_cout = 1'b0; end

                // Reduction
                6'd15: begin expected_y = {3'b000, &ta}; expected_cout = 1'b0; end
                6'd16: begin expected_y = {3'b000, |ta}; expected_cout = 1'b0; end
                6'd17: begin expected_y = {3'b000, ^ta}; expected_cout = 1'b0; end
                6'd18: begin expected_y = {3'b000, ~&ta}; expected_cout = 1'b0; end
                6'd19: begin expected_y = {3'b000, ~|ta}; expected_cout = 1'b0; end
                6'd20: begin expected_y = {3'b000, ~^ta}; expected_cout = 1'b0; end

                // Relational / equality
                6'd21: begin expected_y = {3'b000, (ta == tb)}; expected_cout = 1'b0; end
                6'd22: begin expected_y = {3'b000, (ta != tb)}; expected_cout = 1'b0; end
                6'd23: begin expected_y = {3'b000, (ta <  tb)}; expected_cout = 1'b0; end
                6'd24: begin expected_y = {3'b000, (ta <= tb)}; expected_cout = 1'b0; end
                6'd25: begin expected_y = {3'b000, (ta >  tb)}; expected_cout = 1'b0; end
                6'd26: begin expected_y = {3'b000, (ta >= tb)}; expected_cout = 1'b0; end

                // Logical
                6'd27: begin expected_y = {3'b000, (ta && tb)}; expected_cout = 1'b0; end
                6'd28: begin expected_y = {3'b000, (ta || tb)}; expected_cout = 1'b0; end
                6'd29: begin expected_y = {3'b000, (!ta)}; expected_cout = 1'b0; end

                // Conditional
                6'd30: begin expected_y = tcin ? ta : tb; expected_cout = 1'b0; end

                // Concatenation / replication
                6'd31: begin expected_y = {ta[1:0], tb[1:0]}; expected_cout = 1'b0; end
                6'd32: begin expected_y = {4{ta[0]}}; expected_cout = 1'b0; end

                default: begin
                    expected_y    = 4'b0000;
                    expected_cout = 1'b0;
                end
            endcase

            if ((y !== expected_y) || (cout !== expected_cout)) begin
                $display("FAIL: sel=%0d a=%b b=%b cin=%b -> y=%b cout=%b | expected y=%b cout=%b",
                         sel, a, b, cin, y, cout, expected_y, expected_cout);
                errors = errors + 1;
            end
            else begin
                $display("PASS: sel=%0d a=%b b=%b cin=%b -> y=%b cout=%b",
                         sel, a, b, cin, y, cout);
            end
        end
    endtask

    initial begin
        errors = 0;

        for (s = 0; s <= 32; s = s + 1) begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    for (k = 0; k < 2; k = k + 1) begin
                        run_case(i[3:0], j[3:0], k[0], s[5:0]);
                    end
                end
            end
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);

        $finish;
    end

endmodule