`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2024 09:20:57 AM
// Design Name: 
// Module Name: tb_sequence_library
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


import uvm_pkg::*;
`include "uvm_macros.svh"
 
module tb_sequence_library();

class transaction extends uvm_sequence_item;
  `uvm_object_utils(transaction)
   
  rand bit [3:0] a;
  rand bit [3:0] b;
  
 
  function new(string name = "transaction");
    super.new(name);
  endfunction
 
 
endclass
////////////////////////////////////////////////////
 
typedef class seq_library;                            // This is only required when you use the second factory registration int he sequence class
                                                      //   Instead can use the "typewide" method to create an object                        |
                                                      //                                                                                    |
//////////////////////////////////////////////////////                                                                                      |
                                                     //                                                                                     |
class seq1 extends uvm_sequence#(transaction);       //                                                                                     |
  `uvm_object_utils(seq1)                            //                                                                                     |
  //`uvm_add_to_seq_lib(seq1, seq_library)           // <------------- <--------------------  <------------------  <------------------   <---
  
  transaction tr;
  
  function new(string name = "seq1");
    super.new(name);
  endfunction
 
  virtual task body();
    tr = transaction::type_id::create("tr");
    start_item(tr);
    tr.a = 4;
    tr.b = 4;
    finish_item(tr);
  endtask
  
   
endclass
 
////////////////////////////////////////////////////////////
 
class seq2 extends uvm_sequence#(transaction);
  `uvm_object_utils(seq2)
  //`uvm_add_to_seq_lib(seq2, seq_library)
  
  transaction tr;
  
  function new(string name = "seq2");
    super.new(name);
  endfunction
 
  virtual task body();
    tr = transaction::type_id::create("tr");
    start_item(tr);
    tr.a = 5;
    tr.b = 5;
    finish_item(tr);
  endtask
  
   
endclass
//////////////////////////////  SEQUENCE LIBRARY  //////////////////////////////
 
class seq_library extends uvm_sequence_library #(transaction);     
  `uvm_object_utils(seq_library)
  `uvm_sequence_library_utils(seq_library)                       // Extra registration just like object we are using the extension name
  
//  seq1 s1; 
//  seq2 s2;
  
//  function new(string name, uvm_component parent);
//    super.new(name, parent);                        // Should use "seq1.get_type" for this method where you create an object 
//    seq1.get_type
//  endfunction
                                     
  function new(string name = "seq_library");                 // NOTE: We haven't created instances for the sequences. If you did you ahve to change the command
    super.new(name);                                         
    add_typewide_sequence(seq1::get_type());          //   Syntax for add_type_wide_sequence(seq1::get_type());
    add_typewide_sequence(seq2::get_type());
    
  //  assert(seqlib.randomize());
  endfunction
 
endclass
 
 
/////////////////////////////////////////////////
class driver extends uvm_driver #(transaction);
  `uvm_component_utils(driver)
 
   transaction tr;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
 
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(tr);
      `uvm_info(get_type_name(), $sformatf("a : %0d  b : %0d",tr.a,tr.b), UVM_NONE);                         // "get_type_name" takes in the class's name
      #10;
      seq_item_port.item_done();
    end
  endtask
endclass
 
///////////////////////////////////////////////////////////////////////////////////
 
class agent extends uvm_agent;
`uvm_component_utils(agent)
  
 
function new(input string inst = "agent", uvm_component parent = null);
super.new(inst,parent);
endfunction
 
 driver d;
 uvm_sequencer#(transaction) seqr;
 
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);  
   d = driver::type_id::create("d",this);
   seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this); 
endfunction
 
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
 d.seq_item_port.connect(seqr.seq_item_export);
endfunction
 
endclass
/////////////////////////////////////////////////////////////////////////////
 
 
class env extends uvm_env;
`uvm_component_utils(env)
 
function new(input string inst = "env", uvm_component c);
super.new(inst,c);
endfunction
 
agent a;
 
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  a = agent::type_id::create("a",this);
endfunction
 
 
endclass
 
///////////////////////////////////////////////////////////////////
class test extends uvm_test;
`uvm_component_utils(test)
 
  env e;
  seq_library seqlib;                                       /// Test clas is where we decalre the sequence library
 
  
  
function new(input string inst = "test", uvm_component c);
super.new(inst,c);
endfunction
 
   virtual function void build_phase(uvm_phase phase);         // Create objects for all the sequences here
    super.build_phase(phase);
     e = env::type_id::create("e", this);
     seqlib = seq_library::type_id::create("seqlib");        // Just like object 
     seqlib.selection_mode = UVM_SEQ_LIB_RANDC;              // Lets you randomize the sequnces as well using dot methods
     seqlib.min_random_count = 5;                // Specifies the minimum number of transactions to be sent to the sequncer irrespective of how many sequences we have
     seqlib.max_random_count = 10;               // Specifies the maximum limit
     seqlib.init_sequence_library();         // Should initialize the sequnce library
     seqlib.print();                          // Print helps us understand the dynamics of the sequnce library
   endfunction
  
 
  
  virtual task run_phase(uvm_phase phase);
   // uvm_config_db#(uvm_sequence_base)::set(this,"e.a.seqr.run_phase", "default_sequence",seqlib); 
    phase.raise_objection(this);
    assert(seqlib.randomize());              // We will also have to randomize it for it to have effect
    seqlib.start(e.a.seqr);              // Establish the connection betwen the sequnce library and the sequncer using the start method
    phase.drop_objection(this);
  endtask
  
endclass
 
/////////////////////////////////////////////////////////////////////////
 
 
  initial begin
    run_test("test");
  end
endmodule