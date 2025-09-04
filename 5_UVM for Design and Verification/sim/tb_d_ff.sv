`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2024 08:55:24 AM
// Design Name: 
// Module Name: tb_d_ff
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

module tb_d_ff();

class transaction extends uvm_sequence_item;
    rand bit din;
    bit dout;
    
    function new(input string path = "transaction");
    super.new(path);
    endfunction
    
    `uvm_object_utils_begin(transaction)
    `uvm_field_int(din, UVM_DEFAULT)
    `uvm_field_int(dout, UVM_DEFAULT)
    `uvm_object_utils_end

endclass

class generator extends uvm_sequence#(transaction);
`uvm_object_utils(generator)
    
    transaction t;
    integer count;
    
    function new(input string path = "generator");
    super.new(path);
    endfunction
    
    virtual task body();
        t = transaction::type_id::create("t");
    
        repeat(10) begin
            start_item(t);
            t.randomize();
            `uvm_info("GEN", $sformatf("Data send to Driver -> din :%0d", t.din), UVM_NONE);
            finish_item(t);    
        end
    endtask

endclass

class driver extends uvm_driver#(transaction);
`uvm_component_utils(driver)

    transaction tc;
    virtual d_ff_if dif;
    
    function new(input string path = "driver", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        tc = transaction::type_id::create("tc");
        if(!uvm_config_db #(virtual d_ff_if)::get(this, "", "dif", dif))
            `uvm_error("DRV", "Unable to access uvm_config_db");
    endfunction
    
    virtual task reset_phase(uvm_phase phase);
        dif.rst <= 1'b1;
        dif.din <= 0;
        repeat(5) @(posedge dif.clk);
        dif.rst <= 1'b0;
        `uvm_info("DRV", "Reset Done", UVM_NONE);
    endtask
    
    virtual task main_phase(uvm_phase phase);
        @(negedge dif.rst) 
        forever begin
            seq_item_port.get_next_item(tc);
            dif.din <= tc.din;
            seq_item_port.item_done();
            `uvm_info("DRV", $sformatf("Trigger DUT -> din: %0d",tc.din), UVM_NONE);
            repeat(2) @(posedge dif.clk);
        end
    endtask
    
endclass

class monitor extends uvm_monitor;
`uvm_component_utils(monitor)

    transaction t;
    virtual d_ff_if dif;
    uvm_analysis_port #(transaction)  ms_send;
    
    function new(input string path = "monitor", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        t = transaction::type_id::create("t");
        ms_send = new("ms_send", this);
        if(!uvm_config_db#(virtual d_ff_if)::get(this, "", "dif", dif))
            `uvm_error("MON", "Unable to access uvm_config_db"); 
    endfunction
    
    virtual task main_phase(uvm_phase phase);
        @(negedge dif.rst)
        forever begin
            repeat(2) @(posedge dif.clk);
            t.din = dif.din;
            t.dout = dif.dout;
            `uvm_info("MON", $sformatf("Data sent to Scoreboard -> t.din: %0d, t.dout: %0d",t.din, t.dout), UVM_NONE);
            ms_send.write(t);
        end
    endtask
endclass

class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)

    transaction tc;
    uvm_analysis_imp #(transaction, scoreboard)  ms_recv;
    
    function new(input string path = "scoreboard", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tc = transaction::type_id::create("tc");
    ms_recv = new("ms_recv", this);
    endfunction 
    
    virtual function void write(transaction t);
    tc = t;
    `uvm_info("SCO", $sformatf("Data rcvd from monitor -> din: %0d, dout: %0d", tc.din, tc.dout), UVM_NONE);
    if(tc.din == tc.dout)
        `uvm_info("SCO","DATA MATCHED", UVM_NONE)
    else
         `uvm_info("SCO","NOT A MATCH", UVM_NONE);
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
    
    scoreboard s;
    agent a;
    
    function new(input string path = "env", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    s = scoreboard::type_id::create("s", this);
    a = agent::type_id::create("a", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a.m.ms_send.connect(s.ms_recv);
    endfunction

endclass

class test extends uvm_test;
`uvm_component_utils(test)
    
    generator gen;
    env e;

    function new(input string path = "test", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gen = generator::type_id::create("gen");
    e = env::type_id::create("e", this);
    endfunction
    
    virtual task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    gen.start(e.a.seqr);
    phase.drop_objection(this);
    endtask
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_phase main_phase;
    super.end_of_elaboration_phase(phase);
    main_phase = phase.find_by_name("main", 0);
    main_phase.phase_done.set_drain_time(this, 20);
    endfunction

endclass

    d_ff_if dif();
    initial begin
    dif.clk = 0;
    dif.rst = 0;
    end
    
    always #10 dif.clk = ~dif.clk;
    
    d_ff dut(.clk(dif.clk), .rst(dif.rst), .din(dif.din), .dout(dif.dout));
    
    initial begin
    uvm_config_db #(virtual d_ff_if)::set(null, "*", "dif", dif);
    run_test("test");
    end
    

endmodule
