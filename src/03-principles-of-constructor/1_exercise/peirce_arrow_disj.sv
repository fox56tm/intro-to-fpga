module peirce_arrow_disj (
    input logic a,
    input logic b, 
    output logic c_out
);
    logic temp1;

    peirce_arrow p_arr1 (
        .a(a),
        .b(b),
        .c_out(temp1)
    );
    peirce_arrow p_arr2 (
        .a(temp1),
        .b(temp1),
        .c_out(c_out)
    );

endmodule
