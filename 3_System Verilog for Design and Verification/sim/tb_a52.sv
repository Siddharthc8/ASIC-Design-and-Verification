`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 03:19:20 PM
// Design Name: 
// Module Name: tb_a52
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


module tb_a52();
// Create a function that will perform the multiplication of the two unsigned integer variables. 
// Compare values return by function with the expected result and if both values match send "Test Passed" to Console else send "Test Failed".
        
    function int unsigned mult(input int unsigned a=0,b=0);
        return a*b;
    endfunction
    
    function longint mult2(input int unsigned c=0,d=0);
        return c*d;
    endfunction
    
    int unsigned res1 = 0;
    longint res2 = 0;
    int unsigned a = 25;
    int unsigned b = 20;
    int unsigned c = 25;
    int unsigned d = 20;
    
    // Please ignore the extra work
    initial begin
        #1;
        res1 = mult(a,b);
        res2 = mult2(c,d);
        if(res1  == 500) $display("Test Passed");
        else $display("Test Failed");
        
        $display("Result variable same size: %0d", res1);
        $display("Result variable twice as big size: %0d", res2);
        
        if(res2  == 500) $display("Test Passed");
        else $display("Test Failed");
        #5 $finish;
    end
    

endmodule
