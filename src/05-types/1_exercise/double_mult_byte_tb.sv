module double_mult_byte_tb;

  byte unsigned int8_in;
  logic [63:0] double_in;
  byte unsigned int8_out;

  byte unsigned expected_out[5] = '{8'd0, 8'd10, 8'd50, 8'd0, 8'd255};

  double_mult_byte dut (
    .int8_in(int8_in),
    .double_in(double_in),
    .int8_out(int8_out)
  );

  initial begin
    //0 * 5.0
    int8_in   = 8'd0;
    double_in = 64'h4014000000000000;
    #10;
    assert(int8_out === expected_out[0])
    else $fatal(1, "Error Test 0! int8_in=%d, double_in=%h, out=%d, expected=%d", 
                   int8_in, double_in, int8_out, expected_out[0]);

    //10 * 1.0
    int8_in   = 8'd10;
    double_in = 64'h3FF0000000000000;
    #10;
    assert(int8_out === expected_out[1])
    else $fatal(1, "Error Test 1! int8_in=%d, double_in=%h, out=%d, expected=%d", 
                   int8_in, double_in, int8_out, expected_out[1]);

    //20 * 2.5
    int8_in   = 8'd20;
    double_in = 64'h4004000000000000;
    #10;
    assert(int8_out === expected_out[2])
    else $fatal(1, "Error Test 2! int8_in=%d, double_in=%h, out=%d, expected=%d", 
                   int8_in, double_in, int8_out, expected_out[2]);

    //100 * -1.0
    int8_in   = 8'd100;
    double_in = 64'hBFF0000000000000;
    #10;
    assert(int8_out === expected_out[3])
    else $fatal(1, "Error Test 3! int8_in=%d, double_in=%h, out=%d, expected=%d", 
                   int8_in, double_in, int8_out, expected_out[3]);

    //200 * 2.0
    int8_in   = 8'd200;
    double_in = 64'h4000000000000000;
    #10;
    assert(int8_out === expected_out[4])
    else $fatal(1, "Error Test 4! int8_in=%d, double_in=%h, out=%d, expected=%d", 
                   int8_in, double_in, int8_out, expected_out[4]);

    $display("===All tests done!===");
    $finish;
  end

endmodule
