`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2024 07:47:55 PM
// Design Name: 
// Module Name: tb_adder_combinational
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

module tb_adder_combinational();

class transaction extends uvm_sequence_item;
    rand bit [3:0] a;
    rand bit [3:0] b;
    bit [4:0] y;
    
    function new(input string path = "transaction");
    super.new(path);
    endfunction
    
    `uvm_object_utils_begin(transaction)
    `uvm_field_int(a, UVM_DEFAULT)
    `uvm_field_int(b, UVM_DEFAULT)
    `uvm_field_int(y, UVM_DEFAULT)
    `uvm_object_utils_end

endclass

class generator extends uvm_sequence#(transaction);
`uvm_object_utils(generator)
    
    transaction t;
    integer i;
    
    function new(input string path = "generator");
    super.new(path);
    endfunction
    
    virtual task body();
        t = transaction::type_id::create("t");
    
        repeat(10) begin
            start_item(t);
            t.randomize();
            `uvm_info("GEN",$sformatf("Data send to Driver a :%0d , b :%0d",t.a,t.b), UVM_NONE);
            finish_item(t);    
        end
    endtask

endclass

class driver extends uvm_driver#(transaction);
`uvm_component_utils(driver)
    
    transaction tc;
    virtual add_if aif;

    function new(input string path = "driver", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        tc = transaction::type_id::create("tc");
        if(!uvm_config_db #(virtual add_if)::get(this,"","aif",aif))  // Context, Instance name, key, value 
        `uvm_error("DRV", "Unable to access uvm_config_db"); 
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(tc);
            aif.a <= tc.a;
            aif.b <= tc.b;
            `uvm_info("DRV", $sformatf("Trigger DUT a: %0d ,b :  %0d",tc.a, tc.b), UVM_NONE);
            seq_item_port.item_done();
            #10;
        end
    endtask

endclass

class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
    
    transaction t;
    uvm_analysis_port #(transaction) a_port_send;
    virtual add_if aif;
    
    function new(input string path = "monitor", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t = transaction::type_id::create("t");
    a_port_send = new("a_port_send", this);
    
    if(!uvm_config_db #(virtual add_if)::get(this,"","aif", aif))
    `uvm_error("MON", "Unable to access uvm_config_db");
    
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            #10;
            t.a = aif.a;
            t.b = aif.b;
            t.y = aif.y;
            `uvm_info("MON", $sformatf("Data sent to scoreboard a: %0d, b: %0d, y: %0d", t.a, t.b, t.y), UVM_NONE);
            a_port_send.write(t);
        end
    endtask
    
endclass

class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)
    
    transaction tr;
    uvm_analysis_imp #(transaction, scoreboard) a_port_recv;
    
    function new(input string path = "scoreboard", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    a_port_recv = new("a_port_recv", this);
    endfunction
    
    virtual function void write(input transaction t);
        tr = t;
        `uvm_info("SCO", $sformatf("Data rcvd from monitor a: %0d, b = %0d, y = %0d", tr.a, tr.b, tr.y), UVM_NONE);
        if(tr.y == tr.a + tr.b)
            `uvm_info("SCO", "DATA MATCHED", UVM_NONE)                        // Do not add semi-colon
        else
            `uvm_info("SCO", "NOT A MATCH", UVM_NONE);
    endfunction
    
endclass


class agent extends uvm_agent;
`uvm_component_utils(agent)
    
    uvm_sequencer #(transaction) seqr;
    driver d;
    monitor m;
    
    function new(input string path = "agent", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr = uvm_sequencer #(transaction)::type_id::create("seqr", this);
    d = driver::type_id::create("d", this);
    m = monitor::type_id::create("m", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d.seq_item_port.connect(seqr.seq_item_export);
    endfunction
    
endclass

class env extends uvm_env;
`uvm_component_utils(env)

    agent a;
    scoreboard s;
    
    function new(input string path = "env", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a = agent::type_id::create("a", this);
    s = scoreboard::type_id::create("s", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a.m.a_port_send.connect(s.a_port_recv);
    endfunction
endclass

class test extends uvm_test;
`uvm_component_utils(test)
    
    generator gen;
    env e;

    function new(input string path = "test", uvm_component parent = null);
    super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gen = generator::type_id::create("gen");
    e = env::type_id::create("e", this);        
    endfunction
    
    virtual task run_phase(uvm_phase phase);
//    phase.phase_done.set_drain_time(this, 100);
        phase.raise_objection(this);
        gen.start(e.a.seqr);
//        #50;
        phase.drop_objection(this);
    endtask
    
    virtual function void end_of_elaboration_phase(uvm_phase phase); 
        uvm_phase run_phase;                                            // Here the run_phase is to be assigned the drain time
        super.end_of_elaboration_phase(phase);
        run_phase = phase.find_by_name("run", 0);                      // First find by name and assign it to run_phase
        run_phase.phase_done.set_drain_time(this, 10);    // "this" is to mention the scope of the class        // Run the methods phase_done followed by set_drain_time on the run_phase container
    endfunction
    
    

endclass
//////////////////////////////////////////////////////////////
    
    add_if aif();
    
    adder_combinational dut(.a(aif.a), .b(aif.b), .y(aif.y));
    
    initial begin
    uvm_config_db #(virtual add_if)::set(null, "uvm_test_top.e.a*", "aif", aif);
    run_test("test");
    end
    
endmodule



