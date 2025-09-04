`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2024 09:11:44 PM
// Design Name: 
// Module Name: tb_fork_join
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


module tb_fork_join();   // used on tasks to avoid race around conditions

    bit [7:0] data1, data2;
    event next;
    event done;
    
    /////    Generator
    task generator();
        for(int i = 0; i < 10; i++) begin
            data1 = $urandom();
            $display("Data Sent: %0d", data1);
            #10;
            
            wait(next.triggered);   // Wait until event next is triggered
        end
        
        -> done;   //     To mark the end of stimuli generation
        
    endtask
    
    //////    Driver
    task receiver();
        forever begin          // used like always inside an always block
            #10;
            data2 = data1;
            $display("Data Received: %0d", data2);
            -> next;         //  Signal to generate the next stimuli or end of a capture
        end
    endtask
    
    /////   To mark the end
    task wait_event();
        wait(done.triggered);
        $finish();
    endtask 
    
   //////   To
   task last();
       $display("Executed at time: %0d", $time);
       $finish();
   endtask     
    
    
    
    initial begin     // This set of code doesn't work in this code but function exists
        fork                // Executes "fork" first and then "join"
            generator();       
            receiver();
            wait_event();
        join               // Executed after all the commands in fork is executed
            last();
    end
endmodule
