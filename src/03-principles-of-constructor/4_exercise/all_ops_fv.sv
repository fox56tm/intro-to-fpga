module all_ops_fv (
    input logic a,
    input logic b
);
    logic sheff_implic_out, sheff_conj_out, sheff_disj_out;
    logic peirce_implic_out, peirce_conj_out, peirce_disj_out;

    peirce_arrow_conj conj1 (.a(a), .b(b), .c_out(peirce_conj_out));
    sheffer_stroke_conj conj2 (.a(a), .b(b), .c_out(sheff_conj_out));

    peirce_arrow_disj disj1 (.a(a), .b(b), .c_out(peirce_disj_out));
    sheffer_stroke_disj disj2 (.a(a), .b(b), .c_out(sheff_disj_out));

    peirce_arrow_implic imp1 (.a(a), .b(b), .c_out(peirce_implic_out));
    sheffer_stroke_implic imp2 (.a(a), .b(b), .c_out(sheff_implic_out));

`ifdef FORMAL
    always @* begin
        assert (peirce_conj_out == sheff_conj_out);
        assert (peirce_disj_out == sheff_disj_out);
        assert (peirce_implic_out == sheff_implic_out);
    end
`endif

endmodule
