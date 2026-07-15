module sheffer_stroke_reduce #(
  parameter int COUNT_OF_BITS = 4
  )(
    input logic [COUNT_OF_BITS-1:0] vector,
    input logic clk,
    input logic rst,
    output logic result
  );
    logic stroke_out;
    logic acc;
    logic bit_in;
    logic [COUNT_OF_BITS-1:0] bit_counter;
    logic[COUNT_OF_BITS-1:0] temp_vector;
    assign bit_in = temp_vector[0];
    assign result = acc;

    sheffer_stroke stroke(
      .a(acc),
      .b(bit_in),
      .c_out(stroke_out)
    );

    always_ff @(posedge clk) begin
      if(rst)begin
        acc <= 1'b1;
        temp_vector <= vector;
        bit_counter <= '0;
      end
      else begin
        if(bit_counter < COUNT_OF_BITS) begin
          acc <= stroke_out;
          temp_vector <= temp_vector >> 1;
          bit_counter <= bit_counter + 1'b1;
        end
      end
    end
endmodule
