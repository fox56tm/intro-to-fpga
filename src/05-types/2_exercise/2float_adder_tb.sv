module float_adder_tb;

  logic [31:0] float1;
  logic [31:0] float2;
  logic [31:0] sum;

  logic [31:0] expected_sum [4] = '{
    32'h40000000, 
    32'h40800000, 
    32'h40400000, 
    32'h00000000
  };

  float_adder dut (
    .float1(float1),
    .float2(float2),
    .sum(sum)
  );

  initial begin
    // 1.0 + 1.0 = 2.0
    float1 = 32'h3F800000;
    float2 = 32'h3F800000;
    #10;
    assert(sum === expected_sum[0])
    else $fatal(1, "Error Test 0! float1=%h, float2=%h, sum=%h, expected=%h", 
                   float1, float2, sum, expected_sum[0]);

    //2.5 + 1.5 = 4.0
    float1 = 32'h40200000;
    float2 = 32'h3FC00000;
    #10;
    assert(sum === expected_sum[1])
    else $fatal(1, "Error Test 1! float1=%h, float2=%h, sum=%h, expected=%h", 
                   float1, float2, sum, expected_sum[1]);

    // 5.0 + (-2.0) = 3.0
    float1 = 32'h40A00000;
    float2 = 32'hC0000000;
    #10;
    assert(sum === expected_sum[2])
    else $fatal(1, "Error Test 2! float1=%h, float2=%h, sum=%h, expected=%h", 
                   float1, float2, sum, expected_sum[2]);

    //-3.0 + 3.0 = 0.0
    float1 = 32'hC0400000;
    float2 = 32'h40400000;
    #10;
    assert(sum === expected_sum[3])
    else $fatal(1, "Error Test 3! float1=%h, float2=%h, sum=%h, expected=%h", 
                   float1, float2, sum, expected_sum[3]);

    $display("===All tests done!===");
    $finish;
  end

endmodule
