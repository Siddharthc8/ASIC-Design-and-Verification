`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2025 07:44:14 AM
// Design Name: 
// Module Name: tb_factory_override_class
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

module tb_factory_override_class();

class base_seq extends uvm_sequence#(uvm_sequence_item) ;
`uvm_object_utils(base_seq)

    function new(string name = "base_seq");
        super. new (name);
    endfunction
    
    task body();
        `uvm_info( "BASE SEQ", "Running base sequence", UVM_LOW);
    endtask
    
    virtual function void print();
        `uvm_info("BASE SEQ", "Print statement from base class", UVM_LOW);
    endfunction
endclass

class derived_seq extends base_seq;
`uvm_object_utils(derived_seq)

    function new(input string name = "derived_seq");
        super. new (name) ;
    endfunction
    
    task body();
        `uvm_info("DERIVED SEQ", "Running derived sequence", UVM_LOW);
    endtask
    
    function void print();
        `uvm_info("DERIVED SEQ", "Print statement from derived class", UVM_LOW);
    endfunction
    
endclass


    
class my_test extends uvm_test; 
`uvm_component_utils(my_test)


    function new(string name = "my_test", uvm_component parent = null);
        super. new (name, parent);
    endfunction
    
    virtual function void build_phase (uvm_phase phase);
    super. build_phase (phase) ;
        // Run the derived class as the "BODY" class in the uvm_sequence class is virtual and will pass on to all derived class methods with the same name
        // So it prints the derived class even without virtual keyword but is it good to use virtual to show it is
        uvm_factory::get().set_type_override_by_type(base_seq::get_type(), derived_seq::get_type());
    endfunction
    
    task run_phase (uvm_phase phase) ;
        base_seq seq;
        phase.raise_objection(this);
        seq = base_seq:: type_id:: create ("seq");
        seq.start (null);                      
        seq.print();                              // If not marked virtual prints base class method just like polymorphism
        phase.drop_objection(this);
    endtask
    
    
endclass


    initial begin
        run_test("my_test");
    end

endmodule