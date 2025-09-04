`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2024 07:39:29 AM
// Design Name: 
// Module Name: tb_objections
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
 
module tb_objections();

class comp extends uvm_component;
  `uvm_component_utils(comp)
  
 
  function new(string path = "comp", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);                    // See how phase is used and not "super"
    `uvm_info("comp","Reset Started", UVM_NONE);   
     #10;
    `uvm_info("comp","Reset Completed", UVM_NONE);  
    phase.drop_objection(this);                     // To hold the simulation until we are done
  endtask
  
  
endclass
 
///////////////////////////////////////////////////////////////////////////
  
  initial begin
    run_test("comp");
  end
  
 
endmodule