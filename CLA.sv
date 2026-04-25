module CLA #(
    parameter int WIDTH = 32
)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic Cin,
    output logic [WIDTH-1:0] sum,
    output logic Cout,
    output logic V
);

logic [WIDTH-1:0] P, G;
logic [WIDTH:0]   C;

integer i;


always @(*) begin

    P = A ^ B;
    G = A & B;

    C[0] = Cin;

    for (i = 0; i < WIDTH; i = i + 1) begin
        C[i+1] = G[i] | (P[i] & C[i]);
    end

    sum  = P ^ C[WIDTH-1:0];
    Cout = C[WIDTH];
    V    = C[WIDTH] ^ C[WIDTH-1];

end

endmodule