`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2025 02:14:50 PM
// Design Name: 
// Module Name: tb_uvm_do_vs_uvm_send
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

module tb_uvm_do_vs_uvm_send();

/////////////////////////////////////////////////////////////////////////////
//                      UVM_DO
////////////////////////////////////////////////////////////////////////////

// create_item() to create the transaction
// start_item() to initiate sending
// randomize() to randomize the transaction
// finish_item() to complete sending

// More convenient for most use cases

// NOte you dont have to create an object when you use this





/////////////////////////////////////////////////////////////////////////////
//                      UVM_DO_WITH
////////////////////////////////////////////////////////////////////////////

// create_item() to create the transaction
// start_item() to initiate sending
// randomize() to randomize the transaction with custom constraints or override existing
// finish_item() to complete sending

// Used when

//When you need to specify specific constraints for a transaction
//When you want to ensure certain fields have specific values
//When you need to override default randomization behavior
//When you want to keep the constraint code close to where the item is sent





/////////////////////////////////////////////////////////////////////////////
//                      UVM_SEND
////////////////////////////////////////////////////////////////////////////

// start_item() to initiate sending
// finish_item() to complete sending

// More efficient when you need to send the same item multiple times

endmodule
