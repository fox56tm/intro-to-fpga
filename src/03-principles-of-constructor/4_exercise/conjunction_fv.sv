module conjunction_fv (
    input logic a,
    input logic b
);
    logic sheffer_out;
    logic peirce_out;

    peirce_arrow_conj conj1(
        .a(a),
        .b(b),
        .c_out(peirce_out)
    );

    sheffer_stroke_conj conj2 (
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
