module mux_implication_tb;

logic a,b,out;
logic [3:0] expected_out = 4'b1011;
mux_implication mux_impl(
  .a(a),
  .b(b),
  .out(out)
  );

  initial begin
    for(int i = 0; i < 4; i++) begin
      {a,b} = i[1:0];
      #10;
      assert(out === expected_out[i]);
      else $fatal(1,"mux_implication_tb error!!! a = %b, b = %b, out = %b, expected = %b", 
                    a, b, out, expected_out[i]);
    end
    $display("===All tests done!===");
    $finish;
  end
endmodule
