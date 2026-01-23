`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2025 08:50:30 PM
// Design Name: 
// Module Name: tb_multiple_driver_multiple_slave
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

module tb_multiple_driver_multiple_slave();

class transaction extends uvm_sequence_item;


    //typedef enum bit [1:0] {readd= 0, drived = 1, rstdut = 2} oper_mode;
    
    
    rand logic rst;
    rand logic valid;
    rand logic ready;
    rand logic sop;
    rand logic eop;
    rand logic [31:0] data[];
    rand logic [3:0]  keep[];
    rand logic [11:0] length;
    rand logic [1:0] dest; 
    rand logic [1:0] src;
    bit [7:0] crc;
    
    `uvm_object_utils_begin(transaction)
        `uvm_field_int(rst, UVM_ALL_ON)
        `uvm_field_int(valid, UVM_ALL_ON)
        `uvm_field_int(ready, UVM_ALL_ON)
        `uvm_field_int(sop, UVM_ALL_ON)
        `uvm_field_int(eop, UVM_ALL_ON)
        `uvm_field_array_int(data, UVM_ALL_ON)
        `uvm_field_array_int(keep, UVM_ALL_ON)
        `uvm_field_int(length, UVM_ALL_ON)
        `uvm_field_int(dest, UVM_ALL_ON)
        `uvm_field_int(src, UVM_ALL_ON)
//        `uvm_field_enum(oper_mode, op, UVM_DEAFULT)
        
    `uvm_object_utils_end
    
    /////////////////////////////////////////////////
     //               Constraints                  //
    ////////////////////////////////////////////////
    
    // 3 slaves
    constraint valid_dest {
        dest inside { 2'b00, 2'b01, 2'b10 };
    }
    
    // 
    constraint valid_length {
        length inside { [12'h000:12'hFFF] };
    }
    
    // 2 Masters - could have used one bit but won't be expandable
    constraint valid_src {
        src inside { 2'b00, 2'b01 };
    }
    
    constraint valid_data_size {
        data.size() == ( length == 12'h000 ? 4096 : length );
    }
    
    constraint valid_keep_size {
        keep.size() == ( length == 12'h000 ? 4097 : length + 1 );
    }
    
    constraint valid_keep {
        foreach(keep[i]) {
            ( i < (keep.size()-1)) -> keep[i] == 4'b1111;
            ( i == (keep.size()-1)) -> keep[i] == 4'b0001;
        }
            
    }
    
    /////////////////////////////////////////////////
     //               Coverage                  //
    ////////////////////////////////////////////////    
    
    covergroup cg_transaction;
        
        option.per_instance = 1;
        
        rst_cp   : coverpoint rst;
        valid_cp : coverpoint valid;
        ready_cp : coverpoint ready;
        sop_cp   : coverpoint sop;
        eop_cp   : coverpoint eop;
//        crc_cp   : coverpoint crc;
        
        length_cp : coverpoint length {
            bins low = {[1:4]};
            bins med = {[5:100]};
            bins high = {[101:4095]};
            bins max = {4096};
        }
        
        src_cp : coverpoint src {
            bins src_0 = {2'b00};
            bins src_1 = {2'b01};
        }
        
        dest_cp : coverpoint dest {
            bins dest_0 = {2'b00};
            bins dest_1 = {2'b01};
            bins dest_2 = {2'b10};
        }
        
        crc_cp : coverpoint crc {
            bins low  = {[8'h00:8'h3F]};
            bins med  = {[8'h40:8'hBF]};
            bins high = {[8'hC0:8'hFF]};
        }
        
        //             CROSS COVERAGE        //
        
        src_dest_cp : cross src_cp , dest_cp;
        sop_eop_cp  : cross sop_cp, eop_cp;
        

    
    endgroup
    
    
    function new(input string path = "transaction");
        super.new(path);
        cg_transaction = new();
    endfunction
    
    function compute_crc();
        bit [31:0] control_word = { 8'h00, 8'h00, src, dest, length };
        crc = calculate_crc(control_word);
    endfunction
    
    // My own
    function bit [7:0] calculate_crc(input bit [31:0] data);
        bit [7:0] crc = 8'h00;
        bit [7:0] poly = 8'h07;
        
        for (int i = 0; i < 32; i++) begin
            bit feedback = (crc[7] ^ data[31]);
            crc = {crc[6:0], 1'b0};
            if (feedback)
                crc ^= poly;
            data <<= 1;  // same as data = data << 1;
        end
        
        return crc;
    endfunction

    function void sample_coverage();
        cg_transaction.sample();
    endfunction
endclass


class M0_driver extends uvm_driver#(transaction);
`uvm_component_utils(M0_driver)

    transaction tr;
    virtual M_if vif;

    function new(input string path = "driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr");
        if(!uvm_config_db#(virtual M_if)::get(this, "", "m0_if", vif))
            `uvm_error("M0_DRV", "Unable to access the interface M0");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        forever begin
        
        //   make "valid" high
        //   Start of Packet
        //   Wait for ready from slave
        //   Make SOP low && Send all the data based on the length of the data ( Keeping valid high and waiting for ready from the dut)
        //   mark the last value and make keep 0001 and eop = 1
        //   valid = 0 and eop = 0
        
            seq_item_port.get_next_item(tr);
            
            // Reset 
            vif.rst   <= 1'b1;
            vif.valid <= 1'b0;
            vif.sop   <= 1'b0;
            vif.eop   <= 1'b0;
            vif.data  <= 32'h00000000;
            vif.keep  <= 4'b0000;
            `uvm_info("M0_DRV", "System Reset detected", UVM_NONE);
            @(posedge vif.clk);
            vif.rst <= 1'b0;
            @(posedge vif.clk);
            
            // Handle the data transfer
            vif.valid <= 1'b1;           
            vif.sop <= 1'b1;
            tr.compute_src();
            tr.src = 2'b00;
            vif.eop <= 1'b0; 
            vif.data <= { 8'h00, tr.crc, tr.src, tr.dest, tr.length };
            vif.keep <= 4'b1111;
            
            // wait for DUT to be ready
            wait(vif.ready);
            @(posedge vif.clk);
            vif.sop <= 1'b0;              // Deassert SOP immediately after first transfer
            
            // Transfer data words (remove the last element as keep is diff)
            for(int i = 0; i < (tr.length == 12'h000 ? 4096 : tr.length ); i++) begin
                vif.data <= tr.data[i];
                // for handling the last element
                if(i == (tr.length == 12'h000 ? 4095 : tr.length-1)) begin    // During last element      
                    vif.keep <= 4'b0001;                                      // keep goes to 0001
                    vif.eop <= 1'b1;                                          // Set EOP to 1 to mark the end of data transfer
                end
                else begin
                    vif.keep <= 4'b1111;
                end
                
                wait(vif.ready);       // Still inside for loop but waiting for vif.ready from slave after each data transfer 
                @(posedge vif.clk);    // Exits only after the last transaction
                
            end
            `uvm_info("M0_DRV", "Data transfer successful", UVM_NONE);
            vif.eop <= 1'b0;           // set EOP to zero to be ready for next transaction
            vif.valid <= 1'b0;         
            
            seq_item_port.item_done();
            
        end
    endtask

endclass


class M1_driver extends uvm_driver#(transaction);
`uvm_component_utils(M1_driver)
    
    transaction tr;
    virtual M_if vif;
    
    function new(input string path = "M1_driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr");
        if(!uvm_config_db#(virtual M_if)::get(this, "", "m1_if", vif)) `uvm_error("M0_DRV", "Unable to access the interface M0");
    endfunction
    
    virtual task resetdut();
        vif.rst   <= 1'b1;
        vif.valid <= 1'b0;
        vif.sop   <= 1'b0;
        vif.eop   <= 1'b0;
        vif.data  <= 32'h00000000;
        vif.keep  <= 4'b0000;
        `uvm_info("M1_DRV", "System reset detected", UVM_NONE);
        @(posedge vif.clk);
        vif.rst <= 1'b0;
        @(posedge vif.clk);
    endtask
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
//        resetdut();
        
        forever begin
            
           seq_item_port.get_next_item(tr);
           
           vif.rst   <= 1'b1;
           vif.valid <= 1'b0;
           vif.sop   <= 1'b0;
           vif.eop   <= 1'b0;
           vif.data  <= 32'h00000000;
           vif.keep  <= 4'b0000;
           `uvm_info("M1_DRV", "System reset detected", UVM_NONE);
           @(posedge vif.clk);
           vif.rst  <= 1'b0;
           @(posedge vif.clk);
           
           // Handle data tranasfer
           vif.valid <= 1'b1;
           vif.sop   <= 1'b1;
           tr.compute_crc();
           tr.src = 2'b00;
           vif.eop  <= 1'b0;
           vif.data <= { 8'h00, tr.crc. tr.src, tr.dest, tr.length };
           vif.keep <= 4'b1111;
           
           wait(vif.ready);
           @(posedge vif.clk);
           
           vif.sop <= 1'b0;          // Deassert SOP after the first transaction
           
           // Transafer the data 
           for (int i = 0; i < (length == 12'h000 ? 4096 : length ); i++ ) begin
               vif.data <= tr.data[i];
               
               if(i == (length == 12'h000 ? 4097 : length + 1) ) begin
                   vif.eop <= 1'b1;
                   vif.keep <= 4'b0001;
               end
               
               wait(vif.ready);
               @(posedge vif.clk);
           end
           `uvm_info("M1_DRV", "Data transfer successful", UVM_NONE);
           // Clear signals after last transfer
           vif.eop <= 1'b0;
           vif.valid <= 1'b0;
           seq_item_port.item_done();
        
        end
    endtask
    
endclass

endmodule












// Master Interface
interface M_if(input logic clk, input logic rst);

    logic        m_valid;
    logic        m_ready;
    logic        m_sop;
    logic        m_eop;
    logic [31:0] m_data;
    logic [3:0]  m_keep;   // Acts more like strobe
    logic [11:0] m_length; // Not used anywhere 
    logic [1:0]  m_dest;
    logic [1:0]  m_src;
    logic [7:0]  m_crc;
    
    
    // Clocking block for driver
    clocking cb_drv @(posedge clk);
        output m_valid, m_sop, m_eop, m_data, m_keep, m_dest, m_src, m_crc;
        input m_ready;
    endclocking
    
    // Clocking block for monitor
    clocking cb_mon @(posedge clk);
        input m_valid, m_sop, m_eop, m_data, m_keep, m_src, m_crc, m_ready;
    endclocking
    
    // Modports
    modport driver ( 
        input clk, rst,
        output m_valid, m_sop, m_eop, m_data, m_keep, m_src, m_crc,
        input m_ready
    );

    modport monitor (
        input clk, rst,
        input m_valid, m_sop, m_eop, m_data, m_keep, m_src, m_crc, m_ready
    );
    
    // Assertion to check that SOP is asserted only when valid is high
    a_sop_valid : assert property( @(posedge clk) disable iff(rst) m_sop |-> m_valid) else `uvm_error("ASSERT", "SOP asserted without valid high")
    
    // Assertion to check that the control word is fully transferred when SOP is asserted
    a_control_word_transfer : assert property( @(posedge clk) disable iff(rst) m_sop |-> m_keep == 4'b1111) else `uvm_error("ASSERT", "Control word must have full keep");
    
    // Assertion to check that the first word after SOP is the control word
    a_control_word_format : assert property( @(posedge clk) disable iff(rst) m_sop |-> m_data[31:24] ==  8'h00 ) else `uvm_error("ASSERT", "Invalid control word format")
    
    // Assertion to ensure that valid is high throughout the transfer
    a_valid_high_during_transfer : assert property( @(posedge clk) disable iff(rst) m_valid && !m_eop |-> m_valid ) else `uvm_error("ASSERT", "Valid deasserted before EOP");
    a_valid_high_during_transfer1 : assert property( @(posedge clk) disable iff(rst) m_valid && !m_eop |-> m_valid throughout !m_eop ) else `uvm_error("ASSERT", "Valid deasserted before EOP");
    a_valid_high_during_transfer2 : assert property( @(posedge clk) disable iff(rst) m_valid && !m_eop |-> m_valid until !m_eop ) else `uvm_error("ASSERT", "Valid deasserted before EOP");
    
    // Assertion to check that EOP is asserted only at the last data word
    a_eop_last_word : assert property( @(posedge clk) disable iff(rst) m_eop |-> ##[0:$] (!m_valid && !m_ready) ) else `uvm_error("ASSERT", "EOP asserted but valid is still high afterwards");
    a_eop_last_word1 : assert property( @(posedge clk) disable iff(rst) m_eop |=> ##0 (!m_valid && !m_ready) ) else `uvm_error("ASSERT", "EOP asserted but valid is still high afterwards");
    
    // Assertion to check that destination is valid (not 2'b11)
    a_valid_dest : assert property( @(posedge clk) disable iff(rst) m_sop |-> m_dest != 2'b11 ) else `uvm_error("ASSERT", "Invalid destination address received"); 
    
    // Assertion to check that length field follows protocol 12'hFFF
    a_length_valid : assert property( @(posedge clk) disable iff(rst) m_sop |-> m_length <= 12'hFFF ) else `uvm_error("ASSERT", "Invalid packet length");

    // Assertion to check that CRC calculation is correct
    a_crc_check: assert property (@(posedge clk) disable iff (rst) m_sop |-> m_crc == calculate_crc({8'h00, 8'h00, m_src, m_dest, m_length})) else `uvm_error("ASSERT", "CRC mismatch detected");
    
endinterface

// Slave Interface
interface S_if(input logic clk, input logic rst);

    logic        s_valid;
    logic        s_ready;
    logic        s_sop;
    logic        s_eop;
    logic [31:0] s_data;
    logic [3:0]  s_keep;   // Acts more like strobe
    logic [11:0] s_length; // Not used anywhere 
    logic [1:0]  s_dest;
    logic [1:0]  s_src;
    logic [7:0]  s_crc;
    
    // Clocking block for Driver
    clocking cb_drv @(posedge clk);
        input s_valid, s_sop, s_eop, s_data, s_keep, s_dest, s_src, s_crc;
        output s_ready;
    endclocking
    
    // Clocking block for Monitor
    clocking cb_mon @(posedge clk);
        input s_valid, s_sop, s_eop, s_data, s_keep, s_dest, s_src, s_crc, s_ready;
    endclocking
    
    modport driver ( 
        input clk, rst,
        input s_valid, s_sop, s_eop, s_data, s_keep, s_dest, s_src, s_crc,
        output s_ready
     );
     
     modport monitor ( 
        input clk, rst,
        input s_valid, s_sop, s_eop, s_data, s_keep, s_dest, s_src, s_crc, s_ready
     );
endinterface