module not_implication(
    input logic a,
    input logic b,
    output logic c_out
);
    assign c_out = a & ~b;
endmodule
