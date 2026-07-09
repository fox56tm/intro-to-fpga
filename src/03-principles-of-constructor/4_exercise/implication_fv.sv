module implication_fv (
    input logic a,
    input logic b
);
    logic sheffer_out;
    logic peirce_out;

    peirce_arrow_implic implic1(
        .a(a),
        .b(b),
        .c_out(peirce_out)
    );

    sheffer_stroke_implic implic2 (
        .a(a),
        .b(b),
        .c_out(sheffer_out)
    );

    `ifdef FORMAL
      always @* begin
        assert(peirce_out == sheffer_out);
    end
`endif

endmodule
