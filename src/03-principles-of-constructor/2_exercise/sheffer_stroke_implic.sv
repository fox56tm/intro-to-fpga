module sheffer_stroke_implic (
    input logic a,
    input logic b,
    output logic c_out
);
    logic not_b;

    sheffer_stroke stroke1(
        .a(a),
        .b(b),
        .c_out(not_b)
    );

    sheffer_stroke stroke2(
        .a(a),
        .b(not_b),
        .c_out(c_out)
    );

endmodule
