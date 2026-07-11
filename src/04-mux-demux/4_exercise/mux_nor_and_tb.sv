module mux_nor_and_tb;

  logic a, b, c;
  logic out;

  logic [7:0] expected_out = 8'b0000_0010;

  mux_nor_and dut (
    .a(a),
    .b(b),
    .c(c),
    .out(out)
  );

  initial begin
    for (int i = 0; i < 8; i++) begin
      {a, b, c} = i[2:0];
      #10;
      assert (out === expected_out[i])
      else $fatal(1, "mux_nor_and_tb error! a=%b, b=%b, c=%b, out=%b, expected=%b",
               a, b, c, out, expected_out[i]);
    end
    $display("===All tests done!===");
    $finish;
  end

endmodule
