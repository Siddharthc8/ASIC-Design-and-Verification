`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2024 03:05:42 PM
// Design Name: 
// Module Name: tb_convert2string
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


// This method is used to print the variables in a single line


`include "uvm_macros.svh"
import uvm_pkg::*;
 
module tb_convert2string();

class obj extends uvm_object;
  `uvm_object_utils(obj)
  
  function new(string path = "OBJ");
    super.new(path);
  endfunction
  
  bit [3:0] a = 4;
  string b = "UVM";
  real c   = 12.34;
  
  virtual function string convert2string();
    
   string s = super.convert2string();            // Super is decalred in a different fashion. Nothing much just returns a value
    
    s = {s, $sformatf("a : %0d ", a)};           // This concatenates everything to "s"
    s = {s, $sformatf("b : %0s ", b)};
    s = {s, $sformatf("c : %0f ", c)};
                                       // Display layout -->     a : 4 b : UVM c : 12.3400
    return s;
  endfunction
  
  
endclass  
 
//////////////// MAIN MODULE ////////////////////////

  obj o;
  
  initial begin
    o = obj::type_id::create("o");
    //$display("%0s", o.convert2string());      // Can be displayed on to the console using this command as well
    `uvm_info("TB_TOP", $sformatf("%0s", o.convert2string()), UVM_NONE);
  end
 
endmodule
