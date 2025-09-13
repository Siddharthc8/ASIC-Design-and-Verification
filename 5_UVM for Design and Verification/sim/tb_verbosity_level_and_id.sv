`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2024 11:13:07 PM
// Design Name: 
// Module Name: tb_verbosity_level_and_id
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
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
 
  task run_phase(uvm_phase phase);
    `uvm_info("DRV", "Executed Driver Code NONE", UVM_NONE);
    `uvm_info("DRV", "Executed Driver Code LOW", UVM_LOW);
    `uvm_info("DRV", "Executed Driver Code MED", UVM_MEDIUM);
    `uvm_info("DRV", "Executed Driver Code HIGH", UVM_HIGH);
  endtask
endclass

///////////////////////////////////////////////////

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
 
  task run_phase(uvm_phase phase);
    `uvm_info("MON", "Executed Monitor Code NONE", UVM_NONE);
    `uvm_info("MON", "Executed Monitor Code LOW", UVM_LOW);
    `uvm_info("MON", "Executed Monitor Code MED", UVM_MEDIUM);
    `uvm_info("MON", "Executed Monitor Code HIGH", UVM_HIGH);
  endtask
endclass

//////////////////////////////////////////////////

class env extends uvm_env;
  `uvm_component_utils(env)
  
  driver drv;
  monitor mon;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = driver::type_id::create("DRV", this);
    mon = monitor::type_id::create("MON", this);
    
    // Set only the driver to UVM_DEBUG after creation
//     drv.set_report_verbosity_level(UVM_DEBUG);
    // mon keeps default verbosity level
  endfunction
  
  task run_phase(uvm_phase phase);
    // Components run automatically - no need to call manually
    `uvm_info("ENV", "Environment run_phase started", UVM_HIGH);
  endtask
endclass

////////////////////

class test extends uvm_test;
  `uvm_component_utils(test)
  
  env e;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Set verbosity levels BEFORE creating components
//     uvm_top.set_report_verbosity_level(UVM_LOW);
    
    e = env::type_id::create("ENV", this);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    
    // This says report only whatever is the set value or less from that object
    
//     e.drv.set_report_verbosity_level(UVM_LOW);
    e.drv.set_report_id_verbosity("DRV", UVM_MEDIUM);
    
    // Monitor keeps default verbosity
    
//     e.mon.set_report_verbosity_level(UVM_LOW); 
    e.mon.set_report_id_verbosity("MON", UVM_MEDIUM);
  endfunction
endclass

//////////////////////    MAIN MODULE    //////////////////////////////////////  

initial begin
  run_test("test");
end

endmodule
