`timescale 1ns / 1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_verbosity_level_hierarchy();

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
 
  task run_phase(uvm_phase phase);
    `uvm_info("DRV", "Executed Driver Code", UVM_HIGH);
  endtask
endclass

///////////////////////////////////////////////////

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
 
  task run_phase(uvm_phase phase);
    `uvm_info("MON", "Executed Monitor Code", UVM_HIGH);
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
    uvm_top.set_report_verbosity_level(UVM_HIGH);
    
    e = env::type_id::create("ENV", this);
    
    // Try different verbosity settings:
    // OPTION 1: Set env to HIGH, children inherit
    e.set_report_verbosity_level(UVM_HIGH);
    
    // OPTION 2: Set env and all children to HIGH  
    // e.set_report_verbosity_level_hier(UVM_HIGH);
    
    // OPTION 3: Set only env to NONE, children inherit
    // e.set_report_verbosity_level(UVM_NONE);
    
    // OPTION 4: Set env and all children to NONE
    // e.set_report_verbosity_level_hier(UVM_NONE);
  endfunction
endclass

//////////////////////    MAIN MODULE    //////////////////////////////////////  

initial begin
  // Simply start the test - no config_db needed for basic verbosity
  run_test("test");
end

endmodule
