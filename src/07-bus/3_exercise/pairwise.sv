module pairwise (
  input logic clk,
  input logic aresetn,

  input logic s_data,
  output logic s_ready,
  input logic s_valid,

  input logic m_ready,
  output logic m_valid,
  output logic [1:0] m_data
  );

  logic [1:0] data_ff;
  logic valid_ff;
  logic f_bit;
  
  always_ff @(posedge clk or negedge aresetn) begin
    if(~aresetn) begin
      data_ff <= '0;
      valid_ff <= '0;
      f_bit <= '0;
    end 
    else begin
      if(s_valid && s_ready) begin
          data_ff <= {s_data, data_ff[1]};
          f_bit <= '1;
          if(f_bit) 
            valid_ff <= '1;
      end
      else if(m_ready && m_valid) begin
        valid_ff <= '0;
        f_bit <= '1;
      end
    end
  end

    always_comb begin
      m_data = data_ff;
      m_valid = valid_ff;
      s_ready = ~valid_ff || m_ready;
    end

endmodule
