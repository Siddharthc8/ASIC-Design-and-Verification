`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2025 01:46:37 AM
// Design Name: 
// Module Name: tb_constructor_for_extending_class
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


module tb_constructor_for_extending_class();

class frame;

 logic[4:0]addr;
 logic[7:0]payload;
 bit parity;
 static int frmcount;
 
 function new(input int add, dat);
     addr = add;
     payload = dat;
     genpar();
 endfunction
 
 endclass
 
 
 class goodtagframe extends frame;
    
    int tag;
    
 function new(input int add, dat);
     super.new(add,dat);     // Here the the previous base class's constructor arguments have to be declared so it can be passed up the ladder when child class object is created
     frmcount++;         // Static variable is incremented to count number of objects created
     tag = frmcount;
 endfunction
 
 endclass
 
endmodule
