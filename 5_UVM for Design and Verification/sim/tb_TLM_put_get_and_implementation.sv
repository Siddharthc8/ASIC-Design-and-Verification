`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2024 05:35:42 PM
// Design Name: 
// Module Name: tb_TLM_put_get_and_implementation
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



/* TLM is just like mailbox 
Can either be blocking or non-blocking
//////      Producer and Consumer for our reference
//////      "port" and "import" for the system's reference
//////      "implementation" should be the end point
PUT Operation, Get Operation and Transport Operation(bi-directional)
PUT port and GET port
Transport port is iused between Sequenceer -> Driver   (SEQ_ITEM_PORT)     
Analysis port is used between Monitor -> Scoreboard    (UVM_ANALYSIS_PORT)      
///////      Should create new object just like we did for mailboxes    
//////       Lastly "put" task method should be mentioned in the consumer component  XXXXXXXXXX  .....    XXXXXXX      
*/

`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_TLM_put_get_and_implementation();

class producer extends uvm_component;
  `uvm_component_utils(producer)
  
  int data = 12;
  
  uvm_blocking_put_port #(int) send;     //  "port" is mentioned in the sending end // "send" is the name of the TLM
  
  function new(input string path = "producer", uvm_component parent = null);
    super.new(path, parent);
    
    send  = new("send", this);
    
  endfunction
  
  
  task main_phase(uvm_phase phase);    // Data transfer is handled int he main_phase
   
    phase.raise_objection(this);
    send.put(data);                   // Data is being sent where "send" is the name of the TLM
    `uvm_info("PROD" , $sformatf("Data Sent : %0d", data), UVM_NONE);
    phase.drop_objection(this);
    
  endtask
  
 
    
endclass
////////////////////////////////////////////////
 
class consumer extends uvm_component;
  `uvm_component_utils(consumer)
  
  
  uvm_blocking_put_export #(int) recv;    //  "export" is mentioned in the sending end      // "recv" is the name of the TLM
  uvm_blocking_put_imp #(int, consumer) imp;     // Second argumet is only for imp where the  consumer class_name should be mentioned
  
  function new(input string path = "consumer", uvm_component parent = null);
    super.new(path, parent);
    
    // "port" can be directly connected to imp as well
    recv  = new("recv", this);        // Created an object for both using new method
    imp   = new("imp" , this);        // "this" denotes the parent class
    
  endfunction
 
 // Takes the data type and a new variable to store it
  task put(int datar);  // IMPORTANT   "put" method sent data ia accessed by another custom "put" method in the 'consumer' class
    `uvm_info("CONS" , $sformatf("Data Rcvd : %0d", datar), UVM_NONE); 
  endtask
  
  
endclass
 
//////////////////////////////////////////////////////////////////////////////////
 
class env extends uvm_env;
`uvm_component_utils(env)
 
producer p;
consumer c;
 
 
  function new(input string path = "env", uvm_component parent = null);
    super.new(path, parent);
  endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  p = producer::type_id::create("p",this);
  c = consumer::type_id::create("c", this);
 endfunction
 
  
  
 virtual function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);
  
  p.send.connect(c.recv);      // Syntax : sending_object_handle.name.connect(receiving_object_handle.name)
  c.recv.connect(c.imp);     // Same syntax goes for the implementation and IMP should be the end
  
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