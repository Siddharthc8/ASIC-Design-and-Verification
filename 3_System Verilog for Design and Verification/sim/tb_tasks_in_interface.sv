`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2025 10:27:44 PM
// Design Name: 
// Module Name: tb_tasks_in_interface
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


module tb_tasks_in_interface();
    
    
    module cpu_core(ifa bus);
        
        logic [7:0] addr, data;
        
        initial begin
            bus.read(addr, data);   // Calling the read task from interface through the dot operator

        end
    endmodule
    
    
    interface ifa (input clk);
    
         logic req,start, gnt,rdy;
         logic [1:0] mode;
         logic [7:0] addr;
         wire [7:0] data;
         
         task read (input byte raddr,output byte rdata);
             @(posedge clk);
             addr = raddr;
             rdata = data;
         endtask
         
    endinterface: ifa
    
    
    
    
    
endmodule
