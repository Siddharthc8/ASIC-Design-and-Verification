`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2024 06:41:42 PM
// Design Name: 
// Module Name: tb_do_compare
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

module tb_do_compare();
 
class obj extends uvm_object;
  `uvm_object_utils(obj)
  
  function new(string path = "obj");
    super.new(path);
  endfunction
  
  rand bit [3:0] a;
  rand bit [4:0] b;
   
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field_int("a :", a, $bits(a), UVM_DEC);
    printer.print_field_int("b :", b, $bits(b), UVM_DEC);
  endfunction
  
  
  virtual function void do_copy(uvm_object rhs);     // Should match the template
    obj temp;
    $cast(temp, rhs);            // Aotomatically creates a handle for "rhs"
    super.do_copy(rhs);                            // Should match the template
    
     this.a = temp.a;
     this.b = temp.b;
 
  endfunction
  
  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);   // uvm_comparer is extra that you have to keep in mind
    obj temp;
    int status;
    $cast(temp, rhs);
    status = super.do_compare(rhs, comparer) && (a == temp.a) && (b == temp.b);
    return status;
    
  endfunction
 
  
endclass  
 
 //////////////// MAIN MODULE ////////////////////////
 
  obj o1,o2;
  int status;
  
  initial begin
    o1 = obj::type_id::create("o1");
    o2 = obj::type_id::create("o2");
    
    
    o1.randomize();
    o1.print();
//    o2.copy(o1);
    status = o2.comapre(o1);
    `uvm_info("tb_top", $sformatf("%0d", status),UVM_NONE);
   
  end
 
endmodule
