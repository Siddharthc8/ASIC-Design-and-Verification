`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2024 01:21:40 PM
// Design Name: 
// Module Name: tb_compare
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



`include "uvm_macros.svh"
import uvm_pkg::*;
 
module tb_compare();

 
class first extends uvm_object; 
  
  rand bit [3:0] data;
  
  function new(string path = "first");
    super.new(path);
  endfunction 
  
  `uvm_object_utils_begin(first)
  `uvm_field_int(data, UVM_DEFAULT);
  `uvm_object_utils_end
  
endclass
 
 
////////////////////////////////////////////
 
 
  first f1,f2;
  int status = 0;
  
   initial begin
     f1 = new("f1");
     f2 = new("f2");
     f1.randomize();
     f2.copy(f1);
     f1.print();
     f2.print();
     
     status = f1.compare(f2);
     $display("Value of status : %0d", status);
     
     
   end
 
  
  
endmodule