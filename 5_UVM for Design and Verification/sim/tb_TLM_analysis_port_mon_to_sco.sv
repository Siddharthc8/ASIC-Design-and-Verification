`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2024 09:03:06 AM
// Design Name: 
// Module Name: tb_TLM_analysis_port_mon_to_sco
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

module tb_TLM_analysis_port_mon_to_sco();
 
class producer extends uvm_component;
  `uvm_component_utils(producer)
  
  uvm_analysis_port #(int) port;
  
  int data = 12;
  
  function new(input string path = "producer", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    port   = new("port", this);
  endfunction
  
  task main_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info("PROD", $sformatf("Data Broadcasted : %0d", data), UVM_NONE);
  port.write(data);
  phase.drop_objection(this);
 endtask
  
  
endclass
////////////////////////////////////////////////
 
class consumer1 extends uvm_component;
  `uvm_component_utils(consumer1)
  
  
  uvm_analysis_imp#(int, consumer1) imp;
  
  function new(input string path = "consumer1", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    imp  = new("imp", this);
  endfunction
  
  virtual function void write(int datar);
    `uvm_info("CONS1", $sformatf("Data Recv : %0d", datar), UVM_NONE); 
  endfunction
 
  
endclass
 
//////////////////////////////////////////////////////////////////////////////////
    
  class consumer2 extends uvm_component;
    `uvm_component_utils(consumer2)
  
  
    uvm_analysis_imp#(int, consumer2) imp;
  
    function new(input string path = "consumer2", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    imp  = new("imp", this);
  endfunction
  
  virtual function void write(int datar);
    `uvm_info("CONS2", $sformatf("Data Recv : %0d", datar), UVM_NONE); 
  endfunction
 
  
endclass  
    
        
    
    
/////////////////////////////////////////////////////////////////////////////
 
class env extends uvm_env;
`uvm_component_utils(env)
 
producer p;
consumer1 c1;
consumer2 c2;  
 
 
function new(input string path = "env", uvm_component parent = null);
    super.new(path, parent);
endfunction
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  c1 = consumer1::type_id::create("c1", this);
  c2 = consumer2::type_id::create("c2", this);
  p = producer::type_id::create("p",this);
endfunction
 
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
  p.port.connect(c1.imp);
  p.port.connect(c2.imp);
endfunction
 
 
endclass
 
///////////////////////////////////////////////////
 
class test extends uvm_test;
`uvm_component_utils(test)
 
env e;
 
function new(input string path = "test", uvm_component parent = null);
  super.new(path, parent);
endfunction
 
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  e = env::type_id::create("e",this);
endfunction
 
 
endclass
 
//////////////////////////////////////////////
 
initial begin
  run_test("test");
end
 
 
endmodule