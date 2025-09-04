`timescale 1ns / 1ps



module FA(
    input x,y,cin,
    output cout, sum
    );
    
    wire c1,c2,s1;
    
    HA HA0(
    .x(x),
    .y(y),
    .sum(s1),
    .cout(c1)
    );
    
    HA HA1(
    .x(s1),
    .y(cin),
    .sum(sum),
    .cout(c2)
    );
    
    assign cout = c1 | c2;
    
endmodule
