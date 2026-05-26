module comp4tb;

    reg [3:0] a,b;
    wire lt, eq, gt;
    integer errors;

    reg e1, e2, e3;

    comp4 c4 (.a(a), .b(b), .lt(lt), .eq(eq), .gt(gt));

    integer i,j;

    task run_case;
        input [3:0] a1,b1;

        begin
        e1 = 0;
        e2 = 0;
        e3 = 0;

        a = a1; 
        b = b1;
        #5;

        if(a<b)
            e1 = 1;
        else if (a==b)
            e2 = 1;
        else 
            e3 = 1;

        if ((e1 !== lt) || (e2 !== eq ) || (e3 !== gt)) begin
            $display("FAIL: a=%b b=%b -> lt=%b eq=%b gt=%b | expected lt=%b eq=%b gt=%b",
         a, b, lt, eq, gt, e1, e2, e3);
            errors = errors + 1 ;
        end
        else begin
            $display("PASS: a=%b b=%b -> lt=%b eq=%b gt=%b",
         a, b, lt, eq, gt);
        end
        end
    endtask

    initial begin 
        errors = 0;
        for(i = 0; i<16; i = i+1) begin 
            for(j = 0; j<16; j = j+1) begin 
                run_case(i[3:0], j[3:0]);
            end
        end
        if (errors == 0)
             $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILURES = %0d", errors);
        $finish;
    end 
endmodule