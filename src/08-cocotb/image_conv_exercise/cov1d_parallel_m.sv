module cov1d_parallel_m #(
  parameter int M = 3,
  parameter int KERNEL_SIZE = 3
  )(
    input logic clk,
    input logic aresetn,

    input logic w_valid, // for weight
    output logic w_ready,
    input logic [31:0] weight_in,

    input logic s_valid, 
    input logic [7:0] s_data [M],
    output logic s_ready,

    output logic m_valid,
    output logic [7:0] m_data [M],
    input logic m_ready
  );
    logic w_ready_m [M]; // for all M parallel modules 
    logic s_ready_m [M];
    logic m_valid_m [M];
    genvar i;
    generate
        for(i = 0; i < M; i++) begin
        conv1d_bytes #(
            .KERNEL_SIZE(KERNEL_SIZE)
        ) conv1d (
            .clk(clk),
            .aresetn(aresetn),

            .w_ready(w_ready_m[i]),
            .w_valid(w_valid),
            .weight_in(weight_in),

            .s_ready(s_ready_m[i]),
            .s_valid(s_valid),
            .s_data(s_data[i]),
            
            .m_ready(m_ready),
            .m_data(m_data[i]),
            .m_valid(m_valid_m[i])
        );
        end
    endgenerate

  always_comb begin
    s_ready = 1'b1;
    w_ready = 1'b1;
    m_valid = 1'b1;
    for (int j = 0; j < M; j++) begin
        s_ready &= s_ready_m[j];
        w_ready &= w_ready_m[j];
        m_valid &= m_valid_m[j];
    end
  end
endmodule
