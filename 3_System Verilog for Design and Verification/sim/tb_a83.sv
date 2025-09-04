`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2024 10:46:49 PM
// Design Name: 
// Module Name: tb_a83
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


module tb_a83();
// Code for transaction class is mentioned in the Instruction tab. 
// Write a code to send transaction data between generator and driver. 
// Also, verify the data by printing the value of data members of Generator and Driver in each transaction. 
// Execute the code for 10 random transactions.
// Execute the code for 10 random transactions.

    

class Transaction;
 
    rand bit [7:0] a;
    rand bit [7:0] b;
    rand bit wr;   
    
endclass

class Generator;
    
    Transaction t;
    mailbox #(Transaction) mbx;
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task run(); 
        t = new();
        for(int i=0; i<10; i++) begin
            if(!t.randomize()) begin
                $display("Oops! Randomization failed");
                $finish();
            end
            else begin
                t.randomize();
                mbx.put(t);
                $display("[GEN] -> a: %0d, b: %0d, wr: %0d at time: %0t", t.a, t.b, t.wr, $time); 
                #10;
            end
            $display("Triggered @%0d", $time);
            
        end
    endtask
    
endclass

class Driver;
    
    Transaction td;
    mailbox #(Transaction) mbx;
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task run(); 
        forever begin
            mbx.get(td);
            $display("[DRV] <- a: %0d, b: %0d, wr: %0d at time: %0t", td.a, td.b, td.wr, $time); 
            #10;
        end
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
        join_any
            $finish;
    end

endmodule