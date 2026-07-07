module sheffer_stroke_tb;

  logic c_out, a, b;
 
  const logic [3:0] AParams = 4'b0011;
  const logic [3:0] BParams = 4'b0101; 
  const logic [3:0] COutExpected = 4'b1000;

  sheffer_stroke sheff_stroke (
      .a(a),
      .b(b),
      .c_out(c_out)
  );

  initial begin
    for (
        int i = 0; i < 4; i++
    )  
    begin
      a = AParams[i];
      b = BParams[i];
      #10;
      assert (COutExpected[i] === c_out)
        $display("a = %b, b = %b, expected c_out = %b\n", a, b , c_out);
      else begin
        $display({"error:",
                  "\non that parameters: a = %b, b = %b, c_out = %b",
                  "\nc_out expect = %b"}, a, b, sum, c_out, COutExpected[i]);
        $fatal;  
      end
    end
  end
endmodule