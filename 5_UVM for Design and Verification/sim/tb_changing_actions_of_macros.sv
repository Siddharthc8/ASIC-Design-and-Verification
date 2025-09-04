`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2024 11:44:52 AM
// Design Name: 
// Module Name: tb_changing_actions_of_macros
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
 
module tb_changing_actions_of_macros();

//////////////////////////////////////////////////
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction
 
 
  
  
  task run();
    `uvm_info("DRV", "Informational Message", UVM_NONE);
    `uvm_warning("DRV", "Potential Error");
    `uvm_error("DRV", "Real Error"); ///uvm_count
    `uvm_error("DRV", "Second Real Error");
    /*
     #10;
    `uvm_fatal("DRV", "Simulation cannot continue DRV1"); /// uvm_exit
    #10;
    `uvm_fatal("DRV1", "Simulation Cannot Continue DRV1");
   */
  endtask
  
 
  
endclass
 
/////////////////////////////////////////////
 
 /*
        UVM_NO_ACTION - no action 
        UVM_DISPLAY - displays on the console 
        UVM_LOG - Reprts to the file for the severity,ID pair
        UVM_COUNT - Counts the number of occurance
        UVM_EXIT - Terminates the simulation
        UVM_CALL_HOOK - Callback to report hook mathods
        UVM_STOP - #stops and puts the simulaton in interactive mode 
        UVM_RM_RECORD - Sends the reprt to the recorder
 */
  driver d;
  
  initial begin
    d = new("DRV", null);
    d.set_report_severity_action(UVM_INFO, UVM_NO_ACTION); // Whenever there's more than 3 Errors the code is terminated
    d.set_report_severity_action(UVM_INFO, UVM_DISPLAY | UVM_EXIT); // To add multiple actions
    d.run();
  end
  
  
  
endmodule
