module mux_implication( 
  input logic a,b,
  output logic out
    );
    logic temp;
    mux_2to1 mux (
      .in0(1'b1),
      .in1(b),
      .sel(a),
      .out(out)
    );

endmodule
