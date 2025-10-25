`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2025 12:42:29 PM
// Design Name: 
// Module Name: tb_sequence_layering
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

`include"uvm_macros.svh"
import uvm_pkg::*;

`define NEW_OBJ \
function new(string name = "");\
    super.new(name);\
endfunction

`define NEW_COMP \
function new(string name = "", uvm_component parent = null);\
    super.new(name, parent);\
endfunction

module tb_sequence_layering();

class my_tx extends uvm_sequence_item();

    `NEW_OBJ
    
    rand int a;
    rand int b;
    
    constraint cons{ a inside {[0:20]};
                     b inside {[0:20]};
                   }
    

endclass

 
class base_seq extends uvm_sequence#(my_tx);      // ONLY contains pre and post body to maintain the phase raise and drop and drain time
`uvm_object_utils(my_tx) 

    `NEW_OBJ
    
    uvm_phase phase;
    
    task pre_body();
        phase = get_starting_phase();               // Built in function to get the starting phase
        if(phase != null) begin
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 200);
        end
    endtask
    
    task post_body();
        if(phase != null) begin
            phase.drop_objection(this);
        end
    endtask
    
endclass


class sub_seq1 extends base_seq;
`uvm_component_utils(sub_seq1)

    `NEW_OBJ
    
    task body;
        
        
        
    endtask
        

endclass

class base_test extends uvm_test;
`uvm_component_utils(base_test)

    `NEW_COMP
    
    // Env handle
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // env object creation using type id
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
    
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

endclass

class wr_rd_test extends base_test;
`uvm_component_utils(wr_rd_test)

    `NEW_COMP
    
    

endclass

endmodule
