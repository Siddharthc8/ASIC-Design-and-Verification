`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2024 11:26:31 PM
// Design Name: 
// Module Name: tb_fork_join_any_and_none
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


module tb_fork_join_any_and_none();

    task first();
        $display("Task 1 Started at %0t",$time);
      #20;      
        $display("Task 1 Completed at %0t",$time);     
    endtask
  
    
    task second();
      $display("Task 2 Started at %0t",$time);
      #30;      
     $display("Task 2 Completed at %0t",$time);     
    endtask
  
  
    task third();
      $display("Task in Join executed at %0t",$time);     
    endtask
  
  
  initial begin    
    fork                // Executes "fork" first and then "join"
        first();
        second();
        
    join               // Executed after all the commands in fork is executed
        third();
        
    end
    
    ////...........   fork and  join_any   ................./////   
    initial begin    
    fork                // Waits until any one of the tasks is executed and then to join_any
        first();
        second();
        
    join_any           // If either one of them is done join is executed
        third();
        
    end
    
    ////...........   fork and  join_none   ................./////   
    initial begin    
    fork                    // Kinda executes in parallel
        first();
        second();
        
    join_none               // Does not wait for fork
        third();
        
    end
  
endmodule