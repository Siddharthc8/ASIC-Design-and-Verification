`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2024 06:07:58 PM
// Design Name: 
// Module Name: tb_mux_4x1
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

module tb_mux_4x1();

class transaction extends uvm_sequence_item;
    
    rand bit [3:0] a; 
    rand bit [3:0] b;
    rand bit [3:0] c;
    rand bit [3:0] d;
    rand bit [1:0] sel;
    bit [3:0] y;
    
    function new(input string path = "transaction");
    super.new(path);
    endfunction
    
    `uvm_object_utils_begin(transaction)
    `uvm_field_int(a, UVM_DEFAULT);
    `uvm_field_int(b, UVM_DEFAULT);
    `uvm_field_int(c, UVM_DEFAULT);
    `uvm_field_int(d, UVM_DEFAULT);
    `uvm_field_int(y, UVM_DEFAULT);
    `uvm_field_int(sel, UVM_DEFAULT);
    `uvm_object_utils_end
    
endclass

class generator extends uvm_sequence#(transaction);
`uvm_object_utils(generator)
    
    transaction t;
    int count = 0;
    
    function new(input string path = "generator");
    super.new(path);
    endfunction
    
    virtual task body();
        t = transaction::type_id::create("t");
        repeat(count) 
        begin
            start_item(t);
            t.randomize();
            finish_item(t);
            `uvm_info("GEN",$sformatf("Data send to Driver: sel :%0d, a :%0d , b :%0d, c: %0d, d :%0d",t.sel, t.a,t.b, t.c, t.d), UVM_NONE);  
        end
    endtask
    
endclass

class driver extends uvm_driver#(transaction);
`uvm_component_utils(driver)

    transaction tc;
    virtual mux_if mif;
    
    function new(input string path = "driver", uvm_component parent = null);
    super.new(path, parent);
    endfunction 
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tc = transaction::type_id::create("tc");
    if(!uvm_config_db#(virtual mux_if)::get(this,"","mif", mif))
    `uvm_error("DRV", "Unable to access uvm_config_db");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(tc);
            mif.a <= tc.a;
            mif.b <= tc.b;
            mif.c <= tc.c;
            mif.d <= tc.d;
            mif.sel <= tc.sel;
            `uvm_info("DRV", $sformatf("Trigger DUT: sel :%0d, a :%0d , b :%0d, c: %0d, d :%0d", tc.sel, tc.a, tc.b, tc.c, tc.d), UVM_NONE);
            seq_item_port.item_done();
            #10;            
        end
    endtask

endclass

class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
    
    transaction t;
    virtual mux_if mif;
    uvm_analysis_port #(transaction) send;
    
    function new(input string path = "monitor", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t = transaction::type_id::create("t");
    send = new("send", this);
    if(!uvm_config_db#(virtual mux_if)::get(this,"","mif", mif))
    `uvm_error("MON", "Unable to access uvm_config_db");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            #10;
            t.a =  mif.a;
            t.b =  mif.b;
            t.c =  mif.c;
            t.d =  mif.d;
            t.y =  mif.y;
            t.sel =  mif.sel;
            `uvm_info("MON", $sformatf("Data sent to scoreboard: sel :%0d, a :%0d , b :%0d, c: %0d, d :%0d, y: %0d",t.sel, t.a, t.b, t.c, t.d, t.y), UVM_NONE);
            send.write(t);
        end
    endtask

endclass

class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)

    transaction tr;
    uvm_analysis_imp #(transaction, scoreboard) recv;
    
    function new(input string path = "scoreboard", uvm_component parent = null);
    super.new(path, parent);
    endfunction    
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    recv = new("recv", this);
    endfunction
    
    virtual function void write(input transaction t);
    tr = t;
    `uvm_info("SCO", $sformatf("Data recvd to monitor: sel :%0d, a :%0d , b :%0d, c: %0d, d :%0d, y: %0d",t.sel, t.a, t.b, t.c, t.d, t.y), UVM_NONE);
    if(tr.sel == 2'b00 && tr.y == tr.a)
        `uvm_info("SCO", $sformatf("DATA MATCHED sel: %0d, y = %0d", tr.sel, tr.y), UVM_NONE)
    else if(tr.sel == 2'b01 && tr.y == tr.b)
        `uvm_info("SCO", $sformatf("DATA MATCHED sel: %0d, y = %0d", tr.sel, tr.y), UVM_NONE)
    else if(tr.sel == 2'b10 && tr.y == tr.c)
        `uvm_info("SCO", $sformatf("DATA MATCHED sel: %0d, y = %0d", tr.sel, tr.y), UVM_NONE)
    else if(tr.sel == 2'b11 && tr.y == tr.d)
        `uvm_info("SCO", $sformatf("DATA MATCHED sel: %0d, y = %0d", tr.sel, tr.y), UVM_NONE)
    else 
        `uvm_info("SCO", $sformatf("NOT A MATCH sel: %0d, y = %0d", tr.sel, tr.y), UVM_NONE);
    endfunction
endclass

class agent extends uvm_agent;
`uvm_component_utils(agent)

    function new(input string path = "agent", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    uvm_sequencer #(transaction) seqr;
    driver d;
    monitor m;

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
    a.m.send.connect(s.recv);
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
    gen.count = 10;     
    endfunction
    
    virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    gen.start(e.a.seqr);
    phase.drop_objection(this);
    endtask
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_phase run_phase;
    super.end_of_elaboration_phase(phase);
    run_phase = phase.find_by_name("run", 0);
    run_phase.phase_done.set_drain_time(this, 10);
    endfunction
    
endclass


    mux_if mif();
    
    mux_4x1 dut(.a(mif.a), .b(mif.b), .c(mif.c), .d(mif.d), .sel(mif.sel), .y(mif.y));
    
    initial begin
        uvm_config_db#(virtual mux_if)::set(null, "*", "mif", mif);
        run_test("test");
    end

endmodule
