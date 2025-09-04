`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2024 07:48:32 AM
// Design Name: 
// Module Name: tb_config_db
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

// More like mailboxes and semaphores combined

module tb_config_db();

class env extends uvm_env;
    `uvm_component_utils(env)
    
    int data;
    
    function new(string path = "env", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(uvm_config_db#(int)::get(null, "uvm_test_top", "data", data)) // Context + Instance name + Key + Container to store
        `uvm_info("env", $sformatf("Value of data is: %0d", data), UVM_NONE)
    else
        `uvm_error("env", "Unable to access the value");
    endfunction

endclass

class test extends uvm_test;
    `uvm_component_utils(test)
    
    env e;
        
    function new(string path = "test", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
    
        uvm_config_db#(int)::set(null, "uvm_test_top", "data", 12);    // Context + Instance name + Key + Value
                                                                    // When you set context to "null" all the classes have access to this variable or data 
    endfunction

endclass

//////////////// MAIN MODULE //////////////////////

    initial begin
        run_test("test");
    end
endmodule
