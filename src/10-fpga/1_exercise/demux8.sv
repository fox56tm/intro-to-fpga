module demux8 (
    input  logic [3:0] number_i,
    output logic [7:0] select_o
);
  always_comb begin
    unique case (number_i)
      'd1: select_o = 8'b0000_0001;
      'd2: select_o = 8'b0000_0010;
      'd3: select_o = 8'b0000_0100;
      'd4: select_o = 8'b0000_1000;
      'd5: select_o = 8'b0001_0000;
      'd6: select_o = 8'b0010_0000;
      'd7: select_o = 8'b0100_0000;
      'd8: select_o = 8'b1000_0000;
      default: select_o = '0;
    endcase
  end
endmodule
