`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2024 11:41:19 AM
// Design Name: 
// Module Name: tb_severity_changes_of_macros
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
 
 module tb_severity_changes_of_macros();

 
//////////////////////////////////////////////////
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction
 
 
  
  
  task run();
    `uvm_info("DRV", "Informational Message", UVM_NONE);
    `uvm_warning("DRV", "Potential Error");
    `uvm_error("DRV", "Real Error");
     #10;
    `uvm_fatal("DRV", "Simulation cannot continue DRV1");
    #10;
    `uvm_fatal("DRV1", "Simulation Cannot Continue DRV1");
  endtask
  
 
  
endclass
 
//////////////////   MAIN MODULE  ///////////////////////////
 
 
  driver d;
  
  initial begin
    d = new("DRV", null);
   // d.set_report_severity_override(UVM_FATAL, UVM_ERROR);    Fatal -> Error
    d.set_report_severity_id_override(UVM_FATAL, "DRV", UVM_ERROR);  // Fatal to Error only for "DRV" id
    d.run();
  end
  
  
  
endmodule