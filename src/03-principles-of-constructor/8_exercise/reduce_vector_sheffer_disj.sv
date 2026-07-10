module reduce_vector_sheffer_or #(
    parameter int N = 4
  )(
    input logic [N - 1 : 0] vector,
    output logic res
    );
    logic [N - 2 : 0] temp;
    sheffer_stroke_disj disj_first(
        .a(vector[0]),
        .b(vector[1]),
        .c_out(temp[0])
    );
    genvar i;
    generate
      for(i = 1; i < N-1; i++)
        sheffer_stroke_disj disj(
        .a(temp[i-1]),
        .b(vector[i+1]),
        .c_out(temp[i])
        );
    endgenerate
    assign res = temp[N - 2];
endmodule
