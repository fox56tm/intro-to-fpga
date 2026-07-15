module sheffer_stroke_reduce_fv #(
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

    sheffer_stroke stroke (
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
    
    `ifdef FORMAL
      logic past_valid = 1'b0;
      always_ff @(posedge clk) begin
        past_valid <= 1'b1;
      end
      
      initial begin
        assume(rst);
      end

      always @(posedge clk) begin
        if (past_valid && $past(rst)) begin
          assert (acc == '1 && temp_vector == $past(vector) && bit_counter =='0);
        end
      end

      always @(posedge clk) begin
        if (past_valid && !rst && !$past(rst)) begin
          cover (!rst && bit_counter >= COUNT_OF_BITS);
        end
      end
    `endif

endmodule
