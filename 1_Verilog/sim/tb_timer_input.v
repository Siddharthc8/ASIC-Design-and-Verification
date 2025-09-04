`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 11:03:19 PM
// Design Name: 
// Module Name: tb_timer_input
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



module tb_timer_input();
    
    localparam n = 16;
    
    // I/p O/p Declaration
    reg clk, reset_n, enable;
    reg [n-1:0] saturation_value;
    wire saturation;
    
    // Instantiation
    timer_input #(.n(n)) uut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .saturation_value(saturation_value),
        .saturation(saturation)
        );
    
       // Clock Generation
       localparam T = 10;
       always
       begin
            clk = 1'b0;
            #(T/2);
            clk = 1'b1;
            #(T/2);
       end   
       
       initial 
       begin
            //reset
            reset_n = 1'b0;
            #2;
            reset_n = 1'b1;
            enable = 1'b1;
            saturation_value = 255;
            
            #(saturation_value * T * 3);
            saturation_value = 49_999;
            
            #(saturation_value * T * 3);
            $stop;
       end        
endmodule















