module mux_4to1_l_tb;

logic [3:0] in;
logic [1:0] sel;
logic c_out_l;
logic c_out_expected;

mux_4to1_l mux4_1_l(
  .in(in),
  .sel(sel),
  .c_out(c_out_l)
  );
mux_4to1 mux4_1_base(
  .in(in),
  .sel(sel),
  .out(c_out_expected)
  );
initial begin
  for(int i = 0; i < 64; i++) begin
    {sel[0],sel[1], in[0], in[1], in[2], in[3]} = i[5:0];
    #10;
    assert(c_out_l === c_out_expected);
    else $fatal(1, "error in mux4_to_l_tb! sel=%b, in=%b, out=%b, expected=%b",
                sel, in, c_out_l, c_out_expected);
  end
  $display("===All tests done!===");
  $finish;
end 

endmodule
