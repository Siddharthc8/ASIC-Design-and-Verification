`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2025 10:15:51 PM
// Design Name: 
// Module Name: tb_modport_in_interface
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


module tb_modport_in_interface();
    
    logic a,b,c,d;
    
    module busmaster(mod_if.master mbus);  // takes the inputs from interface through master modport
    
    endmodule
    
    module busslave(mod_if.slave sbus);    // takes the inputs from interface through slave modport
    
    endmodule
    
    // Testbench scenario
    
    module testbench;
         mod_if busa();
         busmaster M1 (.mbus(busa));
         busslave S1 (.sbus(busa));
     endmodule
      
     module testbench_1;
         mod_if busb();
         busmaster M2 ( .mbus(busb.master) );   // here the testbench restricts what the module can access
         busslave S2 ( .sbus(busb.slave) );
     endmodule
    
    
    interface mod_if;
    
         logic a,b,c,d;
         
         modport master(input a,b, output c,d);
         modport slave (output a,b, input c,d);
         modport subset(output a, input b);
     endinterface
     
 endmodule
