`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2025 07:29:08 PM
// Design Name: 
// Module Name: tb_interface_class_and_implements_keyword
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




/*

Key Concepts:
extends vs implements:

extends → Used for class inheritance (child class gets all methods/properties of parent).

implements → Used for interface class implementation (a contract where the class must define all methods declared in the interface).

cfs_apb_reset_handler is likely an interface class (not a regular class) that defines a set of pure virtual methods (like reset() or handle_reset()). 
Your sequencer must provide concrete implementations for these methods.


*/

`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_interface_class_and_implements_keyword();

// Define an interface class (like a "contract")
interface class cfs_apb_reset_handler;            // THIS IS AN INTERFACE CLASS
  pure virtual task handle_reset();
endclass


// Driver class
class cfs_apb_item_drv;

endclass

// Your sequencer must implement all methods of the interface
class cfs_apb_sequencer extends uvm_sequencer#(cfs_apb_item_drv) implements cfs_apb_reset_handler;      // We use implements because of the interface class methods
`uvm_component_utils(cfs_apb_sequencer)                                                                // Unlike virtual class we have to implement all functions in interface class

    function new(input string path = "", uvm_component parent);
        super.new(path, aprent);
    endfunction
    
  // Must define handle_reset() since it's required by the interface
  virtual task handle_reset();
    `uvm_info("RESET", "Handling APB reset in sequencer", UVM_MEDIUM)
    // Reset logic here
  endtask
  
endclass

endmodule
