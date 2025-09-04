`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/21/2025 06:24:10 PM
// Design Name: 
// Module Name: tb_lock_vs_grab
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

module tb_lock_vs_grab();

//// Simple sequence item
//class my_transaction extends uvm_sequence_item;
//  rand bit [7:0] data;
//  rand int id;
  
//  `uvm_object_utils_begin(my_transaction)
//    `uvm_field_int(data, UVM_ALL_ON)
//    `uvm_field_int(id, UVM_ALL_ON)
//  `uvm_object_utils_end
  
//  function new(string name = "my_transaction");
//    super.new(name);
//  endfunction
//endclass

//// Driver
//class my_driver extends uvm_driver #(my_transaction);
//  `uvm_component_utils(my_driver)
  
//  function new(string name, uvm_component parent);
//    super.new(name, parent);
//  endfunction
  
//  virtual task run_phase(uvm_phase phase);
//    forever begin
//      seq_item_port.get_next_item(req);
//      `uvm_info("DRIVER", $sformatf("Driving transaction: id=%0d, data=0x%0h", 
//                req.id, req.data), UVM_MEDIUM)
//      #10; // Simulate some processing time
//      seq_item_port.item_done();
//    end
//  endtask
//endclass

//// Sequencer
//class my_sequencer extends uvm_sequencer #(my_transaction);
//  `uvm_component_utils(my_sequencer)
  
//  function new(string name, uvm_component parent);
//    super.new(name, parent);
//  endfunction
//endclass

//// Base sequence
//class base_sequence extends uvm_sequence #(my_transaction);
//  `uvm_object_utils(base_sequence)
  
//  int sequence_id;
//  string sequence_name;
  
//  function new(string name = "base_sequence");
//    super.new(name);
//  endfunction
  
//  task body();
//    my_transaction tr;
//    `uvm_info(sequence_name, $sformatf("Starting sequence %0d", sequence_id), UVM_MEDIUM)
    
//    for (int i = 0; i < 3; i++) begin
//      tr = my_transaction::type_id::create("tr");
//      assert(tr.randomize() with {id == sequence_id;});
//      `uvm_info(sequence_name, $sformatf("Sending item %0d: data=0x%0h", i, tr.data), UVM_MEDIUM)
//      start_item(tr);
//      finish_item(tr);
//      #5;
//    end
    
//    `uvm_info(sequence_name, $sformatf("Finished sequence %0d", sequence_id), UVM_MEDIUM)
//  endtask
//endclass

//// Sequence using lock()
//class lock_sequence extends base_sequence;
//  `uvm_object_utils(lock_sequence)
  
//  function new(string name = "lock_sequence");
//    super.new(name);
//    sequence_name = "LOCK_SEQ";
//  endfunction
  
//  task body();
//    `uvm_info(sequence_name, "Requesting lock()", UVM_MEDIUM)
//    lock(); // Request exclusive access (waits in FIFO)
//    `uvm_info(sequence_name, "Got lock() - starting exclusive access", UVM_HIGH)
    
//    super.body(); // Execute the base sequence body
    
//    `uvm_info(sequence_name, "Releasing lock()", UVM_MEDIUM)
//    unlock(); // Release exclusive access
//  endtask
//endclass

//// Sequence using grab()
//class grab_sequence extends base_sequence;
//  `uvm_object_utils(grab_sequence)
  
//  function new(string name = "grab_sequence");
//    super.new(name);
//    sequence_name = "GRAB_SEQ";
//  endfunction
  
//  task body();
//    `uvm_info(sequence_name, "Requesting grab()", UVM_MEDIUM)
//    grab(); // Immediately take exclusive access (bypasses waiting sequences)
//    `uvm_info(sequence_name, "Got grab() - starting exclusive access", UVM_HIGH)
    
//    super.body(); // Execute the base sequence body
    
//    `uvm_info(sequence_name, "Releasing grab()", UVM_MEDIUM)
//    ungrab(); // Release exclusive access
//  endtask
//endclass

//// Regular sequence without locking
//class normal_sequence extends base_sequence;
//  `uvm_object_utils(normal_sequence)
  
//  function new(string name = "normal_sequence");
//    super.new(name);
//    sequence_name = "NORMAL_SEQ";
//  endfunction
//endclass

//// Test class
//class lock_vs_grab_test extends uvm_test;
//  `uvm_component_utils(lock_vs_grab_test)
  
//  my_sequencer sequencer;
//  my_driver driver;
  
//  function new(string name, uvm_component parent);
//    super.new(name, parent);
//  endfunction
  
//  function void build_phase(uvm_phase phase);
//    super.build_phase(phase);
//    sequencer = my_sequencer::type_id::create("sequencer", this);
//    driver = my_driver::type_id::create("driver", this);
//  endfunction
  
//  function void connect_phase(uvm_phase phase);
//    super.connect_phase(phase);
//    driver.seq_item_port.connect(sequencer.seq_item_export);
//  endfunction
  
//  task run_phase(uvm_phase phase);
//    lock_sequence lock_seq;
//    grab_sequence grab_seq;
//    normal_sequence normal_seq1, normal_seq2;
    
//    phase.raise_objection(this);
    
//    // Create sequences
//    lock_seq = lock_sequence::type_id::create("lock_seq");
//    grab_seq = grab_sequence::type_id::create("grab_seq");
//    normal_seq1 = normal_sequence::type_id::create("normal_seq1");
//    normal_seq2 = normal_sequence::type_id::create("normal_seq2");
    
//    // Set sequence IDs
//    lock_seq.sequence_id = 1;
//    grab_seq.sequence_id = 2;
//    normal_seq1.sequence_id = 3;
//    normal_seq2.sequence_id = 4;
    
//    `uvm_info("TEST", "Starting demonstration of lock() vs grab()", UVM_MEDIUM)
//    `uvm_info("TEST", "Note the order of execution in the log", UVM_MEDIUM)
    
//    // Fork all sequences to run concurrently
//    fork
//      begin : seq1
//        #1 lock_seq.start(sequencer);
//      end
      
//      begin : seq2
//        #2 grab_seq.start(sequencer);
//      end
      
//      begin : seq3
//        normal_seq1.start(sequencer);
//      end
      
//      begin : seq4
//        #5 normal_seq2.start(sequencer);
//      end
//    join
    
//    #100;
//    phase.drop_objection(this);
//  endtask
//endclass

//// Top module
//  initial begin
//    run_test("lock_vs_grab_test");
//  end

///////////////////////////////////////////////////////////////////////////////////////////////////////////

//==============================================================
// UVM Example: lock() vs grab()
//==============================================================

`include "uvm_macros.svh"
import uvm_pkg::*;


//--------------------------------------------------------------
// Simple transaction
//--------------------------------------------------------------
class my_item extends uvm_sequence_item;
  rand int data;

  `uvm_object_utils(my_item)

  function new(string name="my_item");
    super.new(name);
  endfunction
endclass


//--------------------------------------------------------------
// Sequence to demonstrate lock vs grab
//--------------------------------------------------------------
class my_sequence extends uvm_sequence #(my_item);
  string seq_name;

  `uvm_object_utils(my_sequence)
  `uvm_declare_p_sequencer(uvm_sequencer#(my_item)) // <-- Required!

  function new(string name="my_sequence");
    super.new(name);
    seq_name = name;
  endfunction

  task body();
    my_item item;

    if (seq_name == "LOCK_SEQ") begin
      p_sequencer.lock(this);
      `uvm_info(seq_name, "Got LOCK on sequencer", UVM_LOW)

      repeat (3) begin
        item = my_item::type_id::create("item");
        start_item(item);
        item.data = $urandom_range(0,99);
        finish_item(item);
        `uvm_info(seq_name, $sformatf("Sent item (data=%0d)", item.data), UVM_LOW)
        #5;
      end

      p_sequencer.unlock(this);
      `uvm_info(seq_name, "Released LOCK", UVM_LOW)
    end

    else if (seq_name == "GRAB_SEQ") begin
      p_sequencer.grab(this);
      `uvm_info(seq_name, "Got GRAB on sequencer", UVM_LOW)

      repeat (3) begin
        item = my_item::type_id::create("item");
        start_item(item);
        item.data = $urandom_range(100,199);
        finish_item(item);
        `uvm_info(seq_name, $sformatf("Sent item (data=%0d)", item.data), UVM_LOW)
        #5;
      end

      p_sequencer.ungrab(this);
      `uvm_info(seq_name, "Released GRAB", UVM_LOW)
    end
  endtask
endclass


//--------------------------------------------------------------
// Simple driver (just prints received items)
//--------------------------------------------------------------
class my_driver extends uvm_driver #(my_item);
  `uvm_component_utils(my_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    my_item item;
    forever begin
      seq_item_port.get_next_item(item);
      `uvm_info("DRIVER", $sformatf("Driving item with data=%0d", item.data), UVM_LOW)
      #2;
      seq_item_port.item_done();
    end
  endtask
endclass


//--------------------------------------------------------------
// Environment: sequencer + driver
//--------------------------------------------------------------
class my_env extends uvm_env;
  `uvm_component_utils(my_env)

  uvm_sequencer #(my_item) seqr;
  my_driver drv;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr = uvm_sequencer#(my_item)::type_id::create("seqr", this);
    drv  = my_driver::type_id::create("drv", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass


//--------------------------------------------------------------
// Test: runs both sequences in parallel
//--------------------------------------------------------------
class my_test extends uvm_test;
  `uvm_component_utils(my_test)

  my_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = my_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    my_sequence lock_seq, grab_seq;

    phase.raise_objection(this);

    lock_seq = my_sequence::type_id::create("LOCK_SEQ");
    grab_seq = my_sequence::type_id::create("GRAB_SEQ");

    fork
      lock_seq.start(env.seqr);
      grab_seq.start(env.seqr);
    join_none

    #100;
    phase.drop_objection(this);
  endtask
endclass


//--------------------------------------------------------------
// Top module
//--------------------------------------------------------------

  initial begin
    run_test("my_test");
  end



endmodule
