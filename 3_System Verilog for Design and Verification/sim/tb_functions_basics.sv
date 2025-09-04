`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 03:01:35 PM
// Design Name: 
// Module Name: tb_functions_basics
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


module tb_functions_basics();

    //   function add(input bit [3:0] a,b);  // Simple Function representation
    function bit [4:0] add(input bit [3:0] a=4'b0000, b=4'b0000);        // "bit [4:0]" is the return type and size  // Default values in case an empty function is called
        return a+b;
    endfunction
    
    function disp(input bit [3:0] a=4'b0000, b=4'b0000);
        $display("A: %0d, B: %0d", a,b);    
    endfunction
    
    bit [4:0] res;
    bit [3:0] in1 = 4'b0100;
    bit [3:0] in2 = 4'b0010;
    
    initial begin
        res = add(in1,in2);
        disp(in1,in2);
        $display("Addition result: %0d", res); 
    end
endmodule
