`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2025 01:46:55 PM
// Design Name: 
// Module Name: tb_timeunit
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


module tb_timeunit();

     module testbench;
     
         timeunit 1ns;                // This replaces the main timescale unit only for this module
         timeprecision 100ps;         // This replaces the main timescale precision only for this module
         logic status;
         
         initial begin
             #10ns status = 1'b1;      
             #10 status = 1'b0;
        end
    endmodule
    
     module testbench2;
     
         timeunit 1ns/100ps;        // This replaces the main timescale unit only for this module     
         logic status;              // This replaces the main timescale precision only for this module
         
         initial begin
             #10ns status = 1'b1;
             #10 status = 1'b0;
     end
     endmodule
        
endmodule
