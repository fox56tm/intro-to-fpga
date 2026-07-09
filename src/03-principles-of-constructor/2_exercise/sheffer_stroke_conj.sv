module sheffer_stroke_conj (
    input logic a,
    input logic b,
    output logic c_out
);
    logic temp;
    sheffer_stroke stroke1( 
        .a(a),
        .b(b),
        .c_out(temp)
    );

    sheffer_stroke stroke1( 
        .a(temp),
        .b(temp),
        .c_out(c_out)
    );

endmodulemodule sheffer_stroke_conj (
    input logic a;
    input logic b;
    output logic c_out;
);
    logic temp;
    sheffer_stroke stroke1( 
        .a(a),
        .b(b),
        .c_out(temp)
    );

    sheffer_stroke stroke1( 
        .a(temp),
        .b(temp),
        .c_out(c_out)
    );

endmodule
