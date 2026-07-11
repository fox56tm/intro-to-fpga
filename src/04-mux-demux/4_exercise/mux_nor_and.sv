//~(a | b) & c
// 000 -> 0
// 001 -> 1
// 010 -> 0
// 011 -> 0
// 100 -> 0
// 101 -> 0
// 110 -> 0
// 111 -> 0
module mux_nor_and(
  input logic a, b, c,
  output logic out
  );
  logic not_a, temp;
  
  mux_2to1 mux1 (
    .in0(1'b1),
    .in1(1'b0),
    .sel(a),
    .out(not_a)
  );
  mux_2to1 mux2 (
    .in0(not_a),
    .in1(1'b0),
    .sel(b),
    .out(temp)
  );
  mux_2to1 mux3 (
    .in0(1'b0),
    .in1(temp),
    .sel(c),
    .out(out)
  );

endmodule
