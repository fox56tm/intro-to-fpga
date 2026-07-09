module test_all_tb;

    logic a, b;
    logic sheff_implic_out, sheff_conj_out, sheff_disj_out;
    logic peirce_implic_out, peirce_conj_out, peirce_disj_out;

    sheffer_stroke_conj conj_s (.a(a), .b(b), .c_out(sheff_conj_out));
    sheffer_stroke_implic implic_s (.a(a), .b(b), .c_out(sheff_implic_out));
    sheffer_stroke_disj disj_s (.a(a), .b(b), .c_out(sheff_disj_out));

    peirce_arrow_conj conj_p (.a(a), .b(b), .c_out(peirce_conj_out));
    peirce_arrow_implic implic_p (.a(a), .b(b), .c_out(peirce_implic_out));
    peirce_arrow_disj disj_p (.a(a), .b(b), .c_out(peirce_disj_out));

    initial begin
        for(int i = 0; i < 4; i++) begin
            {a,b} = i[1:0];
            #10;

            assert(sheff_conj_out === (a && b)) else $error("sheffer stroke conjunction failed");
            assert(sheff_implic_out === (!a || b)) else $error("sheffer stroke implication failed");
            assert(sheff_disj_out === (a || b)) else $error("sheffer stroke disjunction failed");

            assert(peirce_conj_out === (a && b)) else $error("peirce arrow conjunction failed");
            assert(peirce_implic_out === (!a || b)) else $error("peirce arrow implication failed");
            assert(peirce_disj_out === (a || b)) else $error("peirce arrow disjunction failed");
        end
        $finish;
    end

endmodule
