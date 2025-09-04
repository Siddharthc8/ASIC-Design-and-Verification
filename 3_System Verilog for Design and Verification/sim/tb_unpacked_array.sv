`timescale 1ns / 1ps




module tb_unpacked_array();   // Not synthesizable
    
    int inta [2:0] [1:0];   //   3x2 array
    int intb [1:3] [2:1];   // Also a 3x2 array 
    int intc [15:0] [0:255];
    
    initial begin
    inta = intb;   // Since they are equal dimensions we can asswign one to another
    end
    
endmodule 