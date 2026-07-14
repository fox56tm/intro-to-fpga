module scalar_product_tb;

  localparam int VECTORS_SIZE = 4;

  logic [31:0] float_in [VECTORS_SIZE];
  byte unsigned uint8_in [VECTORS_SIZE];
  byte unsigned uint8_res;

  byte unsigned expected_res [3] = '{8'd50, 8'd255, 8'd30};

  scalar_product #(
    .VECTORS_SIZE(VECTORS_SIZE)
  ) dut (
    .float(float_in),
    .uint8_in(uint8_in),
    .uint8_res(uint8_res)
  );

  initial begin
    float_in = '{32'h3F800000, 32'h40000000, 32'h3F800000, 32'h3F800000};
    uint8_in = '{8'd10, 8'd5, 8'd20, 8'd10};
    #10;
    assert(uint8_res === expected_res[0])
    else $fatal(1, "Error Test 0! uint8_res=%d, expected=%d", uint8_res, expected_res[0]);

    float_in = '{32'h40000000, 32'h40000000, 32'h40000000, 32'h40000000};
    uint8_in = '{8'd50, 8'd50, 8'd50, 8'd50};
    #10;
    assert(uint8_res === expected_res[1])
    else $fatal(1, "Error Test 1! uint8_res=%d, expected=%d", uint8_res, expected_res[1]);

    float_in = '{32'h3F800000, 32'hBF800000, 32'h40000000, 32'h00000000};
    uint8_in = '{8'd10, 8'd10, 8'd10, 8'd10};
    #10;
    assert(uint8_res === expected_res[2])
    else $fatal(1, "Error Test 2! uint8_res=%d, expected=%d", uint8_res, expected_res[2]);

    $display("===All tests done!===");
    $finish;
  end

endmodule
