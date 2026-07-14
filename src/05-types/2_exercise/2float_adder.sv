module float_adder(
  input logic [31:0] float1,
  input logic [31:0] float2,
  output logic [31:0] sum
);
  logic sign1,sign2, sign_sum;
  byte unsigned exponent1, exponent2;
  logic [24:0] frac_sum;
  logic [23:0] mantissa1;
  logic [23:0] mantissa2;
  logic [23:0] mantissa_sum;
  byte unsigned max_exp;
  byte unsigned exp_diff;

  always_comb begin

    sign1 = float1[31];
    exponent1 = float1[30:23];
    mantissa1 = {1'b1, float1[22:0]};

    sign2 = float2[31];
    exponent2 = float2[30:23];
    mantissa2 = {1'b1, float2[22:0]};

    if(exponent1 > exponent2) begin
      exp_diff = exponent1 - exponent2;
      max_exp = exponent1;
    end
    else begin
      exp_diff = exponent2 - exponent1;
      max_exp = exponent2;
    end

    if(exponent1 >= exponent2)
      mantissa2 = mantissa2 >> exp_diff;
    else
      mantissa1 = mantissa1 >> exp_diff;
    
    if(sign1 == sign2) begin
      frac_sum = mantissa1 + mantissa2;
      sign_sum = sign1;
      if(frac_sum[24]) begin
        max_exp = max_exp + 1;
        mantissa_sum = frac_sum[24:1];
      end
      else mantissa_sum = frac_sum[23:0];
    end
    else begin
        if(mantissa1 >= mantissa2) begin
          sign_sum = sign1;
          mantissa_sum = mantissa1 - mantissa2;
        end
        else begin
          sign_sum = sign2;
          mantissa_sum = mantissa2 - mantissa1;
        end
        if (mantissa_sum == 0) begin
          max_exp = '0;
          sign_sum = 1'b0;
        end
        else begin 
          for(int i = 23; i >= 0; i--) begin
            if(mantissa_sum[i] == 1'b1) begin
            mantissa_sum = mantissa_sum << (23-i);
            max_exp = max_exp - (23-i);
            break;
            end
          end
        end
    end

    sum[31] = sign_sum;
    sum[30:23] = max_exp;
    sum[22:0] = mantissa_sum[22:0];

  end
endmodule
