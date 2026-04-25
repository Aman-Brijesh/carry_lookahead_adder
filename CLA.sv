module CLA #(
    parameter int WIDTH = 4
)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic Cin,
    output logic [WIDTH-1:0] sum,
    output logic Cout,
    output logic Pg,
    output logic Gg
);

logic [WIDTH-1:0] P, G;
logic [WIDTH:0]   C;

assign P = A^B;
assign G = A&B;


assign C[0] = Cin;

assign C[1] = G[0] |
                (P[0]&C[0]);


assign C[2] = G[1] |
            (P[1]&G[0])
            | (P[1]&P[0]&C[0]);


assign C[3] = G[2] | 
            (P[2]&G[1]) |
            (P[2]&P[1]&G[0]) |
            (P[2]&P[1]&P[0]&C[0]);

assign C[4] = G[3] |
            (P[3]&G[2]) |
            (P[3]&P[2]&G[1]) |
            (P[3]&P[2]&P[1]&G[0]) |
            (P[3]&P[2]&P[1]&P[0]&C[0]);


assign Pg = P[3] & P[2] & P[1] & P[0];

assign Gg = G[3]|
            (P[3] & G[2])|
            (P[3] & P[2] & G[1])|
            (P[3] & P[2] & P[1] & G[0]);


assign sum  = P^C[WIDTH-1:0];
assign Cout = C[WIDTH];

endmodule

module CLA16(
    input logic [15:0] A,
    input logic [15:0] B,
    input logic Cin,
    output logic [15:0] Sum,
    output logic Cout,
    output logic Pg,
    output logic Gg
);

logic [3:0] Pg_block,Gg_block; //4 4 Bit blocks
logic [4:0] Cblock;

assign Cblock[0] = Cin;

generate
    for(genvar i=0;i<4;i++) begin
        CLA #(4) block(
            .A(A[i*4 +:4]),
            .B(B[i*4 +: 4]),
            .Cin(Cblock[i]),
            .sum(Sum[i*4 +: 4]),
            .Cout(),
            .Pg(Pg_block[i]),
            .Gg(Gg_block[i])
        );
    end
endgenerate

assign Cblock[1] = Gg_block[0] |
                    (Pg_block[0]&Cblock[0]);

assign Cblock[2] = Gg_block[1] |
                    (Pg_block[1]&Gg_block[0])
                    | (Pg_block[1]&Pg_block[0]&Cblock[0]);

assign Cblock[3] = Gg_block[2] | 
            (Pg_block[2]&Gg_block[1]) |
            (Pg_block[2]&Pg_block[1]&Gg_block[0]) |
            (Pg_block[2]&Pg_block[1]&Pg_block[0]&Cblock[0]);

assign Cblock[4] = Gg_block[3] |
            (Pg_block[3]&Gg_block[2]) |
            (Pg_block[3]&Pg_block[2]&Gg_block[1]) |
            (Pg_block[3]&Pg_block[2]&Pg_block[1]&Gg_block[0]) |
            (Pg_block[3]&Pg_block[2]&Pg_block[1]&Pg_block[0]&Cblock[0]);

assign Cout = Cblock[4];

assign Pg = Pg_block[3]
        & Pg_block[2]
        & Pg_block[1]
        & Pg_block[0];


assign Gg = Gg_block[3]
        | (Pg_block[3] & Gg_block[2])
        | (Pg_block[3] & Pg_block[2] & Gg_block[1])
        | (Pg_block[3] & Pg_block[2] & Pg_block[1] & Gg_block[0]);
 
endmodule

module CLA32(
    input logic [31:0] A,
    input logic [31:0] B,
    input logic Cin,
    output logic [31:0] Sum,
    output logic Cout
);

logic [1:0]Pg,Gg; //2 16 bit blocks
logic [2:0] Cblock;

assign Cblock[0] = Cin;

generate
    for(genvar i=0;i<2;i++) begin
        CLA16 block(
            .A(A[i*16 +:16]),
            .B(B[i*16 +:16]),
            .Cin(Cblock[i]),
            .Sum(Sum[i*16 +:16]),
            .Cout(),
            .Pg(Pg[i]),
            .Gg(Gg[i])
        );
    end
endgenerate

assign Cblock[1] = Gg[0] |
                    (Pg[0]&Cblock[0]);

assign Cblock[2] = Gg[1] |
                    (Pg[1]&Gg[0])
                    | (Pg[1]&Pg[0]&Cblock[0]);

assign Cout = Cblock[2];

endmodule