`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2024 01:00:29 AM
// Design Name: 
// Module Name: tb_field_macro_object
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
 
module tb_field_macro_object();

class parent extends uvm_object;
  
  function new(string path = "parent");
    super.new(path);
  endfunction 
  
  rand bit [3:0] data;
  
  `uvm_object_utils_begin(parent)
  `uvm_field_int(data,UVM_DEFAULT);
  `uvm_object_utils_end
  
  
endclass
 
class child extends uvm_object;
  
   parent p;
  
  function new(string path = "child");
    super.new(path);
    p = new("parent");
  endfunction 
  
  `uvm_object_utils_begin(child)
  `uvm_field_object(p,UVM_DEFAULT);    // To use the FIELD MACROS on an object(class handler) use this command
  `uvm_object_utils_end
  
endclass
 
//////////////////   MAIN MODULE ////////////////////
 
  child c;
  
  initial begin
    c = new("child");
    c.p.randomize();      // randomizing the parent class with its handler
    c.print();
  end
  
endmodule