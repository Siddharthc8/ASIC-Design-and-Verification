`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2024 05:03:44 PM
// Design Name: 
// Module Name: tb_creating_sequence
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
 
/////////////////////////////////////////////////////////////
module tb_creating_sequence();


class transaction extends uvm_sequence_item;    // Note the extension
  
  rand bit [3:0] a;
  rand bit [3:0] b;
       bit [4:0] y;
 
 
  function new(input string path = "transaction");    // Object so only one argument
    super.new(path);
  endfunction
 
`uvm_object_utils_begin(transaction)          // To use field macros
  `uvm_field_int(a,UVM_DEFAULT)
  `uvm_field_int(b,UVM_DEFAULT)
  `uvm_field_int(y,UVM_DEFAULT)
`uvm_object_utils_end
 
endclass
////////////////////////////////////////////////////////////////
// More like generator but has some built in methods to control the flow
class sequence1 extends uvm_sequence#(transaction);       // Sequence is called and takes "transaction" as argument
  `uvm_object_utils(sequence1)
 
 
    function new(input string path = "sequence1");   
      super.new(path);
    endfunction
 
    virtual task pre_body();                               // Sequence class had methods called pre_body, body, post_body
      `uvm_info("SEQ1", "PRE-BODY EXECUTED", UVM_NONE);
    endtask
 
 
    virtual task body();
      `uvm_info("SEQ1", "BODY EXECUTED", UVM_NONE);
    endtask
 
 
 
    virtual task post_body();
      `uvm_info("SEQ1", "POST-BODY EXECUTED", UVM_NONE);
    endtask
  
  
endclass
 
////////////////////////////////////////////////////
 
class driver extends uvm_driver#(transaction);             // Driver takes transaction as argument as well
`uvm_component_utils(driver)
 
transaction t;
 
 
  function new(input string path = "DRV", uvm_component parent = null);
    super.new(path,parent);
  endfunction
 
  
  virtual function void build_phase(uvm_phase phase);            // Build_phase for creating an object
  super.build_phase(phase);
    
    t = transaction::type_id::create("t");
 
  endfunction
  
  
 
    virtual task run_phase(uvm_phase phase);      // Can use main phase or run_phase directly
    forever begin
    seq_item_port.get_next_item(t);               // seq_item_port.get_next_item(tr); is used between "Sequencer" and "Driver"
     //////apply seq to DUT 
    seq_item_port.item_done();                    // Mark the end with seq_item_port.item_done();
    end
    endtask
 
endclass
 
//////////////////////////////////////////////////////////////
 
class agent extends uvm_agent;
`uvm_component_utils(agent)
 
  function new(input string path = "agent", uvm_component parent = null);
    super.new(path,parent);
  endfunction
 
  driver d;                             // Instance of Driver
  uvm_sequencer #(transaction) seqr;    // Sequencer is built in so just calling that class inside agent is enough
 
 
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      d = driver::type_id::create("d",this);
      seqr = uvm_sequencer #(transaction)::type_id::create("seqr",this);      // Decalration style is important
    endfunction
 
    virtual function void connect_phase(uvm_phase phase); // Connect phase here is used to connect the harbors between Sequencer and Driver
    super.connect_phase(phase);
      d.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass
 
////////////////////////////////////////////////////////////
 
class env extends uvm_env;   
`uvm_component_utils(env)
 
  function new(input string path = "env", uvm_component parent= null);   
    super.new(path,parent);
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
 
  function new(input string path = "test", uvm_component parent = null);
  super.new(path,parent);
  endfunction
 
	sequence1 seq1;                      // Sequence is a part of test so the instance is created her and no-where else
	env e;
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  e = env::type_id::create("e",this);
  seq1 = sequence1::type_id::create("seq1");
endfunction
 
  virtual task run_phase(uvm_phase phase);
  phase.raise_objection(this);
    
  seq1.start(e.a.seqr);               // This is where sequence is connected to sequencer
    
  phase.drop_objection(this);
  endtask
  
endclass
 
///////////////////////////////////////////////////////// 
 
initial begin
  run_test("test");
end
 
 
endmodule