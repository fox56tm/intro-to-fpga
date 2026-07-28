module huffman_top (  // <1>
    input logic clk_i,
    // inputs
    input logic btn_i,   // <2>
    input logic rst_btn_i,

    // outputs
    output logic [7:0] led_o  // <3>
);

  logic btn_db;

  debouncer btn_0_debouncer (  // <4>
      .clk_i(clk_i),
      .rst_ni(rst_btn_i),
      .btn_i(btn_i),
      .btn_db_o(btn_db)
  );


  logic btn;

  re_detector btn_0_re_detector (  // <5>
      .clk_i (clk_i),
      .rst_ni(rst_btn_i),
      .in_i  (btn_db),
      .out_o (btn)
  );

  logic [2:0] number;

  counter_led led_rsm (  // <6>
      .btn_i(btn),
      .number_o(number),
      .clk_i(clk_i),
      .rst_ni(rst_btn_i)
  );

  logic [7:0] inv_select;

  demux8 demux_led (  // <7>
      .number_i(number),
      .select_o(inv_select)
  );

  assign led_o = ~inv_select;

endmodule
