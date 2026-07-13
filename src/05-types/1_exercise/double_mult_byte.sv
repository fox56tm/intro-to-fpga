module double_mult_byte (
  input byte unsigned int8_in,
  input logic [63:0] double_in,
  output byte unsigned int8_out
);
  
  logic [10:0] exponent;
  logic sign;
  logic [51:0] mantissa;

  shortint exp_shift;
  logic [63:0] scaled_mantissa;
  logic [64:0] frac_sum;
  logic [63:0] mantissa_to_uint;
  logic [63:0] uint_extended;

  always_comb begin
    
    sign = double_in[63];
    exponent = double_in[62:52];
    mantissa = double_in[51:0];
    exp_shift = exponent - 11'd1023;
    
    mantissa_to_uint = mantissa * int8_in;
    uint_extended = int8_in;

    if(exp_shift >= 52)
      scaled_mantissa = ((mantissa_to_uint) << (exp_shift - 52)) + (uint_extended << exp_shift);
    else if (exp_shift >= 0)
      scaled_mantissa = ((mantissa_to_uint) >> (-(exp_shift - 52))) + (uint_extended << exp_shift);
    else begin 
        if(uint_extended << (64 + exp_shift) == 0)
          frac_sum = mantissa_to_uint << ( 64 + (exp_shift - 52));
        else 
          frac_sum = (mantissa_to_uint << (64 + (exp_shift - 52)))+ (uint_extended << (64 + exp_shift));
        scaled_mantissa = ((mantissa_to_uint) >> -(exp_shift - 52)) + (uint_extended >> -exp_shift) + frac_sum[64];
    end

    if(scaled_mantissa > 255)
      int8_out =  8'd255;
    else if (scaled_mantissa == 0 || sign)
      int8_out = 8'd0;
    else int8_out = scaled_mantissa[7:0];

  end

endmodule
