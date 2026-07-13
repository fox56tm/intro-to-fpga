module float_mult_byte_modified (
    input  logic [31:0] float_in,
    input  byte unsigned uint8_in,
    output byte unsigned uint8_out
);

  logic         sign;
  byte unsigned exponent;
  logic [22:0]  mantissa;

  byte         exp_shift;
  logic [31:0] scaled_mantissa;
  logic [31:0] mantissa_to_uint;
  logic [31:0] uint_extended;
  logic [32:0] fraction_sum;

  always_comb begin

      sign          = float_in[31];
      exponent      = float_in[30:23];
      mantissa      = float_in[22:0];

      if(sign && exponent == 8'd255 && mantissa == 0) // -Inf
        uint8_out = 8'd0;
      else if (!sign && exponent == 8'd255 && mantissa == 0) begin // +Inf
        if(uint8_in > 0) uint8_out = 8'd255;
        else uint8_out = 8'd0;
      end
      else if(exponent == 8'd255 && mantissa != 0) //NaN
        uint8_out = 8'd0;

      else begin
        exp_shift = exponent - 8'd127;

        if ((exp_shift - 23) >= 0)
          scaled_mantissa =
            ((mantissa * uint8_in) << (exp_shift - 23)) +
            (uint8_in << exp_shift);
        else if (exp_shift >= 0) begin
          mantissa_to_uint = mantissa * uint8_in;
          uint_extended = uint8_in;
            scaled_mantissa =
              (mantissa_to_uint >> (-(exp_shift - 23))) +
              (uint_extended << exp_shift);
        end else begin
          mantissa_to_uint = mantissa * uint8_in;
          uint_extended = uint8_in;
          if ((uint_extended << (32 + exp_shift)) == 0)
            fraction_sum  = (mantissa_to_uint << (32 + (exp_shift - 23)));
          else
            fraction_sum =
              (mantissa_to_uint << (32 + (exp_shift - 23))) +
              (uint_extended << (32 + exp_shift));
          scaled_mantissa =
            (mantissa_to_uint >> -(exp_shift - 23)) +
            (uint_extended >> -exp_shift) + fraction_sum[32];
        end

        if (scaled_mantissa > 255) begin
          uint8_out = 8'd255;
        end else if (scaled_mantissa == 0 || sign) begin
          uint8_out = 8'd0;
        end else begin
          uint8_out = scaled_mantissa[7:0];
        end
      end
    end

endmodule
