`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_int_prac();
  typedef enum bit [1:0] { RST, ADD, SUB } operation;

  // Configuration class
  class config_adder extends uvm_object;
    `uvm_object_utils(config_adder)
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    
    function new(string name = "config_adder");
      super.new(name);
    endfunction
  endclass

  // Transaction class
  class transaction extends uvm_sequence_item;
    `uvm_object_utils(transaction)
    
    bit rst;
    rand bit [4:0] a, b;
    rand operation op;
    bit func; // 0 for add, 1 for subtract
    bit done;
    logic [7:0] res;
    
    constraint input_c { a < 10; b < 10; }
    constraint op_c { op inside {RST, ADD, SUB}; }
    
    function new(string name = "transaction");
      super.new(name);
    endfunction
    
    function void post_randomize();
      func = (op == SUB) ? 1 : 0;
    endfunction
  endclass

  // Reset sequence
  class rst_seq extends uvm_sequence#(transaction);
    `uvm_object_utils(rst_seq)
    transaction tr;
    
    function new(string name = "rst_seq");
      super.new(name);
    endfunction
    
    task body();
      repeat(10) begin
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize() with { op == RST; });
        tr.reset = 1;
        finish_item(tr);
        `uvm_info("RST_SEQ", $sformatf("a=%0d, b=%0d, reset=%0b", tr.a, tr.b, tr.reset), UVM_LOW)
      end
    endtask
  endclass

  // Add sequence
  class add_seq extends uvm_sequence#(transaction);
    `uvm_object_utils(add_seq)
    transaction tr;
    
    function new(string name = "add_seq");
      super.new(name);
    endfunction
    
    task body();
      repeat(10) begin
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize() with { op == ADD; });
        finish_item(tr);
        `uvm_info("ADD_SEQ", $sformatf("a=%0d, b=%0d, func=%0b", tr.a, tr.b, tr.func), UVM_LOW)
      end
    endtask
  endclass

  // Subtract sequence
  class sub_seq extends uvm_sequence#(transaction);
    `uvm_object_utils(sub_seq)
    transaction tr;
    
    function new(string name = "sub_seq");
      super.new(name);
    endfunction
    
    task body();
      repeat(10) begin
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize() with { op == SUB; });
        finish_item(tr);
        `uvm_info("SUB_SEQ", $sformatf("a=%0d, b=%0d, func=%0b", tr.a, tr.b, tr.func), UVM_LOW)
      end
    endtask
  endclass

  // Driver
  class driver extends uvm_driver#(transaction);
    `uvm_component_utils(driver)
    virtual int_prac_if dif;
    transaction tr;
    
    function new(string name = "driver", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual int_prac_if)::get(this, "", "dif", dif))
        `uvm_fatal("DRV", "Failed to get interface")
    endfunction
    
    task rst();
      @(posedge dif.clk);
      dif.rst <= 1;
      dif.a <= tr.a;
      dif.b <= tr.b;
      dif.func <= tr.func;
      repeat(3) @(posedge dif.clk);
      dif.rst <= 0;
    endtask
    
    task add();
      @(posedge dif.clk);
      dif.rst <= 0;
      dif.a <= tr.a;
      dif.b <= tr.b;
      dif.func <= 0;
      @(posedge dif.done);
    endtask
    
    task sub();
      @(posedge dif.clk);
      dif.rst <= 0;
      dif.a <= tr.a;
      dif.b <= tr.b;
      dif.func <= 1;
      @(posedge dif.done);
    endtask
    
    task run_phase(uvm_phase phase);
      forever begin
        seq_item_port.get_next_item(tr);
        case (tr.op)
          RST: rst();
          ADD: add();
          SUB: sub();
        endcase
        seq_item_port.item_done();
      end
    endtask
  endclass

  // Monitor
  class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    virtual int_prac_if dif;
    uvm_analysis_port #(transaction) send;
    transaction tr;
    
    function new(string name = "monitor", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      tr = transaction::type_id::create("tr");
      send = new("send", this);
      if (!uvm_config_db#(virtual int_prac_if)::get(this, "", "dif", dif))
        `uvm_fatal("MON", "Failed to get interface")
    endfunction
    
    task run_phase(uvm_phase phase);
      forever begin
        @(posedge dif.clk);
        if (dif.rst) begin
          tr.op = RST;
          tr.reset = 1;
          tr.done = 0;
          `uvm_info("MON", "Reset detected", UVM_LOW)
          send.write(tr);
        end else begin
          @(posedge dif.done);
          tr.a = dif.a;
          tr.b = dif.b;
          tr.func = dif.func;
          tr.res = dif.res;
          tr.done = 1;
          tr.op = (dif.func == 0) ? ADD : SUB;
          `uvm_info("MON", $sformatf("Op=%s, a=%0d, b=%0d, res=%0d, done=%0b", tr.op.name(), tr.a, tr.b, tr.res, tr.done), UVM_LOW)
          send.write(tr);
        end
      end
    endtask
  endclass

  // Scoreboard
  class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    uvm_analysis_imp#(transaction, scoreboard) recv;
    
    function new(string name = "scoreboard", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      recv = new("recv", this);
    endfunction
    
    function void write(transaction tr);
      logic [7:0] exp_res;
      if (tr.op == RST) begin
        exp_res = 0;
        if (tr.res === exp_res)
          `uvm_info("SCO", "Reset: PASS", UVM_LOW)
        else
          `uvm_error("SCO", $sformatf("Reset: FAIL, res=%0d, expected=%0d", tr.res, exp_res))
      end else if (tr.op == ADD) begin
        exp_res = tr.a + tr.b;
        if (tr.res === exp_res && tr.done)
          `uvm_info("SCO", $sformatf("Add: PASS, a=%0d, b=%0d, res=%0d", tr.a, tr.b, tr.res), UVM_LOW)
        else
          `uvm_error("SCO", $sformatf("Add: FAIL, a=%0d, b=%0d, res=%0d, expected=%0d, done=%0b", tr.a, tr.b, tr.res, exp_res, tr.done))
      end else if (tr.op == SUB) begin
        exp_res = tr.a - tr.b;
        if (tr.res === exp_res && tr.done)
          `uvm_info("SCO", $sformatf("Sub: PASS, a=%0d, b=%0d, res=%0d", tr.a, tr.b, tr.res), UVM_LOW)
        else
          `uvm_error("SCO", $sformatf("Sub: FAIL, a=%0d, b=%0d, res=%0d, expected=%0d, done=%0b", tr.a, tr.b, tr.res, exp_res, tr.done))
      end
    endfunction
  endclass

  // Agent
  class agent extends uvm_agent;
    `uvm_component_utils(agent)
    config_adder cfg;
    uvm_sequencer#(transaction) seqr;
    driver d;
    monitor m;
    
    function new(string name = "agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      cfg = config_adder::type_id::create("cfg");
      m = monitor::type_id::create("m", this);
      if (cfg.is_active == UVM_ACTIVE) begin
        seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
        d = driver::type_id::create("d", this);
      end
    endfunction
    
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (cfg.is_active == UVM_ACTIVE)
        d.seq_item_port.connect(seqr.seq_item_export);
    endfunction
  endclass

  // Environment
  class env extends uvm_env;
    `uvm_component_utils(env)
    agent a;
    scoreboard s;
    
    function new(string name = "env", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      a = agent::type_id::create("a", this);
      s = scoreboard::type_id::create("s", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      a.m.send.connect(s.recv);
    endfunction
  endclass

  // Test
  class test extends uvm_test;
    `uvm_component_utils(test)
    env e;
    rst_seq rs;
    add_seq as;
    sub_seq ss;
    
    function new(string name = "test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      e = env::type_id::create("e", this);
      rs = rst_seq::type_id::create("rs");
      as = add_seq::type_id::create("as");
      ss = sub_seq::type_id::create("ss");
    endfunction
    
    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      rs.start(e.a.seqr);
      #10;
      as.start(e.a.seqr);
      #10;
      ss.start(e.a.seqr);
      #10;
      phase.drop_objection(this);
    endtask
  endclass

  // Interface and DUT instantiation
  int_prac_if dif();
  int_prac dut(.clk(dif.clk), .rst(dif.rst), .a(dif.a), .b(dif.b), .func(dif.func), .res(dif.res), .done(dif.done));
  
  initial begin
    dif.clk = 0;
    dif.rst = 1;
    #10;
    dif.rst = 0;
  end
  
  always #5 dif.clk = ~dif.clk;
  
  initial begin
    uvm_config_db#(virtual int_prac_if)::set(null, "*", "dif", dif);
    run_test("test");
  end
endmodule