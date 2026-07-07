module adder_logic_1_bit_tb;

    logic a, b, c_in, c_out, sum;

    adder_logic_1_bit add(
        .a(a),
        .b(b),
        .c_in(c_in),
        .c_out(c_out),
        .sum(sum)
    );

    initial 
       begin
            a = 0;
            b = 1;
            c_in = 0;
            #10; 
            $display("%b + %b + %b = %b (%b)",
                    c_in, a, b, sum, c_out);
            a = 1;
            b = 1;
            c_in = 0;
            #10;
            $display("%b + %b + %b = %b (%b)",
                    c_in, a, b, sum, c_out);
            a = 0;
            b = 0;
            c_in = 1;
            #10;
            $display("%b + %b + %b = %b (%b)",
                    c_in, a, b, sum, c_out);
       end
endmodule