`timescale 1ns / 1ps


module RCA_4bit(
    input [3:0] x,y,
    input cin,
    output [3:0] sum,
    output cout
    );
    
    wire [3:1] c;
    
    FA FA0(
    
        .x(x[0]),
        .y(y[0]),
        .cin(cin),
        .cout(c[1]),
        .sum(sum[0])     
    );
    
    FA FA1(
    
        .x(x[1]),
        .y(y[1]),
        .cin(c[1]),
        .cout(c[2]),
        .sum(sum[1])     
    );
    
    FA FA2(
    
        .x(x[2]),
        .y(y[2]),
        .cin(c[2]),
        .cout(c[3]),
        .sum(sum[2])     
    );
    
    FA FA3(
    
        .x(x[3]),
        .y(y[3]),
        .cin(c[3]),
        .cout(cout),
        .sum(sum[3])     
    );
    
    
endmodule
