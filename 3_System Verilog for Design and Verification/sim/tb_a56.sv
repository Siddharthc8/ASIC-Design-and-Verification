`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 04:12:27 PM
// Design Name: 
// Module Name: tb_a56
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


module tb_a56();
// Assume class consists of three data members a, b, and c each of size 4-bit. 
// Create a task inside the class that returns the result of the addition of data members. 
// The task must also be capable of sending the value of a, b, c, and result to the console. 
// Verify code for a = 1, b = 2, and c = 4.

    class Gen;
        
        bit [3:0] a;
        bit [3:0] b;
        bit [3:0] c;
        
        function new(input [3:0] a=0, b=0, c=0);
            this.a = a;
            this.b = b;
            this.c = c;
        endfunction
        
        task add();
            bit [5:0] res = a + b + c;
            $display("Result : %0d = %0d + %0d + %0d", res, a, b, c);
        endtask

    endclass
    
    Gen z;
    
    bit [5:0] res;
        
    initial begin 
        z = new(1,2,4);   // Assigning the data members their values
        z.add();
    end

endmodule
