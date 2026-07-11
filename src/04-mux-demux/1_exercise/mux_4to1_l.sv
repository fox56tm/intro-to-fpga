module mux_4to1_l(
  input logic[3:0] in,
  input logic [1:0] sel, // mux_2to1 c_out = (in1 & sel) | (in0 & ~sel) = sel ? in1 : in0
  output logic c_out
  );
  logic [1:0] temp_i; 

  assign temp_i[0] = (in[1] & sel[0]) | (in[0] & ~sel[0]);
  assign temp_i[1] = (in[3] & sel[0]) | (in[2] & ~sel[0]);
  assign c_out = (temp_i[1] & sel[1]) | (temp_i[0] & ~sel[1]);

endmodule
