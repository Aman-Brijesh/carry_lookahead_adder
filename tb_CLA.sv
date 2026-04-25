`timescale 1ns/1ps

module tb_CLA;

parameter int WIDTH = 32;

logic [WIDTH-1:0] A;
logic [WIDTH-1:0] B;
logic Cin;

logic [WIDTH-1:0] sum;
logic Cout;
logic V;

CLA #(.WIDTH(WIDTH)) dut (
    .A(A),
    .B(B),
    .Cin(Cin),
    .sum(sum),
    .Cout(Cout),
    .V(V)
);

function logic [31:0] adder_model(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic cin
);
    return a+b+cin;
    
endfunction

task add_test(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic cin
);
    logic [31:0] expected;
    A = a;
    B = b;
    Cin = cin;
    
    expected = adder_model(a,b,cin);

    #1

    if(sum != expected)
        $fatal(0, "FAIL:  A=%0d B = %0d Cin = %0d Expected = %0d Computed Sum = %0d",a,b,cin,expected,sum);
    else
        $display("PASS:  A = %0d B = %0d Sum = %0d",a,b,sum);

endtask

initial begin
    for(int i=0;i<1000;i++) begin
        logic [31:0] a;
        logic [31:0] b;
        logic cin;

        a = $urandom;
        b = $urandom;
        cin = $urandom;
        
        add_test(a,b,cin);
    end

    $display("ALL TESTS COMPLETED!");
    $finish;
end

endmodule