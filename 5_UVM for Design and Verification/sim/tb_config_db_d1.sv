`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2024 04:04:00 PM
// Design Name: 
// Module Name: tb_config_db_d1
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

 module tb_config_db_d1();

class comp1 extends uvm_component;
    `uvm_component_utils(comp1)
    
    int data1 = 0;
    
    function new(string path = "comp1", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //   Using "this" instead of "null" can replace the path, but make sure to remove the "instance name"
    if(!uvm_config_db #(int)::get(this, "", "data", data1)) // Sets the argument to uvm_test_top(created automatically).env.agent.data
        `uvm_error("comp1", "Unable to access Interface");
    
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);              // super is not used
        `uvm_info("comp1", $sformatf("Data rcvd comp1 : %0d", data1), UVM_NONE);
        phase.drop_objection(this);
        
    endtask

endclass

//////////////////////////////////////////////////////////////////////////////

class comp2 extends uvm_component;
    `uvm_component_utils(comp2)
    
    int data2 = 0;
    
    function new(string path = "comp2", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(int)::get(this, "", "data", data2)) // Context + Instance name + Key + Container to store
        `uvm_error("comp2", "Unable to access Interface");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);              // super is not used
        `uvm_info("comp2", $sformatf("Data rcvd comp2 : %0d", data2), UVM_NONE);
        phase.drop_objection(this);
    endtask

endclass

//////////////////////////////////////////////////////////////////////////////

class agent extends uvm_agent;
`uvm_component_utils(agent)

    function new(input string inst = "agent", uvm_component c);
    super.new(inst, c);
    endfunction
    
    comp1 c1;
    comp2 c2;
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c1 = comp1::type_id::create("c1", this);
    c2 = comp2::type_id::create("c2", this);
    endfunction
    
endclass

//////////////////////////////////////////////////////////////////////////////

class env extends uvm_env;
`uvm_component_utils(env)
    
    agent a;
    
    function new(input string inst = "env", uvm_component c);
    super.new(inst, c);
    endfunction    
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a = agent::type_id::create("agent", this);
    endfunction

endclass

//////////////////////////////////////////////////////////////////////////////

class test extends uvm_test;
`uvm_component_utils(test)
    
    env e;
    
    function new(input string inst = "test", uvm_component c);
    super.new(inst, c);        
    endfunction    
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("env", this);
    endfunction

endclass

////////////////////////////////// MAIN MODULE /////////////////////////////////////

    int data = 256;

    initial begin
        uvm_config_db #(int)::set(null, "uvm_test_top.env.agent*", "data", data);      // Context + Instance name + Key + Value
        run_test("test");    
    end
    
    
endmodule
