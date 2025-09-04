`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2024 01:05:03 PM
// Design Name: 
// Module Name: tb_copy_clone_1
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
 
module tb_copy_clone_1(); 

class first extends uvm_object; 
  
  rand bit [3:0] data;
  
  function new(string path = "first");
    super.new(path);
  endfunction 
  
  `uvm_object_utils_begin(first)
  `uvm_field_int(data, UVM_DEFAULT);
  `uvm_object_utils_end
  
endclass
 
///////////////////// MAIN MODULE ///////////////////////
 
 first f;
 first s;
 /////////////// COPY METHOD
 
 /* 
  initial begin
    f = new("first");
    s = new("second");
    f.randomize();
    s.copy(f);
    f.print();
    s.print();
  
  end  
*/

//////////////////////////// CLONE METHOD

  initial begin
    f = new("first");
    f.randomize();
    $cast(s, f.clone());      // $cast is used to match the output object type as they may be returned from different objects 
    f.print();
    s.print();
  end
  
endmodule