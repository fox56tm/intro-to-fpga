module adder_k_n_bits #(
    parameter int K = 5,
    parameter int N = 4
  )(
    input logic [N - 1 : 0] digits [K],
    output logic [N - 1 : 0] sum
  );
    logic [N - 1 : 0] temp_sums [K - 1];
    logic [K - 1 : 0] dum_bits;

    adder_multibits_reuse #(
            .COUNT_OF_BITS(N)
    ) adder1 (
        .a(digits[0]),
        .b(digits[1]),
        .c_in(1'b0),
        .c_out(dum_bits[0]),
        .sum(temp_sums[0])
    );
    genvar i;
    generate
      for(i = 1; i < K-1; i++ )
        adder_multibits_reuse #(
            .COUNT_OF_BITS(N)
        ) adder (
            .a(temp_sums[i-1]),
            .b(digits[i+1]),
            .c_in(1'b0),
            .c_out(dum_bits[i]),
            .sum(temp_sums[i])
        );
    endgenerate
    assign sum = temp_sums[K-2];
endmodule
