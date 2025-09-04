`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2024 06:14:29 PM
// Design Name: 
// Module Name: tb_do_print
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

module tb_do_print();
 
class obj extends uvm_object;
  `uvm_object_utils(obj)                   // do_print methods require the class to be registered to the factory
  
  function new(string path = "OBJ");
    super.new(path);
  endfunction
  
  bit [3:0] a = 4;
  string b = "UVM";
  real c   = 12.34;
  
  virtual function void do_print(uvm_printer printer);         // Check the website for the syntax. uvm_printer printer
    super.do_print(printer);                             // Note that we are using "do_print" and not "new"
    
    printer.print_field_int("a", a, $bits(a));    // Use printer.print_field_** to get it printed 
    printer.print_string("b", b);
    printer.print_real("c", c);
    
  endfunction
  
endclass  
  
////////////////////////// MAIN MODULE ///////////////
 
  obj o;
  
  initial begin
    o = obj::type_id::create("o");      // Not necessary to use this type to create a new container. can use new methtod as well
//    o = new("o");
    o.print();                 // calling can be done just like normal print method
  end
 
endmodule
