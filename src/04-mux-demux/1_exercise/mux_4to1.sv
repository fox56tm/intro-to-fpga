module mux_4to1 (
  input logic[3:0] in,
  input logic [1:0] sel,
  output logic out
);
  logic [1:0] temp_i;

  mux_2to1 mux1 (
    .in0(in[0]),
    .in1(in[1]),
    .sel(sel[0]),
    .out(temp_i[0])
  );

  mux_2to1 mux2 (
      .in0(in[2]),
      .in1(in[3]),
      .sel(sel[0]),
      .out(temp_i[1])
  );

  mux_2to1 mux3 (
    .in0(temp_i[0]),
    .in1(temp_i[1]),
    .sel(sel[1]),
    .out(out)
  );
endmodule
