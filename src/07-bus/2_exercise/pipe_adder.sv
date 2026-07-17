module pipe_adder(
  input logic clk,
  input logic aresetn,

    // Input from master 1
  input logic s_valid_1,
  output logic s_ready_1,
  input logic s_data_1,

    // Input from master 2
  input logic s_valid_2,
  output logic s_ready_2,
  input logic s_data_2,

    // Output to slave
  output logic m_valid,
  input logic m_ready,
  output logic m_data
  );

  logic over_bit;
  logic data_ff;
  logic valid_ff;
  
  always_ff @(posedge clk or negedge aresetn) begin
    if(~aresetn) begin
      over_bit <= '0;
      valid_ff <= '0;
    end else begin 
      if((s_valid_1 && s_ready_1) && (s_valid_2 && s_ready_2)) begin
        {over_bit, data_ff} <= s_data_1 + s_data_2 + over_bit;
        valid_ff <= '1;
      end
      else if(m_valid && m_ready) begin
        valid_ff <= '0;
      end
      if(~s_valid_1 && ~s_valid_2) begin
        over_bit <= '0;
      end
    end
  end

    always_comb begin
      m_valid = valid_ff;
      m_data = data_ff;
      s_ready_1 = m_ready || ~valid_ff;
      s_ready_2 = m_ready || ~valid_ff;
    end

endmodule
