`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2025 10:41:54 AM
// Design Name: 
// Module Name: tb_phase_in_sequence_callback
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

module tb_phase_in_sequence_callback(); 

class apb_tx extends uvm_sequence_item;
//`uvm_object_utils(apb_tx)
    
    rand int addr;
    rand bit wr_rd;
    
    function new(string name = "apb_tx");
        super.new(name);
    endfunction
    
    constraint cs { 
        addr inside {[0:20]};
     }
     
     `uvm_object_utils_begin(apb_tx)
        `uvm_field_int(addr, UVM_DEFAULT);
        `uvm_field_int(wr_rd, UVM_DEFAULT);
     `uvm_object_utils_end
    
endclass : apb_tx

class apb_base_seq extends uvm_sequence#(apb_tx);
`uvm_object_utils(apb_base_seq)

    uvm_phase phase;
    
    function new(string name = "apb_base_seq");
        super.new(name);
    endfunction
    
    
    // You see how we set dreain time for each seq in the pre_body and post_body with the phase we created 
    task pre_body;
        phase = get_starting_phase();       // This is a built in function that gives out the starting phase
        if(phase != null) begin
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 200);
        end    
    endtask
    
    task post_body;
        if(phase != null) begin
            phase.drop_objection(this);
        end    
    endtask

endclass : apb_base_seq

class apb_seq_n_wr_rd extends apb_base_seq;
`uvm_object_utils(apb_seq_n_wr_rd)

    apb_tx tx;
    apb_tx txQ[$];
    
    function new(string name = "apb_seq_n_wr_rd");
        super.new(name);
    endfunction
    
    task body();
        repeat(10) begin
            `uvm_do_with(req, {req.wr_rd == 1;});
            tx.copy(req);
            tx.print();
            txQ.push_back(tx);
        end
        repeat(10) begin
            tx = txQ.pop_front();
            tx.print();
            `uvm_do_with(req, {req.wr_rd == 0; req.addr == tx.addr;});
        end
    endtask
    
endclass : apb_seq_n_wr_rd

///   Test block to run the file DO NOT CONSIDER FOR LEARNING 

class apb_sequencer extends uvm_sequencer#(apb_tx);
  `uvm_component_utils(apb_sequencer)

  function new(string name = "apb_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass : apb_sequencer


class simple_test extends uvm_test;
    `uvm_component_utils(simple_test)
    
    apb_seq_n_wr_rd seq;
    apb_sequencer    seqr;
    
    function new(string name = "simple_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr = apb_sequencer::type_id::create("seqr", this);
        seq  = apb_seq_n_wr_rd::type_id::create("seq");
    endfunction
    
    // This code won't work as the run_phase was will be null as we are directly mapping seq to seqr
    // For more info check "tb_sequence_to_sequencer_mapping_methods" file at line 122 to 140
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq.start(seqr); // Start the sequence
        phase.drop_objection(this);
    endtask
endclass : simple_test

///////////////    MAIN MODULE    ////////////////////

// 2. The initial block to launch UVM
initial begin
    // Start the UVM test
    run_test("simple_test");
end

// 3. Add a timeout to prevent the simulation from running forever
initial begin
    #1000; // 1000 time units timeout
    $display("Simulation timeout reached!");
    $finish;
end

// ==================== WAVEFORM DUMP INITIAL BLOCK ====================
//initial begin
//    // Create a VCD dump file
//    $dumpfile("waves.vcd");
//    // Dump all variables in the testbench module and all its sub-modules
//    $dumpvars();
//end

endmodule
