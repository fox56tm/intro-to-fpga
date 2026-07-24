module image_conv #(
  parameter int M = 3,
  parameter int KERNEL_SIZE = 3,
  parameter int IMAGE_STR_LEN = 20
  )(
  input logic clk,
  input logic aresetn,

  input logic w_valid,
  output logic w_ready,
  input logic [31:0] weight_in,

  input logic [7:0] s_data,
  input logic [$clog2(M+1)-1:0] sel,
  input logic s_valid,
  output logic s_ready,

  input logic m_ready,
  output logic m_valid,
  output logic [7:0] m_data [M]
  );

  logic [7:0] buf_out [M][IMAGE_STR_LEN];
  logic [7:0] conv_in [M];
  logic buf_valid;
  logic conv_ready;
  int col_idx;
  logic buff_consumed;

  always_comb begin
    for (int i = 0; i < M; i++) begin
      conv_in[i] = buf_out[i][col_idx];
    end
    buf_consumed = buf_valid && conv_ready && (col_idx == IMAGE_STR_LEN - 1);
  end

  always_ff @(posedge clk or negedge aresetn) begin 
    if (~aresetn) begin 
      col_idx <= 0;
    end else begin
      if (buf_valid && conv_ready) begin
        if (col_idx == IMAGE_STR_LEN - 1) begin
          col_idx <= 0;
        end else begin
          col_idx <= col_idx + 1;
        end
      end
    end
  end

  in_line_buffer #(
    .M(M),
    .IMAGE_STR_LEN(IMAGE_STR_LEN)
  ) buffer (
    .clk(clk),
    .aresetn(aresetn),
    .s_data(s_data),
    .sel(sel),
    .s_valid(s_valid),
    .s_ready(s_ready),
    .m_ready(buf_consumed),
    .to_conv1d(buf_out),
    .m_valid(buf_valid)
  );

  conv1d_parallel_m #(
    .M(M),
    .KERNEL_SIZE(KERNEL_SIZE)
  ) parallel_conv (
    .clk(clk),
    .aresetn(aresetn),
    .w_valid(w_valid),
    .w_ready(w_ready),
    .weight_in(weight_in),
    .s_valid(buf_valid),
    .s_ready(conv_ready),
    .s_data(conv_in),
    .m_valid(m_valid),
    .m_data(m_data),
    .m_ready(m_ready)
  );

endmodule
