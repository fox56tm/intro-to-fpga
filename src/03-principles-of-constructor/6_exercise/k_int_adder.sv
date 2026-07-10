module k_int_adder #(
    parameter int K = 5
  )(
    input int digits[K],
    output int sum
  );
    int temp_sum[K-1];
    assign temp_sum[0] = digits[0] + digits[1];
    genvar i;
    generate
      for(i = 1; i < K - 1; i++)
        assign temp_sum[i] = temp_sum[i-1] + digits[i+1];
    endgenerate
    
    assign sum = temp_sum[K-2];
endmodule
