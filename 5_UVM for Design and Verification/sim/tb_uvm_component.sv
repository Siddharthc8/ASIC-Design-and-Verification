`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2024 09:57:08 PM
// Design Name: 
// Module Name: tb_uvm_component
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

module tb_uvm_component();

class comp extends uvm_component;
    `uvm_component_utils(comp)
    
    function new(string path = "comp", uvm_component parent = null);
        super.new(path,parent);
    endfunction    
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("comp", "Build phase of comp executed", UVM_NONE);
    endfunction

endclass
///////////////// MAIN MODULE ///////////////////
    
//    comp c;             // System Verilog Method Usual Method
    
    initial begin
        
//        c = comp::type_id:create("c");    // Usual method
//        c.build_phase(null);           // Usual method
        run_test("comp");  // no need to create a handler nor create a constructor
    end
    
endmodule
