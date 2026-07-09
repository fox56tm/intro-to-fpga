module peirce_arrow(
    input logic a,
    input logic b, 
    output logic c_out
);
    assign c_out = ~a & ~b;

  `ifdef FORMAL
    always @* begin
      assert (c_out == ~(a | b));
      cover (a == 1'b0 && b == 1'b0);
      cover (a == 1'b1 || b == 1'b1);
    end
  `endif

endmodule
