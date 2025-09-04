`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2024 08:29:13 AM
// Design Name: 
// Module Name: tb_timeout
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
///default : 9200sec
 
module tb_timeout();

class comp extends uvm_component;
  `uvm_component_utils(comp)
  
 
  function new(string path = "comp", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("comp","Reset Started", UVM_NONE);
     #10;
    `uvm_info("comp","Reset Completed", UVM_NONE);
    phase.drop_objection(this);
  endtask
  
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("mon", " Main Phase Started", UVM_NONE);
    #100;
    `uvm_info("mon", " Main Phase Ended", UVM_NONE);
    phase.drop_objection(this);
  endtask
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
  endfunction
  
  
endclass
 
///////////////////////////////////////////////////////////////////////////
  
  initial begin
 
    uvm_top.set_timeout(200ns, 1);   // set_timeout(run_time, override 0 or 1)  default is 1 which is overridable
    run_test("comp");
  end
  
 
endmodule
