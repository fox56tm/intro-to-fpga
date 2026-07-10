module sheffer_stroke_disj (
    input logic a,
    input logic b,
    output logic c_out
);
    logic not_b, not_a;

    sheffer_stroke stroke1(
        .a(a),
        .b(a),
        .c_out(not_a)
    );
    sheffer_stroke stroke2(
        .a(b),
        .b(b),
        .c_out(not_b)
    );
    sheffer_stroke stroke3(
        .a(not_a),
        .b(not_b),
        .c_out(c_out)
    );

endmodule
