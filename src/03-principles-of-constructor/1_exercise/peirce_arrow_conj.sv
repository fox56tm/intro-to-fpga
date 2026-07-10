module peirce_arrow_conj (
    input logic a,
    input logic b, 
    output logic c_out
);
    logic not_a, not_b;

    peirce_arrow p_arr1 (
        .a(a),
        .b(a),
        .c_out(not_a)
    );
    peirce_arrow p_arr2 (
        .a(b),
        .b(b),
        .c_out(not_b)
    );
    peirce_arrow p_arr3 (
        .a(not_a),
        .b(not_b),
        .c_out(c_out)
    );

endmodule
