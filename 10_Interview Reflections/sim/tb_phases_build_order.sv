`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2025 06:40:44 PM
// Design Name: 
// Module Name: tb_phases_build_order.
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


module tb_phases_build_order();


`include "uvm_macros.svh"
import uvm_pkg::*;

// Agent class
class my_agent extends uvm_agent;
  `uvm_component_utils(my_agent)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGENT", "build_phase executed", UVM_LOW)
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT", "connect_phase executed", UVM_LOW)
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("AGENT", "end_of_elaboration_phase executed", UVM_LOW)
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("AGENT", "start_of_simulation_phase executed", UVM_LOW)
  endfunction
  
  task run_phase(uvm_phase phase);
    `uvm_info("AGENT", "run_phase executed", UVM_LOW)
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info("AGENT", "extract_phase executed", UVM_LOW)
  endfunction
  
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info("AGENT", "check_phase executed", UVM_LOW)
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("AGENT", "report_phase executed", UVM_LOW)
  endfunction
  
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info("AGENT", "final_phase executed", UVM_LOW)
  endfunction
endclass

// Environment class
class my_env extends uvm_env;
  `uvm_component_utils(my_env)
  my_agent agent;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV", "build_phase executed", UVM_LOW)
    agent = my_agent::type_id::create("agent", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("ENV", "connect_phase executed", UVM_LOW)
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("ENV", "end_of_elaboration_phase executed", UVM_LOW)
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("ENV", "start_of_simulation_phase executed", UVM_LOW)
  endfunction
  
  task run_phase(uvm_phase phase);
    `uvm_info("ENV", "run_phase executed", UVM_LOW)
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info("ENV", "extract_phase executed", UVM_LOW)
  endfunction
  
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info("ENV", "check_phase executed", UVM_LOW)
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("ENV", "report_phase executed", UVM_LOW)
  endfunction
  
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info("ENV", "final_phase executed", UVM_LOW)
  endfunction
endclass

// Test class
class my_test extends uvm_test;
  `uvm_component_utils(my_test)
  my_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST", "build_phase executed", UVM_LOW)
    env = my_env::type_id::create("env", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST", "connect_phase executed", UVM_LOW)
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("TEST", "end_of_elaboration_phase executed", UVM_LOW)
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("TEST", "start_of_simulation_phase executed", UVM_LOW)
  endfunction
  
  task run_phase(uvm_phase phase);
    `uvm_info("TEST", "run_phase executed", UVM_LOW)
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info("TEST", "extract_phase executed", UVM_LOW)
  endfunction
  
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info("TEST", "check_phase executed", UVM_LOW)
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("TEST", "report_phase executed", UVM_LOW)
  endfunction
  
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info("TEST", "final_phase executed", UVM_LOW)
  endfunction
endclass

// Top-level module
  initial begin
    run_test("my_test");
  end

endmodule
