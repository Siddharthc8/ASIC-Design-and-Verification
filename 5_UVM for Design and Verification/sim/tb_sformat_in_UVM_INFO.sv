`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2024 11:11:05 PM
// Design Name: 
// Module Name: tb_sformat_in_UVM_INFO
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
 
module tb_sformat_in_UVM_INFO();
  
int data = 56;
  
  initial begin
    `uvm_info("TB_TOP", $sformatf("Value of data : %0d",data), UVM_NONE);  // $sformat is used like display inside UVM_INFO
  end
  
  
  
endmodule