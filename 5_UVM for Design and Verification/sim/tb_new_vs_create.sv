`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2024 01:39:35 PM
// Design Name: 
// Module Name: tb_new_vs_create
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


// Assume a situation where you wanna add some more variables to Transaction class and replace all the occurance of Transaction handlers to a new one
// This can be done when create method was used and the following method is used

`include "uvm_macros.svh"
import uvm_pkg::*;
 
module tb_new_vs_create();

class first extends uvm_object;          // Assume this is the original Transaction class
  
  rand bit [3:0] data;
  
  function new(string path = "first");
    super.new(path);
  endfunction 
  
  `uvm_object_utils_begin(first)
  `uvm_field_int(data, UVM_DEFAULT);
  `uvm_object_utils_end
  
endclass
/////////////////////////////////////

class first_mod extends first;         // Extend the original class Assume this to be the modified Transaction class where the extra variable is decalred
  rand bit ack;
  
  function new(string path = "first_mod");
    super.new(path);
  endfunction 
  
  `uvm_object_utils_begin(first_mod)
  `uvm_field_int(ack, UVM_DEFAULT);
  `uvm_object_utils_end
  
  
endclass
 
 
 
////////////////////////////////////////////
 
class comp extends uvm_component;
  `uvm_component_utils(comp)     // Component is not using 
  
  first f;
  
  function new(string path = "second", uvm_component parent = null);
    super.new(path, parent);
    f = first::type_id::create("f");           
    f.randomize();
    f.print();     // Print method prints out all the varibales in the begin_end window
  endfunction 
  
  
endclass
 
 
///////////////////// MAIN MODULE ///////////////////////
 
 
  comp c;
  
  // In order to use the override method the component class should be registered to a factory and also must be created using the create method
  
  initial begin
    c.set_type_override_by_type(first::get_type, first_mod::get_type);   // Override the old handler with the new one 
    c = comp::type_id::create("c", null); 
    c = new("c", null);
  end
 
  
endmodule
