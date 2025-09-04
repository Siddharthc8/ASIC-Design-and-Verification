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
 
module tb_verbosity_level_and_id();
 
class driver extends uvm_driver;
  `uvm_component_utils(driver)           // Report the class to factory
  
  function new(string path , uvm_component parent);       // Syntax should include string path and uvm_component parent
    super.new(path, parent);                        // Syntax should include path, parent
  endfunction
 
  
  task run();
    `uvm_info("DRV1", "Executed Driver1 Code", UVM_HIGH);   // UVM_INFO syntax   Tag, Message, Verbsoity Level
    `uvm_info("DRV2", "Executed Driver2 Code", UVM_HIGH);
  endtask
  
endclass

////////////////////////////////////////////////////////////////
class env extends uvm_env;
  `uvm_component_utils(env)
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction
  
  
  task run();
    `uvm_info("ENV1", "Executed ENV1 Code", UVM_HIGH);
    `uvm_info("ENV2", "Executed ENV2 Code", UVM_HIGH);
  endtask
  
endclass
 
 /////////////  MAIN MODULE ////////////////// 
  
  initial begin
    uvm_top.set_report_verbosity_level(UVM_HIGH);     // uvm_top is used to set the verbosity of the entire environment
    $display("Default Verbosity level : %0d ", uvm_top.get_report_verbosity_level);  // uvm_top is used to check the verbosity of the entire environment
    `uvm_info("TB_TOP", "String", UVM_HIGH);
  
  end
  
  
  driver drv;
  env e;
 initial begin
   drv = new("DRV", null);             // Syntax should contain calss name and parent
   e   = new("ENV", null);
   e.set_report_verbosity_level(UVM_HIGH);
   drv.set_report_id_verbosity("DRV1",UVM_HIGH);  // Setting verbosity to only that particular ID "DRV1"
   drv.run();
   e.run();
    
  end
  
endmodule
