`timescale 1ns / 1ps


`include "uvm_macros.svh"
import uvm_pkg::*;

// Screening round
module tb_amazon_monitor_code();

class transaction extends uvm_sequence_item();
`uvm_object_utils(transaction)

function new(input string path = "transaction");
    super.new(path);
endfunction
endclass


class monitor extends uvm_driver;
`uvm_component_utils(monitor)
    
    transaction tr;
    amazon_if vif;
            
    function new(input string path = "monitor", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
//  * Everything is driven on Posedge of clock, Valid signal is qualifier for all rest of the signals
//  * SOP is start of packet, when new packet starts SOP stays high for one clock cycle
//  * EOP is end of packet, When packet ends EOP stays high for one clock
//  * pkt_len indicates packet length in no. of bytes. and it is valid at SOP only. For example, pkt_length = 37, total packet size is 37 bytes
//  * Data is valid from SOP to EOP including them. There can be idle cycles in between.
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
        
            @(posedge vif.clk);
            tr = transaction::type_id::create("tr");
            
            // We are waiting for valid and SOP to become high
            wait(vif.SOP && vif.valid);
            tr.pkt_len = vif.pkt_len;          // Sample the packet length 
            tr.data = new[tr.pkt_len];         // set the data size array to eb of the incoming data size
            i = 0;                             
            
            // Sample the first value at SOP and valid
            tr.data[i++] = vif.data;
            
            while(i < tr.pkt.len) begin
                @(posedge vif.clk);
                
                if(vif.valid && vif.EOP !== 1'b1) begin
                    tr.data[i++] = vif.data;
                end
                
                else if(vif.valid && vif.EOP) begin
                    tr.data[i++] = vif.data;
                    if(i != tr.pkt_len) 
                        `uvm_error("MON", $sformatf("EOP received early at byte %0d, expected %0d", i, tr.pkt_len));
                    break;
                end
            end
            
        end
        
    endtask
    
endclass

endmodule