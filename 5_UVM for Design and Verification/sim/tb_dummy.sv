`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 02:32:40 PM
// Design Name: 
// Module Name: tb_dummy
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

module tb_dummy();

 //-----------------------------------------------------------------
 //Here config class is just an object that issued to specify the ACTIVE or PASSIVE type of the testbench
 //   If DRIVER and MONITOR = ACTIVE  
 //     If MONITOR only = PASSIVE
 //   Created before transaction and used to "GET" from AGENT class and "SET" in ENV class 
  
class config_dff extends uvm_object;
  `uvm_object_utils(config_dff)
 
  uvm_active_passive_enum agent_type = UVM_ACTIVE; 
  
  function new(input string path = "config_dff");
    super.new(path);
   endfunction 
  
endclass

//--------------------------------------------------------------------

typedef enum bit [1:0] {add = 0, mul = 1} oper;    // This stays inside the module so no problem

class add_transaction extends uvm_sequence_item;
`uvm_object_utils(add_transaction)

    function new(string path = "add_transaction");
    super.new(path);
    endfunction
    
    rand bit [3:0] a;
    rand bit [3:0] b;
    rand oper op;
    
    constraint add1 { a == 4; b == 4;}
    constraint add2 { a == 10; b == 10;}
//    constraint mul1 { a == 5; b == 5;}
//    constraint mul2 { a == 15; b == 15;}
endclass

class add_seq1 extends uvm_sequence#(add_transaction);
`uvm_object_utils(add_seq1)

    function new(string path = "add_seq1");
    super.new(path);
    endfunction
    
    virtual task body();
    tr = add_transaction::type_id::create("tr");
    tr.add1.constraint_mode(1);
    tr.add2.constraint_mode(0);
//    tr.mul1.constraint_mode(0);
//    tr.mul2.constraint_mode(0);
    start_item(tr);
    assert(tr.randomize());
    tr.op = add;
    finish_item(tr);
    `uvm_info("ADD_SEQ1", $sformatf("a: %d, b: %d", tr.a, tr.b), UVM_NONE);
    endtask
endclass

class add_seq2 extends uvm_sequence#(add_transaction);
`uvm_object_utils(add_seq2)
    
    add_transaction tr;
    
    function new(string path = "add_seq2");
    super.new(path);
    endfunction
    
    virtual task body();
    tr = add_transaction::type_id::create("tr");
    tr.add1.constraint_mode(0);
    tr.add2.constraint_mode(1);
    start_item(tr);
    assert(tr.randomize());
    tr.op = add;
    finish_item(tr);
    `uvm_info("ADD_SEQ1", $sformatf("a: %d, b: %d", tr.a, tr.b), UVM_NONE);
    endtask
endclass

class add_seq_library extends uvm_sequence_library#(add_transaction);
`uvm_object_utils(add_seq_library)
`uvm_sequence_library_utils(add_seq_library)

    function new(string path = "add_seq_library");
    super.new(path);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    add_typewide_sequence(add_seq1::get_type());
    add_typewide_sequence(add_seq2::get_type());
    endfunction

endclass

class add_driver extends uvm_driver#(add_transaction);
`uvm_component_utils(add_driver)
    
    add_transaction tr;
    virtual dadd_if daif;

    function new(string path = "add_driver", uvm_component parent);
    super.new(path, parent);
    endfunction 
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = add_transaction::type_id::create("tr");
    
    if(!uvm_config_db#(virtual dadd_if)::get(this,"","daif", daif))
    `uvm_error("ADD_DRV", $sformatf("Unable to access interface"); 
    endfunction
    
    virtual task reset;
    
    endtask
    
    virtual task add;
    daif.aa <= tr.aa;
    
    endtask
    
    virtual task run_phase(uvm_phase phase);
    forever
    begin
        
        seq_item_port.get_next_item(tr);
        `uvm_info(get_type_name(), $sformatf("a : %0d  b : %0d",tr.a,tr.b), UVM_NONE); 
        daif.aa <= tr.a;
        daif.b <= tr.b;
        
    end
    endtask
endclass


endmodule












