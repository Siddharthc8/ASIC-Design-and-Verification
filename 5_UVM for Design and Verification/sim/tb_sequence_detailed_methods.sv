`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2024 05:38:24 PM
// Design Name: 
// Module Name: tb_sequence_detailed_methods
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



////////////////////////
/*
SEQ_ARB_FIFO (DEF) first in first out ..priority won't work
SEQ_ARB_WEIGHTED  
SEQ_ARB_RANDOM  strictly random
SEQ_ARB_STRICT_FIFO    support pri
SEQ_ARB_STRICT_RANDOM  support pri
SEQ_ARB_USER
 
*/
//////////////////////////////////////////////////////
 
`include "uvm_macros.svh"
import uvm_pkg::*;
//////////////////////////////////////////////////////
module tb_sequence_detailed_methods();

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
   `uvm_info("SEQ1", "Trans obj Created" , UVM_NONE);       
   
    trans = transaction::type_id::create("trans");     //          First create a transaction object 
   `uvm_info("SEQ1", "Waiting for Grant from Driver" , UVM_NONE);   
    wait_for_grant();                             //               Driver has to give the grant so wait for it
   `uvm_info("SEQ1", "Rcvd Grant..Randomizing Data" , UVM_NONE);
   assert(trans.randomize());                     //               Once granted we can randomize this can be done prior as well
   `uvm_info("SEQ1", "Randomization Done -> Sent Req to Drv" , UVM_NONE);
   send_request(trans);                          //                "send_request" is nothing but sending the data to driver
   `uvm_info("SEQ1", "Waiting for Item Done Resp from Driver" , UVM_NONE);
   wait_for_item_done();                        //                 Driver raises item_done wait for it "wait_for_item_done"
   `uvm_info("SEQ1", "SEQ1 Ended" , UVM_NONE); 
endtask
  
  
  
endclass
////////////////////////////////////////////////////////////////
 
 
 
class driver extends uvm_driver#(transaction);          // Driver takes an argument as well "transaction"
`uvm_component_utils(driver)
 
transaction t;
virtual adder_if aif;                                  // Don't forget to declare "interface" with virtual                     
 
function new(input string inst = "DRV", uvm_component c);  // Component so two arguments
super.new(inst,c);
endfunction
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
t = transaction::type_id::create("TRANS");
  if(!uvm_config_db#(virtual adder_if)::get(this,"","aif",aif))   // uvm_config_db is used to transfer the interface DRI -> DUT
`uvm_info("DRV", "Unable to access Interface", UVM_NONE); 
endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin                              //               STEPS 
      `uvm_info("Drv", "Sending Grant for Sequence" , UVM_NONE);    // Grant access to send 
    seq_item_port.get_next_item(t);                             //    once granted receive it with the seq_item_port.get_next_item();
      `uvm_info("Drv", "Applying Seq to DUT" , UVM_NONE);
      `uvm_info("Drv", "Sending Item Done Resp for Sequence" , UVM_NONE);
    seq_item_port.item_done();                               // Once done send the acknowledgement
    end
    
  endtask
 
 
endclass
 
 
 
class agent extends uvm_agent;                    
`uvm_component_utils(agent)
 
function new(input string inst = "AGENT", uvm_component c);
super.new(inst,c);
endfunction
 
driver d;
uvm_sequencer #(transaction) seq;           // Sequencer is built in so just calling that class inside agent is enough
 
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
d = driver::type_id::create("DRV",this);
seq = uvm_sequencer #(transaction)::type_id::create("seq",this);          // Decalration style is important
endfunction
 
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
d.seq_item_port.connect(seq.seq_item_export);                      // Connect the ports
endfunction
endclass
 
 
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
 
 
class test extends uvm_test;
`uvm_component_utils(test)
 
function new(input string inst = "TEST", uvm_component c);
super.new(inst,c);
endfunction
 
sequence1 s1;
env e;
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
e = env::type_id::create("ENV",this);
s1 = sequence1::type_id::create("s1");
endfunction
 
virtual task run_phase(uvm_phase phase);
 
phase.raise_objection(this);          // Objection is for starting the sequence and drain time can be added in end_of_elaboration_phase
s1.start(e.a.seq);
phase.drop_objection(this);
endtask
endclass
 
///////////////////////////////////////////////////////////////////////////////////////////////// 
 
  adder_if aif();                    // Decalre interface like DUT in tb_top
 
 
 
initial begin
  uvm_config_db #(virtual adder_if)::set(null, "*", "aif", aif);
  run_test("test");
end
 
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule