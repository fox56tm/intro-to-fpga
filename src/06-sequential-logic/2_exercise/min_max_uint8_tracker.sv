module min_max_uint8_tracker #(
  parameter int COUNT_OF_BITS = 4
  )(
    input logic clk,
    input logic rst,
    input logic [COUNT_OF_BITS-1:0] num,
    output logic [COUNT_OF_BITS-1:0] min,
    output logic [COUNT_OF_BITS-1:0] max
  );
    logic [COUNT_OF_BITS-1:0] min_temp;
    logic [COUNT_OF_BITS-1:0] max_temp;
    assign max = max_temp;
    assign min = min_temp;

    always_ff @(posedge clk) begin
      if(rst)begin
        min_temp <= '1;
        max_temp <= '0;
      end
      if(!rst && min_temp == '1 && max_temp == '0) begin
        min_temp <= num;
        max_temp <= num;
      end
      if(num > max_temp) max_temp <= num;
      if(num < min_temp) min_temp <= num;
    end
    
endmodule
