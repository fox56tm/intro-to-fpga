module counter #(
  parameter int VECTOR_SIZE = 4
)(
  input logic [VECTOR_SIZE-1:0] vector,
  input logic clk,
  input logic rst,
  output logic [VECTOR_SIZE-1:0] count_1,
  output logic [VECTOR_SIZE-1:0] count_0
 );
  logic [VECTOR_SIZE-1:0] bit_counter;
  logic curr_bit;
  logic [VECTOR_SIZE-1:0] temp_vector;
  logic [VECTOR_SIZE-1:0] count_1_temp;
  logic [VECTOR_SIZE-1:0] count_0_temp;

  assign count_1 = count_1_temp;
  assign count_0 = count_0_temp;
  assign curr_bit = temp_vector[0];

  always_ff @(posedge clk) begin
    if(rst)begin
      temp_vector <= vector;
      count_1_temp <= '0;
      count_0_temp <= '0;
      bit_counter <= '0;
    end
    else begin
      if(bit_counter < VECTOR_SIZE) begin
        if(curr_bit == 1'b1) begin
          count_1_temp <= count_1_temp + 1'b1;
        end
        else begin
          count_0_temp <= count_0_temp + 1'b1;
        end
        temp_vector <= temp_vector >> 1;
        bit_counter <= bit_counter + 1'b1;
      end
    end
  end

endmodule
