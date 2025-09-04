`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2025 10:37:47 PM
// Design Name: 
// Module Name: tb_import_task_from_interface_to_modport
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


module tb_import_task_from_interface_to_modport();

    logic clk = 0;
    
     interface ifa(input clk);
     
        logic req, start,gnt,rdy;
        
         logic[1:0]mode;
         logic[7:0]addr,data;
         
         modport cif(
         
         input clk,gnt,rdy,
         output start,req, mode, addr,
         inout data,
         import read    // Here for the modport to access the task outside modport it has to import it
         
         );
         
         task read(input byteraddr,output byte rdata);
         endtask
         
     endinterface :ifa
    
endmodule
