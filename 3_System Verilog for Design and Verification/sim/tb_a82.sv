`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2024 10:18:50 PM
// Design Name: 
// Module Name: tb_a82
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

module tb_a82();
// Code for transaction class is mentioned in the Instruction tab. 
// Write a code to send transaction data between generator and driver. 
// Also, verify the data by printing the value of data members of Generator and Driver.

class Transaction;
 
    bit [7:0] addr = 7'h12;
    bit [3:0] data = 4'h4;
    bit we = 1'b1;
    bit rst = 1'b0;   
    
endclass

class Generator;
    
    Transaction t;
    mailbox #(Transaction) mbx;
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task run(); 
        t = new();
        mbx.put(t);
        $display("[GEN] -> addr: %0d, data: %0d, we: %0d, rst: %0d", t.addr, t.data, t.we, t.rst); 
    endtask
    
endclass

class Driver;
    
    Transaction td;
    mailbox #(Transaction) mbx;
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task run(); 
        mbx.get(td);
        $display("[DRV] <- addr: %0d, data: %0d, we: %0d, rst: %0d", td.addr, td.data, td.we, td.rst); 
    endtask
    
endclass

///............. MAIN MODULE.............///

    Generator gen;
    Driver drv;
    mailbox #(Transaction) mbx;
    
    initial begin
        mbx = new();
        gen = new(mbx);
        drv = new(mbx);
        
        fork
        gen.run();
        drv.run();
        join
    end

endmodule
