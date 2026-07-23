module in_line_buffer #(
  parameter int M = 3,
  parameter int IMAGE_STR_LEN = 20
  )(
  input logic [7:0] s_data,
  input logic [$clog2(M+1)-1:0] sel,
  input logic clk,
  input logic aresetn,

  input logic s_valid,
  output logic s_ready,

  input logic m_ready,
  output logic [7:0] to_conv1d [M][IMAGE_STR_LEN],
  output logic m_valid
  );
  logic [7:0] buffer [M+1][IMAGE_STR_LEN];
  logic valid_ff; 
  int str_cnt;
  int pix_cnt;

  always_ff @(posedge clk or negedge aresetn) begin
    if(~aresetn) begin
      buffer <= '0;
      valid_ff <= '0;
      str_cnt <= 0;
      pix_cnt <= 1;
    end
    else begin
      if (m_valid && m_ready) begin
        valid_ff <= '0;
      end
      if(s_valid && s_ready) begin
        buffer[sel][0] <= s_data;
        for(int i = 1; i < IMAGE_STR_LEN; i++) begin
          buffer[sel][i] <= buffer[sel][i-1];
        end
        if(pix_cnt < IMAGE_STR_LEN) begin
          pix_cnt <= pix_cnt + 1;
        end
        else begin
          pix_cnt <= 1;
          if(str_cnt < M) begin
            str_cnt <= str_cnt + 1;
          end
        end
        if (str_cnt == M || (str_cnt == M - 1 && pix_cnt == IMAGE_STR_LEN)) begin
          valid_ff <= '1';
        end
      end
    end
  end

  always_comb begin
    m_valid = valid_ff;
    s_ready = ~valid_ff || m_ready;
    for (int i = 0; i < M; i++)
      to_conv1d[i] = buffer[(sel + i + 1) % (M+1)];
  end

endmodule
