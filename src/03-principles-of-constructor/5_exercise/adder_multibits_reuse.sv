module adder_multibits_reuse #(
  parameter int COUNT_OF_BITS = 4
) (
  input logic [COUNT_OF_BITS-1:0] a,
  input logic [COUNT_OF_BITS-1:0] b,
  input logic c_in,
  output logic c_out,
  output logic [COUNT_OF_BITS-1:0] sum
);module adder_multibits_reuse #(
  parameter int COUNT_OF_BITS = 4 
) (
  input logic [COUNT_OF_BITS-1:0] a, 
  input logic [COUNT_OF_BITS-1:0] b,
  input logic c_in,
  output logic c_out,
  output logic [COUNT_OF_BITS-1:0] sum
);

  logic [COUNT_OF_BITS:0] carry;

  assign carry[0] = c_in;
  assign c_out = carry[COUNT_OF_BITS];

  genvar i;
  generate
    for (i = 0; i < COUNT_OF_BITS; i++)
      adder_logic_1_bit add(
        .a(a[i]),
        .b(b[i]),
        .c_in(carry[i]),
        .c_out(carry[i + 1]),
        .sum(sum[i])
      );
  endgenerate
endmodule
