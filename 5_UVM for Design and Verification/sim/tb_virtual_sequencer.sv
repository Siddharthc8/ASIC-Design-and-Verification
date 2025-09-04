`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2024 07:13:43 PM
// Design Name: 
// Module Name: tb_virtual_sequencer
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
 
 module tb_virtual_sequencer();

/////////////////////////////add env
 
 // Transaction for addition 
class add_transaction extends uvm_sequence_item;
  `uvm_object_utils(add_transaction)
  
  rand logic [3:0] add_in1,add_in2;
       logic clk, rst;
       logic [4:0] add_out;
  
  function new(string name = "add_transaction");
    super.new(name);
  endfunction
 
endclass : add_transaction
 
///////////////////////////////////////////////

 // Transaction for multiplication 
class add_sequence extends uvm_sequence#(add_transaction);
  `uvm_object_utils(add_sequence)
  
  add_transaction tr;
 
  function new(string name = "add_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(5)
      begin
        `uvm_do(tr)
      end
  endtask
  
endclass  
//////////////////////////////////////////////////////////////
  
  
  
class add_driver extends uvm_driver #(add_transaction);
  `uvm_component_utils(add_driver)
  
  virtual add_if aif;
  add_transaction tr;
  
  
  function new(input string path = "drv", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
 virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     tr = add_transaction::type_id::create("tr");
      
   if(!uvm_config_db#(virtual add_if)::get(this,"","aif",aif)) 
      `uvm_error("drv","Unable to access Interface");
  endfunction
  
  
  virtual task run_phase(uvm_phase phase);
    forever
     begin
     
            seq_item_port.get(tr);
            `uvm_info("ADD_DRV", $sformatf(" add_in1:%0d add_in2:%0d ",tr.add_in1,tr.add_in2), UVM_NONE);
            aif.rst     <= 1'b0;
            aif.add_in1 <= tr.add_in1;
            aif.add_in2 <= tr.add_in2;
            repeat(3) @(posedge aif.clk);      
    end
  endtask
 
  
endclass
     
 
///////////////////////////////////////////////////////////////
  
 
 class add_mon extends uvm_monitor;
`uvm_component_utils(add_mon)
 
uvm_analysis_port#(add_transaction) send;
add_transaction tr;
virtual add_if aif;
 
    function new(input string inst = "add_mon", uvm_component parent = null);
    super.new(inst,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = add_transaction::type_id::create("tr");
    send = new("send", this);
      if(!uvm_config_db#(virtual add_if)::get(this,"","aif",aif))
        `uvm_error("MON","Unable to access Interface");
    endfunction
    
    
    virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge aif.clk);
      if(aif.rst)
        begin
          tr.rst = 1'b1;
          send.write(tr);
        end
      else
         begin
           @(posedge aif.clk);
           @(posedge aif.clk);
            tr.rst         = 1'b0;
            tr.add_in1     = aif.add_in1;
            tr.add_in2     = aif.add_in2;
            tr.add_out     = aif.add_out;
            send.write(tr);
         end
    
    
    end
   endtask 
 
endclass
 
 
///////////////////////////////////////////////////////////////////////////////////////////
 
      
 ///////////////////////////////////////////////////////////////////////////////
 class add_agent extends uvm_agent;
`uvm_component_utils(add_agent)
  
 
 
function new(input string inst = "add_agent", uvm_component parent = null);
super.new(inst,parent);
endfunction
 
   add_driver d;
   uvm_sequencer #(add_transaction) a_seqr;
   add_mon m;
 
 
virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   m = add_mon::type_id::create("m",this);
   d = add_driver::type_id::create("d",this);
   a_seqr = uvm_sequencer #(add_transaction)::type_id::create("a_seqr", this);
 
endfunction
 
virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase); 
  d.seq_item_port.connect(a_seqr.seq_item_export);
endfunction
 
endclass 
  
//////////////////////////////////////////////////////////////////////////////////     
     
 
/////////////////////////////////////completion of adder env
 
 
 
 
 
 
/////////////////////////////add env
 
class mul_transaction extends uvm_sequence_item;
  `uvm_object_utils(mul_transaction)
  
  rand logic [3:0] mul_in1,mul_in2;
       logic clk, rst;
  logic [7:0] mul_out;
  
  function new(string name = "mul_transaction");
    super.new(name);
  endfunction
 
endclass : mul_transaction
 
///////////////////////////////////////////////
 
class mul_sequence extends uvm_sequence#(mul_transaction);
  `uvm_object_utils(mul_sequence)
  
  mul_transaction tr;
 
  function new(string name = "mul_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(5)
      begin
        `uvm_do(tr)
      end
  endtask
  
endclass  
//////////////////////////////////////////////////////////////
  
  
  
class mul_driver extends uvm_driver #(mul_transaction);
  `uvm_component_utils(mul_driver)
  
  virtual mul_if mif;
  mul_transaction tr;
  
  
  function new(input string path = "mul_driver", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
 virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     tr = mul_transaction::type_id::create("tr");
      
   if(!uvm_config_db#(virtual mul_if)::get(this,"","mif",mif)) 
     `uvm_error("mul_driver","Unable to access Interface");
  endfunction
  
  
 
  
  
  virtual task run_phase(uvm_phase phase);
       forever
          begin
     
            seq_item_port.get(tr);            
           `uvm_info("MUL_DRV", $sformatf(" mul_in1:%0d mul_in2:%0d ",tr.mul_in1,tr.mul_in2), UVM_NONE);
            mif.rst     <= 1'b0;
            mif.mul_in1 <= tr.mul_in1;
            mif.mul_in2 <= tr.mul_in2;
            repeat(3) @(posedge mif.clk);
        end
  endtask
 
  
endclass
     
//////////////////////////////////////////////////////////////////////////////   
     
///////////////////////////////////////////////////////////////
 
 class mul_mon extends uvm_monitor;
`uvm_component_utils(mul_mon)
 
uvm_analysis_port#(mul_transaction) send;
mul_transaction tr;
virtual mul_if mif;
 
    function new(input string inst = "mul_mon", uvm_component parent = null);
    super.new(inst,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = mul_transaction::type_id::create("tr");
    send = new("send", this);
      if(!uvm_config_db#(virtual mul_if)::get(this,"","mif",mif))//uvm_test_top.env.agent.drv.aif
        `uvm_error("MUL_MON","Unable to access Interface");
    endfunction
    
    
    virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge mif.clk);
      if(mif.rst)
        begin
          tr.rst = 1'b1;
          send.write(tr);
        end
      else
         begin
           @(posedge mif.clk);
           @(posedge mif.clk);
            tr.rst         = 1'b0;
            tr.mul_in1     = mif.mul_in1;
            tr.mul_in2     = mif.mul_in2;
            tr.mul_out     = mif.mul_out;
            send.write(tr);
         end
    
    
    end
   endtask 
 
endclass
/////////////////////////////////////////////////////////////////////////////////////////////
 
 class mul_agent extends uvm_agent;
`uvm_component_utils(mul_agent)
  
 
 
function new(input string inst = "mul_agent", uvm_component parent = null);
super.new(inst,parent);
endfunction
 
   mul_driver d;
   uvm_sequencer #(mul_transaction) m_seqr;
   mul_mon m; 
 
 
 
virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   m = mul_mon::type_id::create("m",this);
   d = mul_driver::type_id::create("d",this);
   m_seqr =  uvm_sequencer #(mul_transaction)::type_id::create("m_seqr", this);
 
endfunction
 
virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase); 
  d.seq_item_port.connect(m_seqr.seq_item_export);
endfunction
 
endclass 
 
///////////////////////////////////////////////////////////////////////////////////////////
    
    // Since both the add and mul both have write methods, 
    // we are using _add macro that points to add and _mul points to mul 
    
    `uvm_analysis_imp_decl(_add)                    // Works for uvm_analysis write method port
    `uvm_analysis_imp_decl(_mul)     
    
    
    
    
 class sco extends uvm_scoreboard;
`uvm_component_utils(sco)
 
   uvm_analysis_imp_add#(add_transaction,sco) recva;
   uvm_analysis_imp_mul#(mul_transaction,sco) recvm;
   
   add_transaction atr;
   mul_transaction mtr;
   
 
 
 
    function new(input string inst = "mul_sco", uvm_component parent = null);
    super.new(inst,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      recva = new("recva", this);
      recvm = new("recvm", this);
      
      atr = add_transaction::type_id::create("atr");
      mtr = mul_transaction::type_id::create("mtr");
    endfunction
    
    
    virtual function void write_mul(mul_transaction tr);
      mtr = tr;
            if (mtr.mul_in1 >= 0 && mtr.mul_in2 >= 0)
            begin
              if(mtr.mul_out == mtr.mul_in1 * mtr.mul_in2)
                `uvm_info("MUL_SCO", $sformatf("TEST PASSED : MOUT:%0d MIN1:%0d MIN2:%0d",mtr.mul_out, mtr.mul_in1, mtr.mul_in2), UVM_NONE)
             else
               `uvm_info("MUL_SCO", $sformatf("TEST FAILED : MOUT:%0d MIN1:%0d MIN2:%0d",mtr.mul_out, mtr.mul_in1, mtr.mul_in2), UVM_NONE) 
            end  
               else
                  return;
    endfunction
   
   
    virtual function void write_add(add_transaction tr);
         atr = tr;
         if(atr.add_in1 >= 0 && atr.add_in2 >= 0)
               begin
                 if(atr.add_out == atr.add_in1 + atr.add_in2)
                   `uvm_info("ADD_SCO", $sformatf("TEST PASSED : AOUT:%0d AIN1:%0d AIN2:%0d",atr.add_out, atr.add_in1, atr.add_in2), UVM_NONE)
                 else
                       `uvm_error("ADD_SCO" , "TEST FAILED") 
               end
         else 
              return;
                       
    endfunction
 
 
 
endclass  
 
       
////////////////////////////////////////////////////////////////////  
    
  
 
  
//////////////////////////////////////////////////////////////////////////////////    
//////////////////////////////////////////////////////////////////////////////////
    
 
    
 
    
  class vsequencer extends uvm_sequencer;
   `uvm_component_utils(vsequencer)
 
    uvm_sequencer #(add_transaction) VA;
    uvm_sequencer #(mul_transaction) VM;
    
 
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
 
endclass
  
  ////////////////////////////////////////////////////////////////////////////
 
 
class top_vseq_base extends uvm_sequence #(uvm_sequence_item);
`uvm_object_utils(top_vseq_base)
 
   // uvm_sequencer #(add_transaction) GA;
   // uvm_sequencer #(mul_transaction) GM;
  
    vsequencer vseqr;
 
 
 
 
function new(string name = "top_vseq_base");
  super.new(name);
endfunction
  
  
task body();  
 
  if(!$cast(vseqr, m_sequencer)) begin
    `uvm_error(get_full_name(), "Virtual sequencer pointer cast failed");
  end 
  
  //Handle assignment for virtual sequence's sub-sequencers
//  GA = vseqr.VA;
//  GM = vseqr.VM;
  
  
endtask: body
 
  
endclass: top_vseq_base
 
 
///////////////////////////////////////////////////////////////////////////
      
 class add_gen extends top_vseq_base;
   `uvm_object_utils(add_gen)
   
   
     add_sequence aseq;
   
 
   function new(string name="add_gen");
        super.new(name);
    endfunction
 
 
    virtual task body();
      aseq =  add_sequence::type_id::create("aseq");
      super.body();
      aseq.start(vseqr.VA);
    endtask
  
   
endclass       
      
      
          
/////////////////////////////////////////////////////////////////////////////      
     
 class mul_gen extends top_vseq_base;
   `uvm_object_utils(mul_gen)
   
 
     mul_sequence mseq;
   
 
    function new(string name="mul_gen");
        super.new(name);
    endfunction
  
 
    virtual task body();
      mseq =  mul_sequence::type_id::create("mseq");
      super.body();
      mseq.start(vseqr.VM);
    endtask
   
endclass    
     
 ///////////////////////////////////////////////////////////////////   
      
 
                
///////////////////////////////////////////////////////////////////
                 
class env extends uvm_env;
`uvm_component_utils(env)
 
function new(input string inst = "env", uvm_component c);
super.new(inst,c);
endfunction
 
  add_agent   aa;
  mul_agent   ma;
  vsequencer  vseqr;
  sco s;
  
  
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  aa = add_agent::type_id::create("aa",this);
  ma = mul_agent::type_id::create("ma", this);
  vseqr = vsequencer::type_id::create("vseqr", this);
  s   = sco::type_id::create("s", this);
  
endfunction
 
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    vseqr.VA = aa.a_seqr;
    vseqr.VM = ma.m_seqr;
    
    aa.m.send.connect(s.recva);
    ma.m.send.connect(s.recvm);
endfunction: connect_phase
  
  
endclass                 
                 
 /////////////////////////////////////////////////////                
                 
class test extends uvm_test;
`uvm_component_utils(test)
 
function new(input string inst = "test", uvm_component c);
super.new(inst,c);
endfunction
  
 env e; 
 add_gen agen;
 mul_gen mgen; 
  
  virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
    e       = env::type_id::create("env",this);
    agen     = add_gen::type_id::create("agen");
    mgen     = mul_gen::type_id::create("mgen");
   endfunction
  
                 
virtual task run_phase(uvm_phase phase);
phase.raise_objection(this);
//agen.start(e.vseqr);
//#20;
mgen.start(e.vseqr);
#20;  
phase.drop_objection(this);
endtask
  
endclass               
          
//////////////////////////////////////////////
       
   add_if aif();
   mul_if mif();
 
  
   virtual_sequencer dut (aif.add_in1, aif.add_in2,mif.mul_in1, mif.mul_in2, aif.clk, aif.rst, aif.add_out, mif.mul_out);
  
  
  initial begin
    aif.clk <= 0;
  end
 
  always #10 aif.clk <= ~aif.clk;
  assign mif.clk = aif.clk;
 
  
  
  initial begin
    uvm_config_db#(virtual add_if)::set(null, "*", "aif", aif);
    uvm_config_db#(virtual mul_if)::set(null, "*", "mif", mif);
    run_test("test");
   end
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
 
  
endmodule    