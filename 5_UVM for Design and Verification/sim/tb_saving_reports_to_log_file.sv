`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2024 12:01:59 PM
// Design Name: 
// Module Name: tb_saving_reports_to_log_file
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
 
 
module tb_saving_reports_to_log_file();

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
    `uvm_error("DRV", "Second Real Error");
  endtask
  
 
  
endclass
 
////////////////////   MAIN MODULE    /////////////////////////
 
  driver d;
  int file;          // Decalre the file as int
  
  initial begin
    file = $fopen("log.txt", "w");    // Opent he file for usage
    d = new("DRV", null);
    d.set_report_default_file(file);     // To send all the reports to the file
    d.set_report_severity_file(UVM_ERROR, file); // To send only the reports of that ID to the file
    
    
//////////////   Changing the action will also cause or stop itfrom reporting it to the file   /////////////////
    
  //  d.set_report_severity_action(UVM_INFO, UVM_DISPLAY|UVM_LOG);
   // d.set_report_severity_action(UVM_WARNING, UVM_DISPLAY|UVM_LOG);
    d.set_report_severity_action(UVM_ERROR, UVM_DISPLAY|UVM_LOG);
 
    
    d.run();
    
    #10;
    $fclose(file);
  end
  
  
  
endmodule