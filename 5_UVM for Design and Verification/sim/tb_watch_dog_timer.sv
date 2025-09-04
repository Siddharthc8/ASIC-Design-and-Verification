`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2025 10:37:44 PM
// Design Name: 
// Module Name: tb_watch_dog_timer
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

module tb_watch_dog_timer();

class watchdog_timer extends uvm_component;
  `uvm_component_utils(watchdog_timer)

  time timeout_ns;       // User-defined timeout
  bit   enabled = 1;     // Enable/disable watchdog
  event heartbeat;       // Event to reset timer

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    fork
      // Thread 1: Monitor timeout
      begin
        while (enabled) begin
          #timeout_ns;  // Wait for timeout period
          `uvm_fatal("WATCHDOG", $sformatf("Simulation timeout after %0t ns", timeout_ns))
        end
      end

      // Thread 2: Reset timer on heartbeat
      begin
        forever begin
          @heartbeat;  // Reset timer when triggered
          disable fork; // Cancel pending timeout
        end
      end
    join
  endtask
endclass


class my_driver extends uvm_driver;
`uvm_component_utils(my_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);
      if (vif.data_valid) -> watchdog.heartbeat;
    end
  endtask
endclass

class my_monitor extends uvm_monitor;
`uvm_component_utils(my_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);
      if (vif.packet_done) -> watchdog.heartbeat;
    end
  endtask
endclass



class my_test extends uvm_test;
  watchdog_timer watchdog;
    
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    watchdog = watchdog_timer::type_id::create("watchdog", this);
    watchdog.timeout_ns = 100_000; // 100µs timeout
  endfunction
endclass


//   // Adjust timeout during test
//watchdog.enabled = 0;  // Disable
//watchdog.timeout_ns = 200_000; // New timeout
//watchdog.enabled = 1;  // Re-enable


endmodule
