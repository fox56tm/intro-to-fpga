module conv1d #(
  parameter int KERNEL_SIZE = 3
  )(
  input logic clk,
  input logic aresetn,

  input logic w_valid, // for weight
  output logic w_ready,
  input logic [31:0] weight_in,

  input logic s_data, // for bytes
  input logic s_valid,
  output logic s_ready,

  input logic m_ready, // conv1d self ports
  output logic [7:0] m_data,
  output logic m_valid

  );

  logic [31:0] weights_in_ker [KERNEL_SIZE];
  logic [7:0] bytes_arr [KERNEL_SIZE];
  logic [7:0] curr_byte;
  logic win_ready; // for windowed
  logic win_valid;
  logic valid_ff; // for m_valid
  int counter;

  windowed #(
    .WIN_SIZE(8)
  ) wind (
    .clk(clk),
    .aresetn(aresetn),
    .s_data(s_data),
    .s_ready(s_ready),
    .s_valid(s_valid),
    .m_ready(win_ready),
    .m_valid(win_valid),
    .m_data(curr_byte)
  );

  scalar_product #(
    .VECTORS_SIZE(KERNEL_SIZE)
  ) prod (
    .float(weights_in_ker),
    .uint8_in(bytes_arr),
    .uint8_res(m_data)
  );

  always_ff @(posedge clk or negedge aresetn) begin 
    if(~aresetn) begin
      valid_ff <= '0;
      counter <= 0;
    end
    else begin
      if(counter < KERNEL_SIZE) begin
        if(w_ready && w_valid) begin
          weights_in_ker <= {weight_in, weights_in_ker[KERNEL_SIZE-1:1]};
          counter <= counter + 1;
        end
      end
      else if(m_ready && m_valid) begin
        valid_ff <= '0;
      end
      else begin 
        valid_ff <= '1;
      end
      if (win_ready && win_valid) begin
        bytes_arr <= {curr_byte, bytes_arr[KERNEL_SIZE-1:1]};
      end
    end
  end

  always_comb begin
    m_valid = valid_ff;
    win_ready = '1;
    w_ready = (counter < KERNEL_SIZE);
  end

endmodule
