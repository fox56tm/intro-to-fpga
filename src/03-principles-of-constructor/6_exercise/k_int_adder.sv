module k_int_adder #(
    parameter int K = 5
    )(
        input int digits[K],
        output int sum
    );
        int temp_sum[K-1];
        adder_multibits_int adder_first(
            .a(digits[0]),
            .b(digits[1]),
            .sum(temp_sum[0])
        );
        genvar i;
        generate
        for(i = 1; i < K - 1; i++)
            adder_multibits_int adder_new(
                .a(temp_sum[i-1]),
                .b(digits[i+1]),
                .sum(temp_sum[i])
            );
        endgenerate
        assign sum = temp_sum[K-2];
endmodule
