// this module compile with mux_4to1_l from 1_exercise 
module lut_peirce_arrow ( 
  input logic a, b,
  output logic c
);
  mux_4to1_l lut(
    .in({1'b0, 1'b0, 1'b0, 1'b1}),
    .sel({a, b}),
    .c_out(c)
  );

endmodule
