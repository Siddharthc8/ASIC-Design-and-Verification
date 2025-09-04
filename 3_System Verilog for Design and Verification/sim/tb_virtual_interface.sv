`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2025 06:13:00 PM
// Design Name: 
// Module Name: tb_virtual_interface
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


module tb_virtual_interface();

    class myvc;
    
     virtual interface myif vif;
     
     function new (virtual interface myif aif);
        vif = aif;
     endfunction
     
     task write_data(input int datin);
         @(posedge vif.clk);
         vif.data= datin;
     endtask
     
    endclass
    
    
     myif bus1(), bus2();
     myvc c1, c2;
     
     initial begin
     
         c1 = new(bus1);     // Class c1 instance uses bus1 interface
         c1.write_data(5);
         
         c2 = new(bus2);    // Class c2 instance uses bus2 interface
         c2.write_data(8);
         
    end
    
endmodule