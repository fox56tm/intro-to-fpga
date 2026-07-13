module scalar_product #(
  parameter int VECTORS_SIZE = 4
)(
  input logic [31:0] float [VECTORS_SIZE],
  input byte unsigned uint8_in [VECTORS_SIZE],
  output byte unsigned uint8_res
  );

  byte unsigned temp_storage[VECTORS_SIZE];
  genvar i;
  generate;
    for(i = 0; i < VECTORS_SIZE; i++)begin
      float_mult_byte_modified float_mult(
        .float_in(float[i]),
        .uint8_in(uint8_in[i]),
        .uint8_out(temp_storage[i])
      );
    end
  endgenerate

  int unsigned sum;
  always_comb begin
    sum = '0;
    for(int j = 0; j < VECTORS_SIZE; j++)
      sum = sum + temp_storage[j];
    
    uint8_res = (sum > 255) ? 8'd255 : sum[7:0];
  end

endmodule
