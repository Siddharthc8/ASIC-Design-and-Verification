`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2024 07:40:50 PM
// Design Name: 
// Module Name: tb_sequence_lock_unlock_access
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


//   NOTE : priority method is mentioning priority in the test env check below
//   NOTE : When lock and grab are used in multiple sequences grab takes higher priority


`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_sequence_lock_unlock_access();
 
class transaction extends uvm_sequence_item;
  rand bit [3:0] a;
  rand bit [3:0] b;
       bit [4:0] y;
 
 
  function new(input string inst = "transaction");
  super.new(inst);
  endfunction
 
`uvm_object_utils_begin(transaction)
  `uvm_field_int(a,UVM_DEFAULT)
  `uvm_field_int(b,UVM_DEFAULT)
  `uvm_field_int(y,UVM_DEFAULT)
`uvm_object_utils_end
 
endclass
//////////////////////////////////////////////////////
 
class sequence1 extends uvm_sequence#(transaction);
  `uvm_object_utils(sequence1)
 
transaction trans;
 
  function new(input string inst = "seq1");
  super.new(inst);
  endfunction
 
   virtual task body();
     
     lock(m_sequencer);    // Can also use "this.get_sequencer()"
     
           repeat(3) begin
 
           `uvm_info("SEQ1", "SEQ1 Started" , UVM_NONE); 
            trans = transaction::type_id::create("trans");
            start_item(trans);
            assert(trans.randomize);
            finish_item(trans);
           `uvm_info("SEQ1", "SEQ1 Ended" , UVM_NONE); 
 
           end
     
     unlock(m_sequencer);
     
     
   endtask
  
  
  
endclass
////////////////////////////////////////////////////////////////
 
class sequence2 extends uvm_sequence#(transaction);
  `uvm_object_utils(sequence1)
 
transaction trans;
 
  function new(input string inst = "seq1");
  super.new(inst);
  endfunction
 
   virtual task body();
     
     lock(m_sequencer);    // Can also use "this.get_sequencer()"
     
           repeat(3) begin
 
           `uvm_info("SEQ1", "SEQ1 Started" , UVM_NONE); 
            trans = transaction::type_id::create("trans");
            start_item(trans);
            assert(trans.randomize);
            finish_item(trans);
           `uvm_info("SEQ1", "SEQ1 Ended" , UVM_NONE); 
 
           end
     
     unlock(m_sequencer);
     
     
   endtask
  
  
  
endclass
////////////////////////////////////////////////////////
 
class sequence3 extends uvm_sequence#(transaction);
  `uvm_object_utils(sequence2)
 
transaction trans;
 
  function new(input string inst = "seq2");
  super.new(inst);
  endfunction
 
  
  virtual task body();
                                                  // Syntax is as you see
    grab(m_sequencer);                            // Lock here  
    
    repeat(3) begin
    
    `uvm_info("SEQ2", "SEQ2 Started" , UVM_NONE); 
    trans = transaction::type_id::create("trans");
    start_item(trans);
    assert(trans.randomize);
    finish_item(trans);
    `uvm_info("SEQ2", "SEQ2 Ended" , UVM_NONE);
      
    end  
    
    ungrab(m_sequencer);                         // Unlock here 
    
  endtask
  
  
endclass
 
 
////////////////////////////////////////////////////////////////////
 
class driver extends uvm_driver#(transaction);
`uvm_component_utils(driver)
 
transaction t;
virtual adder_if aif;
 
function new(input string inst = "DRV", uvm_component c);
super.new(inst,c);
endfunction
 
  virtual function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
  	t = transaction::type_id::create("TRANS");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
    seq_item_port.get_next_item(t);
    seq_item_port.item_done();
    end    
  endtask
 
 
endclass
 
///////////////////////////////////////////////////////////
 
class agent extends uvm_agent;
`uvm_component_utils(agent)
 
function new(input string inst = "AGENT", uvm_component c);
super.new(inst,c);
endfunction
 
driver d;
uvm_sequencer #(transaction) seqr;
 
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
d = driver::type_id::create("DRV",this);
seqr = uvm_sequencer #(transaction)::type_id::create("seqr",this);
endfunction
 
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
d.seq_item_port.connect(seq.seq_item_export);
endfunction
endclass
 
/////////////////////////////////////////////////////////////////////////
 
class env extends uvm_env;
`uvm_component_utils(env)
 
function new(input string inst = "ENV", uvm_component c);
super.new(inst,c);
endfunction
 
agent a;
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  a = agent::type_id::create("AGENT",this);
endfunction
 
endclass
 
///////////////////////////////////////////////////////////////
 
class test extends uvm_test;
`uvm_component_utils(test)
 
function new(input string inst = "TEST", uvm_component c);
super.new(inst,c);
endfunction
 
sequence1 s1;
sequence2 s2;  
env e;
 
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("ENV",this);
    s1 = sequence1::type_id::create("s1");
    s2 = sequence2::type_id::create("s2");  
    endfunction
 
    virtual task run_phase(uvm_phase phase);
 
    phase.raise_objection(this);
   // e.a.seq.set_arbitration(UVM_SEQ_ARB_STRICT_FIFO);
      
                                                // By default they go alternatively
    fork  
       s2.start(e.a.seqr, null, 200);            // Here SEQ 2 has more priority than SEQ 1 so SEQ 2 is executed first
       s1.start(e.a.seqr, null, 100);  
    join  
    
    /*
      Can also be executes as below,

      // Sequence B gets grab first  
          seqB.grab(sequencer);
      // Then Sequence A tries to lock
          seqA.lock(sequencer);

    */
      
    phase.drop_objection(this);
    endtask
endclass
 
//////////////////////////////////////////////////////// 
 
initial begin
  run_test("test");
end
 
endmodule


