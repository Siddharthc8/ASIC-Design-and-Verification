`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2024 01:20:19 AM
// Design Name: 
// Module Name: tb_adder_subtractor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_adder_subtractor();
    parameter n=4;
    reg [n-1:0] x,y;
    reg add_n;
    wire [n-1:0] sum;
    wire overflow, cout;
    
    adder_subtractor #(.n(n)) uut(
        
        .x(x),
        .y(y),
        .add_n(add_n),
        .sum(sum),
        .cout(cout),
        .overflow(overflow)   
    );
     
     initial 
     begin
     #40 $finish;
     end
     
     initial
     begin
     add_n = 1'b0;
     x = 4'd5;
     y = 4'd6;
     #10;
     add_n = 1'b1;
     x = 4'd10;
     y = 4'd5;
     #10;
     add_n = 1'b0;
     x = 4'd3;
     y = 4'd3;
     #10;
     add_n = 1'b1;
     x = 4'd15;
     y = 4'd15;
    end
    
    initial begin
        $monitor ("time=%3d, x=%d \t y=%d \t add_n=%1d \t result = %3d \t cout= %1d \t overflow=%1b",    
        $time, x,y,add_n,sum,cout,overflow);
    end
endmodule


























