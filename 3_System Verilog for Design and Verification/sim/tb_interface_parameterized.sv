`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2025 10:08:31 PM
// Design Name: 
// Module Name: tb_interface_parameterized
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


module tb_interface_parameterized();
    
    reg clk = 0;
    
    fastbus#(8, 5) bus8x5(clk); // 8-bit DBUS and 5-bit ABUS
    
    fastbus #(8) bus8x8(clk); // 8-bit DBUS and 8-bit ABUS
    
    slowbus#(.WIDTH(8)) bus2(); // 8-bit a, b variables
    
    
    
    interface fastbus #(DBUS= 32, ABUS= 8) (input clk);
         logic [DBUS-1:0] data;
         logic [ABUS-1:0]address;
    endinterface
    
     interface slowbus;
         parameter WIDTH = 16;
         logic [WIDTH-1:0] a, b;
     endinterface
    
endmodule
