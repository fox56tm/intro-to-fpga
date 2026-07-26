module codec_top (
  input logic clk,
  input logic aresetn,

  input logic [7:0] byte_in,
  input logic s_valid,
  output logic s_ready,

  input logic m_ready,
  output logic [7:0] char_out,
  output logic m_valid
  );

  logic bit_link;
  logic enc_m_valid;
  logic dec_s_ready;

  encoder u_enc (
    .clk(clk), .aresetn(aresetn),
    .byte_in(byte_in), .s_valid(s_valid), .s_ready(s_ready),
    .m_ready(dec_s_ready), .bit_out(bit_link), .m_valid(enc_m_valid)
  );

  decoder u_dec (
    .clk(clk), .aresetn(aresetn),
    .bit_in(bit_link), .s_valid(enc_m_valid), .s_ready(dec_s_ready),
    .m_ready(m_ready), .char_out(char_out), .m_valid(m_valid)
  );

endmodule
