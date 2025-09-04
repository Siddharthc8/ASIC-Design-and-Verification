`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2025 10:44:28 AM
// Design Name: 
// Module Name: tb_og_template
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

module tb_int_prac();

typedef enum bit [1:0] { RST, ADD, SUB, MUL } operation;

class config_dff extends uvm_object;
`uvm_object_utils(config_dff)

    uvm_active_passive_enum agent_type = UVM_ACTIVE;
    
    function new(input string path = "config_dff");
        super.new(path);
    endfunction 
    
endclass

class transaction extends uvm_sequence_item;
`uvm_object_utils(transaction)

    function new(input string path = "transaction");
        super.new(path);
    endfunction
    
    bit reset;
    rand bit [4:0] a;
    rand bit [4:0] b;
    rand bit [4:0] c;
    bit func;
    rand operation op;
    bit done;
    logic [7:0] res;
    
    constraint m1 { a < 10;}
    

endclass

class rst_seq extends uvm_sequence#(transaction);
`uvm_object_utils(rst_seq)

    transaction tr;
    int j =10;
    
    function new(input string path = "rst_seq");
        super.new(path);
    endfunction
    
    virtual task body();
    repeat(j) begin         
        tr = transaction::type_id::create("tr");
        m1.constraint_mode(0);
        start_item(tr);
        assert(tr.randomize());
        tr.op = RST;
        finish_item(tr);
        `uvm_info("rst_seq", $sformat("a: %0d",tr.a), UVM_NONE);
    end
    endtask

class add_seq extends uvm_sequence#(transaction);
`uvm_object_utils(add_seq)

    transaction tr;
    
    function new(input string path = "add_seq");
        super.new(path);
    endfunction
    
    virtual task body();
    repeat(10) begin         
        tr = transaction::type_id::create("tr");
        m1.constraint_mode(0);
        start_item(tr);
        assert(tr.randomize());
        tr.op = ADD;
        finish_item(tr);
        `uvm_info("add_seq", $sformat("a: %0d",tr.a), UVM_NONE);
    end
    endtask


endclass

class sub_seq extends uvm_sequence#(transaction);
`uvm_object_utils(sub_seq)

    transaction tr;
    
    function new(input string path = "sub_seq");
        super.new(path);
    endfunction
    
    virtual task body();
    repeat(10) begin        
        tr = transaction::type_id::create("tr");
        m1.constraint_mode(0);
        start_item(tr);
        assert(tr.randomize());
        tr.op = ADD;
        finish_item(tr);
        `uvm_info("seq1", $sformat("a: %0d",tr.a), UVM_NONE);
    end
    endtask

endclass


class seq_lib extends uvm_sequence_library#(transaction);
`uvm_object_utils(seq_lib)
`uvm_sequence_library_utils(seq_lib)

    function new(input string path = "seq_lib");
        super.new(path);
    endfunction    
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        add_typewide_sequence(rst_seq::get_type());
        add_typewide_sequence(add_seq::get_type());
        add_typewide_sequence(sub_seq::get_type());
    endfunction
    
    
endclass



class driver extends uvm_driver#(transaction);
`uvm_component_utils(driver)
    
    transaction tr;
    virtual adder_if dif;
    
    function new(input string path = "driver", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    
    if(!uvm_config_db#(virtual adder_if)::get(this, "", "dif", dif))
    `uvm_error("drv", Sformatf("Unable to access interface"));
    endfunction
    
    
    virtual task rst();
        dif.rst <= 1'b1;
        dif.a <= tr.a;
        dif.b <= tr.b;
        dif.c <= tr.c;
        
        repeat(3) @(posedge dif.clk);
        dif.rst <= 1'b0;
    endtask
    
    
    virtual task add();
        dif.rst <= 1'b0;
        dif.a <= tr.a;
        dif.b <= tr.b;
        dif.c <= tr.c;
        dif.func <= 1'b0;
        
        repeat(1) @(posedge dif.done);

    endtask
    
    virtual task sub();
        dif.rst <= 1'b0;
        dif.a <= tr.a;
        dif.b <= tr.b;
        dif.c <= tr.c;
        dif.func <= 1'b1;
        
        repeat(1) @(posedge dif.done);

    endtask

    virtual task run_phase(uvm_phase phase);
    forever begin
    
        seq_item_port.get_next_item(tr);
        
            if(tr.op == RST)begin
                rst();
            end
            
            if(tr.op == ADD)begin
                add();
            end
            
            if(tr.op == SUB)begin
                sub();
            end
         
         seq_item_port.item_done();
    
    end
    endtask
endclass


class monitor extends uvm_monitor;
`uvm_component_utils(monitor)

    virtual adder_if dif;
    uvm_analysis_port #(transaction) send;
    transaction tr;
    
    function new(input string path = "monitor", uvm_component parent = null);
        super.new(path,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    send = new("send", this);
    
    if(!uvm_config_db#(virtual adder_if)::get(this, "", "dif", dif))
    `uvm_error("drv", Sformatf("Unable to access interface"));
    endfunction
    
    virtual task run_phase();
    forever begin
        @(posedge dif.clk);
        
        if(dif.rst) begin
            tr.op = RST;
            `uvm_info("MON", "System reset detected", UVM_NONE);
            send.write(tr);
        end
        
        else if (!dif.rst && dif.addition) begin
            @(posedge dif.done);
            tr.op = ADD;
            tr.res = dif.res;
            tr.a = dif.a;
            tr.b = dif.b;
            tr.c = dif.c;
            `uvm_info("MON", "Addition", UVM_NONE);  
            send.write(tr);      
        end
        
        else if (!dif.rst && dif.subtraction) begin
            @(posedge dif.done);
            tr.op = ADD;
            tr.res = dif.res;
            tr.a = dif.a;
            tr.b = dif.b;
            tr.c = dif.c;
            `uvm_info("MON", "Addition", UVM_NONE);  
            send.write(tr);      
        end
        
    end
    endtask  
    
endclass

class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)
    
    bit [8:0] res = 'b0;
    uvm_analysis_imp#(transaction, scoreboard) recv;
    
    transaction tr_fifo[$];
    
    function new(input string path = "scoreboard", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        recv = new("recv", this);
    endfunction
    
    
    virtual function void write(transaction tr);
        if(tr.op == RST) begin
            `uvm_info("SCO", "SYSTEM RESET DETECTED", UVM_NONE);
        end
        
        else if(tr.op == ADD) begin
            tr.res = tr.a + tr.b;
            tr_fifo.push_back(tr.res);
        end
        
        else if(tr.op == SUB) begin
            tr.res = tr.a - tr.b;
            tr_fifo.push_back(tr.res);
        end
        
        else if(tr.op == MUL) begin
            tr.res = tr.a * tr.b;
        end
    endfunction
    
endclass

class agent extends uvm_agent;
`uvm_component_utils(agent)
    
    config_dff cfg;
    uvm_sequencer#(transaction) seqr;
    driver d;
    monitor m;
    

    function new(input string path = "agent", uvm_component parent = null);
        super.new(path, parent);
    endfunction    
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cfg = config_dff::type_id::create("cfg");
        m = monitor::type_id::create("m",this);
        
        if(cfg.is_active == UVM_ACTIVE) begin
            seqr = uvm_sequence#(transaction)::type_id::create("seqr", this);
            d = driver::type_id::create("d", this);
        end
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
        if(cfg.is_active == UVM_ACTIVE) begin
            d.seq_item_port.connect(seqr.seq_item_export);
        end
    endfunction
    
endclass


class env extends uvm_env;
`uvm_component_utils(environment)
    
    agent a;
    scoreboard s;

    function new(input string path = "environment", uvm_component parent = null);
        super.new(path, parent);
    endfunction 
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        s = scoreboard:: type_id::create("s", this);
        a = agent::type_id::create("a", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        a.m.send.connect(s.recv);
    endfunction
endclass

class test extends uvm_test;
`uvm_component_utils(test);
    function new(input string path = "environment", uvm_component parent = null);
        super.new(path, parent);
    endfunction 
    
    env e;
    add_seq as;
    sub_seq ss;
    rst_seq rs;
    
    virtual function void build_phase(uvm_phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
        as  = add_seq::type_id::create("add_seq");
        ss  = sub_seq::type_id::create("sub_seq");
        rs = rst_seq::type_id::create("rst_seq");
        
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        as.start(e.a.seqr);
        ss.start(e.a.seqr);
        rs.start(e.a.seqr);
        phase.raise_objection(this);
        
    endtask
    
endclass

//    int_pracc_if dif();
//    int_pracc dut();
    
//    initial begin
//        dif.clk <= 0;
//    end
    
//    always #5 dif.clk <= ~dif.clk;
    
//    initial begin
//        uvm_config_db#(virtual adder_if)::set(null, "uvm_test_top", "dif", dif); 
//        run_test("test");
//    end    

endmodule