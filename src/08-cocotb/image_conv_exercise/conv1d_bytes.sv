module conv1d_bytes #(
  parameter int KERNEL_SIZE = 3
  )(
  input logic clk,
  input logic aresetn,

  input logic w_valid, // for weight
  output logic w_ready,
  input logic [31:0] weight_in,

  input logic [7:0] s_data, // for bytes
  input logic s_valid,
  output logic s_ready,

  input logic m_ready, // conv1d self ports
  output logic [7:0] m_data,
  output logic m_valid

  );

  logic [31:0] weights_in_ker [KERNEL_SIZE]; 
  logic [KERNEL_SIZE-1:0][7:0] win_out;
  logic win_ready; // for windowed
  logic win_valid;
  logic valid_ff; // for m_valid
  int counter;

  windowed_bytes #(
    .WIN_SIZE(3)
  ) wind (
    .clk(clk),
    .aresetn(aresetn),
    .s_data(s_data),
    .s_ready(s_ready),
    .s_valid(s_valid),
    .m_ready(win_ready),
    .m_valid(win_valid),
    .m_data(win_out)
  );

  scalar_product #(
    .VECTORS_SIZE(KERNEL_SIZE)
  ) prod (
    .float(weights_in_ker),
    .uint8_in(win_out),
    .uint8_res(m_data)
  );

  always_ff @(posedge clk or negedge aresetn) begin 
    if (~aresetn) begin
      valid_ff <= '0;
      counter <= 0;
      for (int i = 0; i < KERNEL_SIZE; i++) begin
        weights_in_ker[i] <= '0;
      end
    end
    else begin
      if(counter < KERNEL_SIZE) begin
        if (w_valid && w_ready) begin
          weights_in_ker[0] <= weight_in;
          for(int i = 1; i < KERNEL_SIZE; i++) begin
            weights_in_ker[i] <= weights_in_ker[i-1];
          end
          counter <= counter + 1;
        end
      end
      if (win_ready && win_valid) begin // data's from windowed module are ready
        valid_ff <= '1;
      end
      else if (m_ready && m_valid) begin
        valid_ff <= '0;
      end
    end
  end

  always_comb begin
    w_ready = (counter < KERNEL_SIZE);
    m_valid = valid_ff;
    win_ready = (counter == KERNEL_SIZE) && (~valid_ff || m_ready);
  end

endmodule
