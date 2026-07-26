module decoder (
  input logic clk,
  input logic aresetn,

  input logic bit_in,
  input logic s_valid,
  output logic s_ready,

  input logic m_ready,
  output logic [7:0] char_out,
  output logic m_valid
  );
  typedef enum logic [1:0] {
    s0,
    s1,
    s2
  } states;

  states curr_state, next_state;
  logic [7:0] byte_out_comb;
  logic valid;
  logic flag_decode;

  always_ff @(posedge clk or negedge aresetn) begin
    if(~aresetn)begin
      curr_state <= s0;
      valid <= '0;
    end
    else begin
      if(s_ready && s_valid) begin
        curr_state <= next_state;
      end
      if(flag_decode) begin
        valid <= '1;
        char_out <= byte_out_comb;
      end
      else if (m_valid && m_ready) begin
        valid <= '0;
      end
    end
  end

  assign m_valid = valid;
  assign s_ready = ~valid || (m_ready && m_valid);

  always_comb begin
    next_state = curr_state;
    byte_out_comb = '0;
    flag_decode = '0;
    if (s_valid && s_ready) begin
      case(curr_state)
        s0: begin 
          if(bit_in == 1'b0) begin
            byte_out_comb = 8'h41;
            next_state = s0;
            flag_decode = '1;
          end
          else begin
            next_state = s1;
          end
        end
        s1: begin
          if(bit_in == 1'b0) begin
            next_state = s0;
            byte_out_comb = 8'h54;
            flag_decode = '1;
          end
          else begin
            next_state = s2;
          end
        end
        s2: begin
          if(bit_in == 1'b0) begin
            next_state = s0;
            byte_out_comb = 8'h47;
            flag_decode = '1;
          end
          else begin
            next_state = s0;
            byte_out_comb = 8'h43;
            flag_decode = '1;
          end
        end
        default: next_state = s0;
      endcase
    end
  end

endmodule
