`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2025 07:30:51 AM
// Design Name: 
// Module Name: tb_amazon_semaphore_code
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

// Two Drivers trying to access one interface
// Control the access to only one driver accesses the interface
// Using semaphore is an option 

module tb_amazon_semaphore_code();

class driver extends uvm_driver;
`uvm_component_utils(driver)
    
    /* //////////////////////////////////////
    
    Semaphore instantiated but no object created 
    
    *////////////////////////////////////////
    
    transaction tr;
    virtual int_if vif;
    semaphore sem;               

    function new(input string path = "driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            seq_item_port.get_next_item(tr);
            drive();
            seq_item_port.item_done();
        end
       endtask     
       
        task drive();
            sem.get(1);              // Getting semaphore access 
            vif.data <= tr.data;
            sem.put(1);              // Releasing semaphore access
        endtask
    
endclass

class agent extends uvm_agent;
`uvm_component_utils(agent)
    
    driver dr1;
    driver dr2;
    
    function new(input string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        dr1.seq_item_port.connect(seqr.seq_item_export);
        dr2.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass

class env extends uvm_env;
`uvm_component_utils(env)
    
    /* //////////////////////////////////////
    
    Semaphore instantiated and object created
    
    *////////////////////////////////////////
    
    semaphore sem;              
    agent agt;
    
    function new(input string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sem = new(1);
        agt.dr1.sem = sem;           // Driver1 semaphore has no object so connections are done here.
        agt.dr2.sem = sem;           // Driver2 semaphore has no object so connections are done here.
    endfunction
    
    
endclass


endmodule
