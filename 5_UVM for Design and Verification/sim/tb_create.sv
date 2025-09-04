`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2024 01:32:16 PM
// Design Name: 
// Module Name: tb_create
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


// Recommended method to create an object as it allows overriding during certain cases and allows easy merging between classes

`include "uvm_macros.svh"
import uvm_pkg::*;
 
module tb_create();

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
 
  
   initial begin
     f1 = first::type_id::create("f1");          // Type::type_id::create("tag")    Note: Tag will be used in the tree
     f2 = first::type_id::create("f2");
     
     f1.randomize();
     f2.randomize();
     
     f1.print();
     f2.print(); 
     
     
   end
 
endmodule
