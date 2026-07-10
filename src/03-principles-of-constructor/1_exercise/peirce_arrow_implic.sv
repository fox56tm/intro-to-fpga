module peirce_arrow_implic (
    input logic a,
    input logic b, 
    output logic c_out
);
    logic temp1, temp2;  

    peirce_arrow pa1 ( // temp1 = ~a, temp2 = (a & ~b), =>
        .a(a),           // => c_out = ~temp2 & ~temp2 =
        .b(b),           // = (~a | b) & (~a | b)
        .c_out(temp1)
    );

    peirce_arrow pa2 (
        .a(temp1),
        .b(b),
        .c_out(temp2)
    );

    peirce_arrow pa3 ( 
    .a(temp2),
    .b(temp2),
    .c_out(c_out)
    );

endmodule
