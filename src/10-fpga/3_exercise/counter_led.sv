module counter_led (
    // inputs
  input  logic [0:0]   btn_i,
  // outputs
  output logic [3:0]   number_o,
  // clock and reset
  input  logic         clk_i,
  input  logic         rst_ni
  
  );

  logic [3:0] number_o_ff;
  logic [3:0] counter;
  assign number_o = number_o_ff;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(~rst_ni) begin
      number_o_ff <= '0;
      counter <= 1;
    end
    else begin
        if(~btn_i) begin
            if(counter == 8) begin
                number_o_ff <= '0;
                counter <= 1;
            end
            else begin
                number_o_ff <= number_o_ff + 1;
                counter <= counter + 1;
            end
        end
    end
  end

endmodule
