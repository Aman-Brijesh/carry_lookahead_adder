`timescale 1ns/1ps

module tb_CLA;

parameter int WIDTH = 32;

logic [WIDTH-1:0] A;
logic [WIDTH-1:0] B;
logic Cin;

logic [WIDTH-1:0] sum;
logic Cout;

int test_count = 0;

CLA32 dut (
    .A(A),
    .B(B),
    .Cin(Cin),
    .Sum(sum),
    .Cout(Cout)
);

function logic [WIDTH:0] adder_model(
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    input logic cin
);
    return a+b+cin;
    
endfunction

task add_test(
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    input logic cin
);

    logic [WIDTH:0] expected;
    logic [WIDTH:0] actual;

    test_count++;


    A = a;
    B = b;
    Cin = cin;
    
    expected = adder_model(a,b,cin);

    #1;

    actual = {Cout,sum};

    if(actual !== expected)
        $fatal(0, "FAIL:  A=%0d B = %0d Cin = %0d Expected = %0d Computed Sum = %0d",a,b,cin,expected,actual);
    else
        $display("PASS:  A = %0d B = %0d Sum = %0d",a,b,sum);

endtask

initial begin
    add_test(0,0,0);

    add_test('1,0,0);

    add_test('1,1,0);

    add_test('1,1,1);

    add_test(0,0,1);

    for(int i=0;i<1000;i++) begin
        logic [WIDTH-1:0] a;
        logic [WIDTH-1:0] b;
        logic cin;

        a = $urandom;
        b = $urandom;
        cin = $urandom_range(1,0);
        
        add_test(a,b,cin);
    end

    $display("ALL TESTS COMPLETED!, total test count: %d",test_count);
    $finish;
end

endmodule