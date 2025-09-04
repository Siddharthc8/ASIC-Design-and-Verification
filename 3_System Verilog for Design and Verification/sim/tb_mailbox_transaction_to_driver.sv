`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2024 01:46:38 AM
// Design Name: 
// Module Name: tb_transaction_with_mailbox
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

module tb_mailbox_transaction_to_driver();  // Mailbox should only take the data-type carried out 

class Transaction;
    rand bit [7:0] din1;
    rand bit [7:0] din2;
    bit [7:0] dout;
endclass


class Generator;

    Transaction t;
    mailbox #(Transaction) mbx;      // Here the class acts like a data-type and does not allow an other data type to be mailed
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
        t = new();
    endfunction
    
    task main();
        for(int i=0; i<10; i++) begin  // To generate 10 random values
            assert(t.randomize()) else $display("Randomization Failed");
            $display("[GEN]-> din1: %0d, din2: %0d", t.din1, t.din2);
            mbx.put(t);   // Shipping the whole class handler to another class
            #10;
        end
    endtask
endclass


class Driver;
    Transaction dc;
    mailbox #(Transaction) mbx;
    
    function new(mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction
    
    task main();
        forever begin     // Make sure to add delay and $finish or causes software to crash
            dc = new();  // X X X X X X X X X X  // This is not required as get() creates new data space for handler "dc"
            mbx.get(dc);    // Receiving a handler called "t" from another class
            $display("[DRV]<- din1: %0d, din2: %0d", dc.din1, dc.din2);
            #10;
        end 
    endtask
endclass

//...................Main Module......................//

    Generator gen;
    Driver drv;
    mailbox #(Transaction) mbx;          // Don't forget main module is like the server that links two mailboxes
    
    initial begin
        mbx = new();    // Also dont forget to create constructor for it
        gen = new(mbx);   // Custom constructor
        drv = new(mbx);   // Custom constructor
        
        fork
            gen.main();
            drv.main();        
        join
    end
    
//    initial begin
//        #250 $finish;
//    end

endmodule
