`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 02:28:01 PM
// Design Name: 
// Module Name: tb_fixed_and_real_time
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


module tb_fixed_and_real_time();

    time fixed_time = 0;           // returns a fixed point value
    realtime real_time = 0;        // returns a floating point value
    
    ////    $time();   and    $realtime();
    initial begin 
    
        #12;                       // Displays it with three zeros after the value
        fixed_time = $time(); 
        $display("The current simulation time is: %0t", fixed_time);
        
        #12.543                   // Upto 3 decimal places as timescale's resolution is upto 3 decimal places
        real_time = $realtime();
        $display("The current simulation time is: %0t", real_time);
    end
    
endmodule
