`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2024 11:33:49 PM
// Design Name: 
// Module Name: tb_verbosity_level_hierarchy
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

module tb_verbosity_level_hierarchy();
 
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction
 
  
  task run();
    `uvm_info("DRV", "Executed Driver Code", UVM_HIGH);
  endtask
  
endclass
///////////////////////////////////////////////////
 
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction
 
  
  task run();
    `uvm_info("MON", "Executed Monitor Code", UVM_HIGH);
  endtask
  
endclass
 
//////////////////////////////////////////////////
 
class env extends uvm_env;
  `uvm_component_utils(env)
  
  driver drv;
  monitor mon;
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction
  
  
  
  task run();
    drv = new("DRV", this);
    mon = new("MON", this);
    drv.run(); 
    mon.run();
  endtask
  
endclass
////////////////////
 
//////////////////////    MAIN MODULE    //////////////////////////////////////  
 
 env e;
  
  
 initial begin
   e  = new("ENV", null);
   e.set_report_verbosity_level(UVM_HIGH);  // Sets verbosity level limit of that particular class but NOT to the handlers inside them
   e.set_report_verbosity_level_hier(UVM_HIGH);  // Sets the verbosity level limit for Env to be HIGH and for all the handlers in them as well
   e.run(); 
  end
  
  
endmodule
