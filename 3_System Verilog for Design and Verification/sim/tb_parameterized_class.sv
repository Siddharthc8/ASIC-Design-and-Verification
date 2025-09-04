`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2025 02:21:47 AM
// Design Name: 
// Module Name: tb_parameterized_class
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


module tb_parameterized_class();

     class stack #(parameter type sign = int);    // It is basically like saying sign can be used for data_type where default is int but can be changed while creating a new object
     
     local sign data[100];    // Use "sign" as that was decalred could be anything we specify
     static int depth;
     
     task push(input sign indat);   // can also be used int asks and functions
     endtask
     
     task pop(output sign outdat);
     endtask
     
     endclass
     
     // int stack (default)
     stack intstack = new();   // No arguments so default is "int"
     
     // 8-bit vector stack
     stack #(logic[7:0]) bytestack = new();   // Mentioning a byte type in the argument

endmodule
