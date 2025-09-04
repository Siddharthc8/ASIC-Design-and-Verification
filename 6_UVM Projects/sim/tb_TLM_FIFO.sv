`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2024 11:02:07 AM
// Design Name: 
// Module Name: tb_TLM_FIFO
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



// Understand the FIFO holds only export so any interfacing will have to adjust accordingly.
// Sender shold send through a "put" port 
// Receiver should receive through an "export" port

`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_TLM_FIFO();
 
class sender extends uvm_component;
   `uvm_component_utils(sender)
  
  logic [3:0] data;
  
  uvm_blocking_put_port #(logic [3:0] ) send;                                 // Sender should send through a "put" port 
  
  function new(input string path = "sender", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    send = new("send", this);
  endfunction
  
   virtual task run_phase(uvm_phase phase);
     forever begin
       for(int i = 0 ; i < 5; i++)
          begin
            data = $random;
            `uvm_info("sender", $sformatf("Data : %0d iteration : %0d",data,i), UVM_NONE);
            send.put(data);                                                                 // Sender should send through a "put" port 
            #20;
          end
      end
   endtask
  
 
endclass
///////////////////////////////////////////////////////////////
 
class receiver extends uvm_component;
   `uvm_component_utils(receiver)
  
  logic [3:0] datar;
  
  uvm_blocking_get_port #(logic [3:0] ) recv;                                        // Receiver should receive through an "export" port
  
  function new(input string path = "receiver", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv", this);
  endfunction
  
   virtual task run_phase(uvm_phase phase);
     forever begin
       for(int i = 0 ; i < 5; i++)
          begin
            #40;
            recv.get(datar);                                                                   // Receiver should receive through an "export" port
            `uvm_info("receiver", $sformatf("Data : %0d iteration : %0d",datar,i), UVM_NONE);
          end
      end
   endtask
  
 
endclass
////////////////////////////////////////////////////////////////////////
 
class test extends uvm_test;
   `uvm_component_utils(test)
  
  
  
  uvm_tlm_fifo #(logic [3:0]) fifo;               // Decalre the FIFO
  sender s;
  receiver r;
  
  function new(input string path = "test", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    fifo = new("fifo", this, 10);
    s = sender::type_id::create("s", this);
    r = receiver::type_id::create("r", this);
  endfunction
  
   virtual function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     s.send.connect(fifo.put_export);                    // The "put_export" is a standard syntax      CLUE:     PUT TO EXPORT
     r.recv.connect(fifo.get_export);                    // The "get_export" is a standard syntax      CLUE:     GET FROM EXPORT
   endfunction
  
     virtual task run_phase(uvm_phase phase);
       phase.raise_objection(this);
       #200;
       phase.drop_objection(this);
     endtask
  
 
endclass
 
 
////////////////////////////////////////////////////////////////////////////
   
  initial begin
    run_test("test");
  end
  
  
endmodule