module float_mult_byte_modified_tb;

  logic [31:0] float_in;
  byte unsigned uint8_in;
  byte unsigned uint8_out;

  byte unsigned expected_out [4] = '{8'd0, 8'd255, 8'd0, 8'd0};

  float_mult_byte_modified dut (
    .float_in(float_in),
    .uint8_in(uint8_in),
    .uint8_out(uint8_out)
  );

  initial begin
    // -Inf
    float_in = 32'hFF800000;
    uint8_in = 8'd10;
    #10;
    assert(uint8_out === expected_out[0])
    else $fatal(1, "Error Test 0 (-Inf)! float_in=%h, uint8_in=%d, out=%d, expected=%d", 
                   float_in, uint8_in, uint8_out, expected_out[0]);

    //+Inf and uint8_in > 0
    float_in = 32'h7F800000;
    uint8_in = 8'd5;
    #10;
    assert(uint8_out === expected_out[1])
    else $fatal(1, "Error Test 1 (+Inf, >0)! float_in=%h, uint8_in=%d, out=%d, expected=%d", 
                   float_in, uint8_in, uint8_out, expected_out[1]);

    //+Inf and uint8_in == 0
    float_in = 32'h7F800000;
    uint8_in = 8'd0;
    #10;
    assert(uint8_out === expected_out[2])
    else $fatal(1, "Error Test 2 (+Inf, ==0)! float_in=%h, uint8_in=%d, out=%d, expected=%d", 
                   float_in, uint8_in, uint8_out, expected_out[2]);

    //NaN
    float_in = 32'h7FC00000;
    uint8_in = 8'd10;
    #10;
    assert(uint8_out === expected_out[3])
    else $fatal(1, "Error Test 3 (NaN)! float_in=%h, uint8_in=%d, out=%d, expected=%d", 
                   float_in, uint8_in, uint8_out, expected_out[3]);

    $display("===All tests done!===");
    $finish;
  end

endmodule
