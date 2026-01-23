`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2025 09:07:23 PM
// Design Name: 
// Module Name: tb_int_pracc
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

module tb_int_pracc();
  typedef enum bit [1:0] { RST, ADD, SUB, NOP } operation;

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
    rand bit valid; // 1: perform operation, 0: no operation
    bit func; // 0: add, 1: subtract
    bit done;
    logic [7:0] res;
    
    constraint input_c { a < 10; b < 10; }
    constraint op_c { op inside {RST, ADD, SUB, NOP}; }
    constraint valid_c { (op == ADD || op == SUB) -> valid == 1; op == NOP -> valid == 0; }
    
    function new(string name = "transaction");
      super.new(name);
    endfunction
    
    function void post_randomize();
      func = (op == SUB) ? 1 : 0;
      rst = (op == RST) ? 1 : 0;
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
        assert(tr.randomize() with { op == RST; valid == 0; });
        finish_item(tr);
        `uvm_info("RST_SEQ", $sformatf("a=%0d, b=%0d, reset=%0b, valid=%0b", tr.a, tr.b, tr.reset, tr.valid), UVM_LOW)
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
        assert(tr.randomize() with { op == ADD; valid == 1; });
        finish_item(tr);
        `uvm_info("ADD_SEQ", $sformatf("a=%0d, b=%0d, func=%0b, valid=%0b", tr.a, tr.b, tr.func, tr.valid), UVM_LOW)
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
        assert(tr.randomize() with { op == SUB; valid == 1; });
        finish_item(tr);
        `uvm_info("SUB_SEQ", $sformatf("a=%0d, b=%0d, func=%0b, valid=%0b", tr.a, tr.b, tr.func, tr.valid), UVM_LOW)
      end
    endtask
  endclass

  // No-op sequence
  class nop_seq extends uvm_sequence#(transaction);
    `uvm_object_utils(nop_seq)
    transaction tr;
    
    function new(string name = "nop_seq");
      super.new(name);
    endfunction
    
    task body();
      repeat(10) begin
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize() with { op == NOP; valid == 0; });
        finish_item(tr);
        `uvm_info("NOP_SEQ", $sformatf("a=%0d, b=%0d, valid=%0b", tr.a, tr.b, tr.valid), UVM_LOW)
      end
    endtask
  endclass

  // Driver
  class driver extends uvm_driver#(transaction);
    `uvm_component_utils(driver)
    virtual int_pracc_if iif;
    transaction tr;
    
    function new(string name = "driver", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual int_pracc_if)::get(this, "", "iif", iif))
        `uvm_fatal("DRV", "Failed to get interface")
    endfunction
    
    task rst();
      @(posedge iif.clk);
      iif.rst <= 1;
      iif.a <= tr.a;
      iif.b <= tr.b;
      iif.func <= tr.func;
      iif.valid <= tr.valid;
      repeat(3) @(posedge iif.clk);
      iif.rst <= 0;
    endtask
    
    task add();
      @(posedge iif.clk);
      iif.rst <= 0;
      iif.a <= tr.a;
      iif.b <= tr.b;
      iif.func <= 0;
      iif.valid <= 1;
      @(posedge iif.done);
    endtask
    
    task sub();
      @(posedge iif.clk);
      iif.rst <= 0;
      iif.a <= tr.a;
      iif.b <= tr.b;
      iif.func <= 1;
      iif.valid <= 1;
      @(posedge iif.done);
    endtask
    
    task nop();
      @(posedge iif.clk);
      iif.rst <= 0;
      iif.a <= tr.a;
      iif.b <= tr.b;
      iif.func <= tr.func;
      iif.valid <= 0;
      @(posedge iif.clk); // Wait one cycle for no-op
    endtask
    
    task run_phase(uvm_phase phase);
      forever begin
        seq_item_port.get_next_item(tr);
        case (tr.op)
          RST: rst();
          ADD: add();
          SUB: sub();
          NOP: nop();
        endcase
        seq_item_port.item_done();
      end
    endtask
  endclass

  // Monitor
  class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    virtual int_pracc_if iif;
    uvm_analysis_port #(transaction) send;
    transaction tr;
    
    function new(string name = "monitor", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      tr = transaction::type_id::create("tr");
      send = new("send", this);
      if (!uvm_config_db#(virtual int_pracc_if)::get(this, "", "iif", iif))
        `uvm_fatal("MON", "Failed to get interface")
    endfunction
    
    task run_phase(uvm_phase phase);
      forever begin
        @(posedge iif.clk);
        tr = transaction::type_id::create("tr");
        if (iif.rst) begin
          tr.op = RST;
          tr.reset = 1;
          tr.valid = iif.valid;
          tr.done = iif.done;
          tr.res = iif.res;
          `uvm_info("MON", $sformatf("Reset detected: res=%0d, done=%0b", tr.res, tr.done), UVM_LOW)
          send.write(tr);
        end else if (iif.valid && iif.done) begin
          tr.a = iif.a;
          tr.b = iif.b;
          tr.func = iif.func;
          tr.valid = iif.valid;
          tr.res = iif.res;
          tr.done = iif.done;
          tr.op = (iif.func == 0) ? ADD : SUB;
          `uvm_info("MON", $sformatf("Op=%s, a=%0d, b=%0d, res=%0d, valid=%0b, done=%0b", tr.op.name(), tr.a, tr.b, tr.res, tr.valid, tr.done), UVM_LOW)
          send.write(tr);
        end else if (!iif.valid) begin
          tr.op = NOP;
          tr.a = iif.a;
          tr.b = iif.b;
          tr.func = iif.func;
          tr.valid = iif.valid;
          tr.res = iif.res;
          tr.done = iif.done;
          `uvm_info("MON", $sformatf("No-op: valid=%0b, res=%0d, done=%0b", tr.valid, tr.res, tr.done), UVM_LOW)
          send.write(tr);
        end
      end
    endtask
  endclass

  // Scoreboard
  class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    uvm_analysis_imp#(transaction, scoreboard) recv;
    logic [7:0] prev_res; // Track previous result for no-op
    bit first_trans; // Flag for first transaction
    
    function new(string name = "scoreboard", uvm_component parent = null);
      super.new(name, parent);
      first_trans = 1;
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      recv = new("recv", this);
    endfunction
    
    function void write(transaction tr);
      logic [7:0] exp_res;
      if (tr.op == RST) begin
        exp_res = 0;
        if (tr.res === exp_res && !tr.done)
          `uvm_info("SCO", "Reset: PASS", UVM_LOW)
        else
          `uvm_error("SCO", $sformatf("Reset: FAIL, res=%0d, expected=%0d, done=%0b", tr.res, exp_res, tr.done))
      end else if (tr.op == ADD) begin
        exp_res = tr.a + tr.b;
        if (tr.res === exp_res && tr.valid && tr.done)
          `uvm_info("SCO", $sformatf("Add: PASS, a=%0d, b=%0d, res=%0d", tr.a, tr.b, tr.res), UVM_LOW)
        else
          `uvm_error("SCO", $sformatf("Add: FAIL, a=%0d, b=%0d, res=%0d, expected=%0d, valid=%0b, done=%0b", tr.a, tr.b, tr.res, exp_res, tr.valid, tr.done))
      end else if (tr.op == SUB) begin
        exp_res = tr.a - tr.b;
        if (tr.res === exp_res && tr.valid && tr.done)
          `uvm_info("SCO", $sformatf("Sub: PASS, a=%0d, b=%0d, res=%0d", tr.a, tr.b, tr.res), UVM_LOW)
        else
          `uvm_error("SCO", $sformatf("Sub: FAIL, a=%0d, b=%0d, res=%0d, expected=%0d, valid=%0b, done=%0b", tr.a, tr.b, tr.res, exp_res, tr.valid, tr.done))
      end else if (tr.op == NOP) begin
        exp_res = first_trans ? 0 : prev_res;
        if (tr.res === exp_res && !tr.done && !tr.valid)
          `uvm_info("SCO", $sformatf("No-op: PASS, res=%0d, prev_res=%0d", tr.res, exp_res), UVM_LOW)
        else
          `uvm_error("SCO", $sformatf("No-op: FAIL, res=%0d, expected=%0d, done=%0b, valid=%0b", tr.res, exp_res, tr.done, tr.valid))
      end
      // Update previous result and first transaction flag
      if (tr.op != NOP || first_trans) begin
        prev_res = tr.res;
        first_trans = 0;
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
    nop_seq ns;
    
    function new(string name = "test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      e = env::type_id::create("e", this);
      rs = rst_seq::type_id::create("rs");
      as = add_seq::type_id::create("as");
      ss = sub_seq::type_id::create("ss");
      ns = nop_seq::type_id::create("ns");
    endfunction
    
    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      rs.start(e.a.seqr);
      #10;
      as.start(e.a.seqr);
      #10;
      ss.start(e.a.seqr);
      #10;
      ns.start(e.a.seqr);
      #10;
      phase.drop_objection(this);
    endtask
  endclass

  // Interface and DUT instantiation
  int_pracc_if iif();
  int_pracc dut (
    .clk(iif.clk),
    .rst(iif.rst),
    .a(iif.a),
    .b(iif.b),
    .func(iif.func),
    .valid(iif.valid),
    .res(iif.res),
    .done(iif.done)
  );
  
  initial begin
    iif.clk = 0;
    iif.rst = 1;
    #10;
    iif.rst = 0;
  end
  
  always #5 iif.clk = ~iif.clk;
  
  initial begin
    uvm_config_db#(virtual int_pracc_if)::set(null, "*", "iif", iif);
    run_test("test");
  end
endmodule