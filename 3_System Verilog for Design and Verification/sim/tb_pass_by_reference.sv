`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 11:13:00 PM
// Design Name: 
// Module Name: tb_pass_by_reference
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


module tb_pass_by_reference();
    
    //   automatic and ref are generally used for arrays
    
    function automatic bit [1:0] swapp(ref bit [1:0] a, b);      // Output data type and size is mentioned infront of the function name
        bit [1:0] temp;
        temp = a;
        a = b;
        b = temp;     
        
        $display("Value in task a: %0d, b: %0d", a, b);  
    endfunction
    
    function automatic bit [1:0] swappp(const ref bit [1:0] a, b);      // const is used which does not allow the variable to be changed throughtout the function's scope
        bit [1:0] temp;
        temp = a;
        //a = b;                      // This line will throw an error as "a" and "b" are decalred using const 
        //b = temp;     
        
        $display("Value in task a: %0d, b: %0d", a, b);  
    endfunction
                                                 
    task automatic swap(ref bit [1:0] a, b);     // Direction need not be mentioned explicitly
        bit [1:0] temp;                      // "automatic" creates a copy of the local veribles passed. Allows sharing without interference
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
