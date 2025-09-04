`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 11:06:34 PM
// Design Name: 
// Module Name: tb_pass_by_value
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


module tb_pass_by_value();

    task swap(input bit [1:0] a, b);
        bit [1:0] temp;
        temp = a;
        a = b;
        b = temp;     
        
        $display("Value in task a: %0d, b: %0d", a, b);  
    endtask
    
    bit [1:0] a;
    bit [1:0] b;
    
    initial begin
        a = 1;
        b = 2;
        swap(a,b);
        $display("Value after task a: %0d, b: %0d", a, b); 
    end

endmodule
