`timescale 1ns / 1ps




module tb_amazon_driver_code();

class transaction extends uvm_sequence_item();
`uvm_object_utils(transaction)

function new(input string path = "transaction");
    super.new(path);
endfunction

endclass   

class driver extends uvm_monitor#(transaction);
`uvm_component_utils(driver)

    transaction tr;
    amazon_if vif;
    
    function new(input string path = "driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual amazon_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not set for driver")
    endfunction
    
    // Screening round
    
// Write a UVM driver for valid-ready protocol
//  Implement valid-ready handshake protocol where:
//    - Transaction happens when valid && ready are both high
//    - Valid must remain stable until ready is asserted
//    - Data must remain stable when valid is high

    virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
        
    forever begin
        
        @(posedge vid.clk);
        
        if(vif.rst_n) begin
            
            
        
        end
        
    end
    endtask


endclass
endmodule