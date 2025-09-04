`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 10:02:23 AM
// Design Name: 
// Module Name: tb_usage_of_queue
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


module tb_usage_of_queue();        // Incomplete code

class Transaction;

    rand bit [7:0] wdata;
    bit [7:0] rdata;
    rand bit wreg, rreq;
    
endclass

class Generator;
    Transaction t;
    int count;
    
    task run();
        repeat(count) begin
            t = new();
            assert(t.randomize())else $fatal("Randomization Failed"); 
      
        end
    endtask

endclass

class Scoreboard;
    bit [7:0] rdata;
    bit [7:0] stack[$];     // Data type matched with the data type of the data that will be written to this stack (rdata)
    Transaction t;
    
    task run();
        if(t.wreq == 1)begin
            stack.push_front(t.wdata);
        end
        else if (t.rreq == 1) begin
            if(t.rdata == stack.pop_back())
                $display("Data read: %0h", t.rdata);
            else if(t.rdata != stack.pop_back())
                $display("Data Mismatch at %0t", $time);
            end
    endtask
    

endclass


endmodule
