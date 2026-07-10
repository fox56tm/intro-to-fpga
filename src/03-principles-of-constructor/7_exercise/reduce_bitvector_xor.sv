module reduce_bitvector_xor #(
    parameter int N = 4
    )(
        input logic [N - 1 : 0] vector,
        output logic res
    );
        logic [N - 2 : 0] temp;

        assign temp[0] = vector[0] ^ vector[1];
        genvar i;
        generate
            for(i = 1; i < N - 1; i++)
                assign temp[i] = temp[i-1] ^ vector[i+1];
        endgenerate

        assign res = temp[N - 2];
endmodule
