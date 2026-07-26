module encoder (
  input clk,
  input aresetn,

  input logic [7:0] byte_in,
  input logic s_valid,
  output logic s_ready,

  input logic m_ready,
  output logic bit_out,
  output logic m_valid
  );
  typedef enum logic [7:0] {
    A = 8'h41,
    T = 8'h54,
    G = 8'h47,
    C = 8'h43
  } chars;

  logic valid_ff;
  logic [2:0] code_out;
  logic [1:0] len;

  always_comb begin
    case(byte_in)
        A: begin
            code_out = 3'b000; 
            len = 2'd1;
        end
        T: begin
            code_out = 3'b100;
            len = 2'd2;
        end
        G: begin
            code_out = 3'b110;
            len = 2'd3;
        end
        C: begin
            code_out = 3'b111;
            len = 2'd3;
        end
        default: begin
            code_out = 3'b000;
            len = 2'd0;
        end
    endcase
  end

  logic [1:0] bit_cnt;
  logic [2:0] buffer;

  always_ff @(posedge clk or negedge aresetn) begin
    if(~aresetn) begin
      valid_ff <= '0;
      bit_cnt <= '0;
      buffer <= '0;
    end
    else begin
      if(s_ready && s_valid) begin
        buffer <= code_out;
        bit_cnt <= len;
        valid_ff <= '1;
      end
    else if(m_ready && valid_ff) begin
          buffer <= (buffer << 1);
          bit_cnt <= bit_cnt - 1;
          if(bit_cnt == 1) begin
            valid_ff <= '0;
          end
        end
      end
  end

  always_comb begin
    bit_out = buffer[2]; 
    m_valid = valid_ff;
    s_ready = (m_ready && (bit_cnt == 1)) || ~valid_ff;
  end
endmodule
