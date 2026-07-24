module windowed #(
  parameter int WIN_SIZE = 3
  )(
  input logic clk,
  input logic aresetn,

  input logic [7:0] s_data,
  output logic s_ready,
  input logic s_valid,

  input logic m_ready,
  output logic m_valid,
  output logic [WIN_SIZE-1:0][7:0] m_data
  );

  logic [WIN_SIZE-1:0][7:0] data_ff;
  logic valid_ff;
  int count;
  
  always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
      data_ff <= '0;
      valid_ff <= '0;
      count <= 0;
    end else begin
      if (m_valid && m_ready) begin
        valid_ff <= '0;
      end
      if (s_valid && s_ready) begin
        data_ff <= {data_ff[WIN_SIZE-2:0], s_data};
        if (count == WIN_SIZE - 1) begin
          valid_ff <= '1;
        end else begin
          count <= count + 1;
        end
      end
    end
  end

  always_comb begin
    m_data = data_ff;
    m_valid = valid_ff;
    s_ready = ~valid_ff || m_ready;
  end

endmodule
