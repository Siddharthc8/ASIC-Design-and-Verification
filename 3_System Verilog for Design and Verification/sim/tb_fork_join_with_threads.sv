`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 08:03:37 AM
// Design Name: 
// Module Name: tb_fork_join_with_threads
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


module tb_fork_join_with_threads();

initial begin : top_thread
    
    fork
        begin : T_A
            fork
            
                begin 
                 #10; $display("A1 completed");
                end
                
                begin 
                 #15; $display("A2 completed");
                end
                
            join_none
            
            #15ns;
            
            disable fork;
        end
    
        begin : T_B
            fork
            
                begin 
                    #1ns; $display("B completed");
                end
                
                begin
                    #5ns;
                    disable fork;
                end
                
             join_none
         end
         
     join_none
     
     #50ns;
     disable fork;
     
     end   
     
     initial begin : T_C
        #2ns;
        $display("C says hello at 2ns");
        disable fork;
     end
    

endmodule
