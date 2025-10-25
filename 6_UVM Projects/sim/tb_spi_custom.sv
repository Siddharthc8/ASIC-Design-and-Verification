`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2024 06:14:56 PM
// Design Name: 
// Module Name: tb_spi_native
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
 
 module tb_spi_custom();

////////////////////////////////////////////////////////////////////////////////////
class spi_config extends uvm_object; /////configuration of env
  `uvm_object_utils(spi_config)
  
  function new(string name = "spi_config");
    super.new(name);
  endfunction
  
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  
endclass
 
//////////////////////////////////////////////////////////
 
typedef enum bit [2:0]   {readd = 0, writed = 1, rstdut = 2, writeerr = 3, readerr = 4} oper_mode;
 
 
class transaction extends uvm_sequence_item;
  
    rand oper_mode   op;
         logic wr;
         logic rst;
    randc logic [7:0] addr;
    rand logic [7:0] din;
         logic [7:0] dout; 
         logic done;
         logic err;
  
 
        `uvm_object_utils_begin(transaction)
        `uvm_field_int (wr,UVM_ALL_ON)
        `uvm_field_int (rst,UVM_ALL_ON)
        `uvm_field_int (addr,UVM_ALL_ON)
        `uvm_field_int (din,UVM_ALL_ON)
        `uvm_field_int (dout,UVM_ALL_ON)
        `uvm_field_int (done,UVM_ALL_ON)
        `uvm_field_int (err,UVM_ALL_ON)
        `uvm_field_enum(oper_mode, op, UVM_DEFAULT)
        `uvm_object_utils_end
  
  constraint addr_c { addr <= 10; }
  constraint addr_c_err { addr > 31; }
 
  function new(string name = "transaction");
    super.new(name);
  endfunction
 
endclass : transaction
 
 
///////////////////////////////////////////////////////////////////////
 
 
///////////////////write seq
class write_data extends uvm_sequence#(transaction);
  `uvm_object_utils(write_data)
  
  transaction tr;
 
  function new(string name = "write_data");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr = transaction::type_id::create("tr");
        tr.addr_c.constraint_mode(1);
        tr.addr_c_err.constraint_mode(0);
        start_item(tr);
        assert(tr.randomize);
        tr.op = writed;
        finish_item(tr);
      end
  endtask
  
 
endclass
//////////////////////////////////////////////////////////
 
 
class write_err extends uvm_sequence#(transaction);
  `uvm_object_utils(write_err)
  
  transaction tr;
 
  function new(string name = "write_err");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr = transaction::type_id::create("tr");
        tr.addr_c_err.constraint_mode(1);
        tr.addr_c.constraint_mode(0);
        start_item(tr);
        assert(tr.randomize);
        tr.op = writed;
        finish_item(tr);
      end
  endtask
  
 
endclass
 
///////////////////////////////////////////////////////////////
 
class read_data extends uvm_sequence#(transaction);
  `uvm_object_utils(read_data)
  
  transaction tr;
 
  function new(string name = "read_data");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr = transaction::type_id::create("tr");
        tr.addr_c.constraint_mode(1);
        tr.addr_c_err.constraint_mode(0);
        start_item(tr);
        assert(tr.randomize);
        tr.op = readd;
        finish_item(tr);
      end
  endtask
  
 
endclass
/////////////////////////////////////////////////////////////////////
 
class read_err extends uvm_sequence#(transaction);
  `uvm_object_utils(read_err)
  
  transaction tr;
 
  function new(string name = "read_err");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr = transaction::type_id::create("tr");
        tr.addr_c.constraint_mode(0);
        tr.addr_c_err.constraint_mode(1);
        start_item(tr);
        assert(tr.randomize);
        tr.op = readd;
        finish_item(tr);
      end
  endtask
  
 
endclass
/////////////////////////////////////////////////////////////////
 
class reset_dut extends uvm_sequence#(transaction);
  `uvm_object_utils(reset_dut)
  
  transaction tr;
 
  function new(string name = "reset_dut");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr = transaction::type_id::create("tr");
        tr.addr_c.constraint_mode(1);
        tr.addr_c_err.constraint_mode(0);
        start_item(tr);
        assert(tr.randomize);
        tr.op = rstdut;
        finish_item(tr);
      end
  endtask
  
 
endclass
////////////////////////////////////////////////////////////
 
 
 
class writeb_readb extends uvm_sequence#(transaction);
  `uvm_object_utils(writeb_readb)
  
  transaction tr;
 
  function new(string name = "writeb_readb");
    super.new(name);
  endfunction
  
  virtual task body();
     
    repeat(10)
      begin
        tr = transaction::type_id::create("tr");
        tr.addr_c.constraint_mode(1);
        tr.addr_c_err.constraint_mode(0);
        start_item(tr);
        assert(tr.randomize);
        tr.op = writed;
        finish_item(tr);  
      end
        
    repeat(10)
      begin
        tr = transaction::type_id::create("tr");
        tr.addr_c.constraint_mode(1);
        tr.addr_c_err.constraint_mode(0);
        start_item(tr);
        assert(tr.randomize);
        tr.op = readd;
        finish_item(tr);
      end   
    
  endtask
  
 
endclass
 
 
 
////////////////////////////////////////////////////////////
class driver extends uvm_driver #(transaction);
  `uvm_component_utils(driver)
  
  virtual spi_c vif;
  transaction tr;
  
  
  function new(input string path = "drv", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
 virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     tr = transaction::type_id::create("tr");
      
      if(!uvm_config_db#(virtual spi_c)::get(this,"","vif",vif))//uvm_test_top.env.agent.drv.aif
      `uvm_error("drv","Unable to access Interface");
  endfunction
  
  
  
  task reset_dut();
 
    repeat(5) 
    begin
    vif.rst      <= 1'b1;  ///active high reset
    vif.addr     <= 'h0;
    vif.din      <= 'h0;
    vif.wr       <= 1'b0; 
   `uvm_info("DRV", "System Reset : Start of Simulation", UVM_MEDIUM);
    @(posedge vif.clk);
      end
  endtask
  
  task drive();
    reset_dut();
   forever begin
     
         seq_item_port.get_next_item(tr);
     
     
                   if(tr.op ==  rstdut)
                          begin
                          vif.rst   <= 1'b1;
                          @(posedge vif.clk);  
                          end
 
                  else if(tr.op == writed)
                          begin
					      vif.rst <= 1'b0;
                          vif.wr  <= 1'b1;
                          vif.addr <= tr.addr;
                          vif.din  <= tr.din;
                          @(posedge vif.clk);
                          `uvm_info("DRV", $sformatf("mode : Write addr:%0d din:%0d", vif.addr, vif.din), UVM_NONE);
                          @(posedge vif.done);
                          end
                else if(tr.op ==  readd)
                          begin
					      vif.rst  <= 1'b0;
                          vif.wr   <= 1'b0;
                          vif.addr <= tr.addr;
                          vif.din  <= tr.din;
                          @(posedge vif.clk);
                            `uvm_info("DRV", $sformatf("mode : Read addr:%0d din:%0d", vif.addr, vif.din), UVM_NONE);
                          @(posedge vif.done);
                          end
       seq_item_port.item_done();
     
   end
  endtask
  
 
  virtual task run_phase(uvm_phase phase);
    drive();
  endtask
 
  
endclass
 
//////////////////////////////////////////////////////////////////////////////////////////////
 
class mon extends uvm_monitor;
`uvm_component_utils(mon)
 
uvm_analysis_port#(transaction) send;
transaction tr;
virtual spi_c vif;
 
    function new(input string inst = "mon", uvm_component parent = null);
    super.new(inst,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    send = new("send", this);
      if(!uvm_config_db#(virtual spi_c)::get(this,"","vif",vif))//uvm_test_top.env.agent.drv.aif
        `uvm_error("MON","Unable to access Interface");
    endfunction
    
    
    virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);
      if(vif.rst)
        begin
        tr.op      = rstdut; 
        `uvm_info("MON", "SYSTEM RESET DETECTED", UVM_NONE);
        send.write(tr);
        end
      else if (!vif.rst && vif.wr)
         begin
          @(posedge vif.done);
          tr.op     = writed;
          tr.din    = vif.din;
          tr.addr   = vif.addr;
          tr.err    = vif.err;
          `uvm_info("MON", $sformatf("DATA WRITE addr:%0d data:%0d err:%0d",tr.addr,tr.din,tr.err), UVM_NONE); 
          send.write(tr);
         end
      else if (!vif.rst && !vif.wr)
         begin
          @(posedge vif.done);
          tr.op     = readd; 
          tr.addr   = vif.addr;
          tr.err    = vif.err;
          tr.dout   = vif.dout; 
          `uvm_info("MON", $sformatf("DATA READ addr:%0d data:%0d slverr:%0d",tr.addr,tr.dout,tr.err), UVM_NONE); 
          send.write(tr);
         end
    
    end
   endtask 
 
endclass
//////////////////////////////////////////////////////////////////////////////////////////////////
 
class sco extends uvm_scoreboard;
`uvm_component_utils(sco)
 
  uvm_analysis_imp#(transaction,sco) recv;
  bit [31:0] arr[32] = '{default:0};
  bit [31:0] addr    = 0;
  bit [31:0] data_rd = 0;
 
 
 
    function new(input string inst = "sco", uvm_component parent = null);
    super.new(inst,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv", this);
    endfunction
    
    
  virtual function void write(transaction tr);
    if(tr.op == rstdut)
              begin
                `uvm_info("SCO", "SYSTEM RESET DETECTED", UVM_NONE);
              end  
    else if (tr.op == writed)
      begin
        if(tr.err == 1'b1)
                begin
                  `uvm_info("SCO", "SLV ERROR during WRITE OP", UVM_NONE);
                end
              else
                begin
                arr[tr.addr] = tr.din;
                  `uvm_info("SCO", $sformatf("DATA WRITE OP  addr:%0d, wdata:%0d arr_wr:%0d",tr.addr,tr.din,  arr[tr.addr]), UVM_NONE);
                end
      end
    else if (tr.op == readd)
      begin
          if(tr.err == 1'b1)
                begin
                  `uvm_info("SCO", "SLV ERROR during READ OP", UVM_NONE);
                end
              else 
                begin
                  data_rd = arr[tr.addr];
                  if (data_rd == tr.dout)
                    `uvm_info("SCO", $sformatf("DATA MATCHED : addr:%0d, rdata:%0d",tr.addr,tr.dout), UVM_NONE)
                         else
                     `uvm_info("SCO",$sformatf("TEST FAILED : addr:%0d, rdata:%0d data_rd_arr:%0d",tr.addr,tr.dout,data_rd), UVM_NONE) 
                end
 
      end
     
  
    $display("----------------------------------------------------------------");
    endfunction
 
endclass
 
 
//////////////////////////////////////////////////////////////////////////////////////////////
                  
                  
class agent extends uvm_agent;
`uvm_component_utils(agent)
  
  spi_config cfg;
 
function new(input string inst = "agent", uvm_component parent = null);
super.new(inst,parent);
endfunction
 
 driver d;
 uvm_sequencer#(transaction) seqr;
 mon m;
 
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
   cfg =  spi_config::type_id::create("cfg"); 
   m = mon::type_id::create("m",this);
  
  if(cfg.is_active == UVM_ACTIVE)
   begin   
   d = driver::type_id::create("d",this);
   seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
   end
  
  
endfunction
 
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
  if(cfg.is_active == UVM_ACTIVE) begin  
    d.seq_item_port.connect(seqr.seq_item_export);
  end
endfunction
 
endclass
 
//////////////////////////////////////////////////////////////////////////////////
 
class env extends uvm_env;
`uvm_component_utils(env)
 
function new(input string inst = "env", uvm_component c);
super.new(inst,c);
endfunction
 
agent a;
sco s;
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  a = agent::type_id::create("a",this);
  s = sco::type_id::create("s", this);
endfunction
 
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
 a.m.send.connect(s.recv);
endfunction
 
endclass
 
//////////////////////////////////////////////////////////////////////////
 
class test extends uvm_test;
`uvm_component_utils(test)
 
function new(input string inst = "test", uvm_component c);
super.new(inst,c);
endfunction
 
env e;
write_data wdata;
write_err werr;
  
read_data rdata;
read_err rerr;
  
writeb_readb wrrdb;
 
 
reset_dut rstdut;  
 
  
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
   e      = env::type_id::create("env",this);
   wdata  = write_data::type_id::create("wdata");
   werr   = write_err::type_id::create("werr");
   rdata  = read_data::type_id::create("rdata");
   wrrdb  = writeb_readb::type_id::create("wrrdb");
   rerr   = read_err::type_id::create("rerr");
   rstdut = reset_dut::type_id::create("rstdut");
endfunction
 
virtual task run_phase(uvm_phase phase);
phase.raise_objection(this);
wrrdb.start(e.a.seqr);   
#20;
phase.drop_objection(this);
endtask
endclass
 
//////////////////////////////////////////////////////////////////////
  
  
  spi_c vif();
  
  spi_custom_top dut (.wr(vif.wr), .clk(vif.clk), .rst(vif.rst), .addr(vif.addr), .din(vif.din), .dout(vif.dout), .done(vif.done), .err(vif.err));
  
  initial begin
    vif.clk <= 0;
  end
 
  always #10 vif.clk <= ~vif.clk;
 
  
  
  initial begin
    uvm_config_db#(virtual spi_c)::set(null, "*", "vif", vif);
    run_test("test");
   end
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
 
  
endmodule
