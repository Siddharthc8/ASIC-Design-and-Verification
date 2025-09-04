`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2024 11:29:52 AM
// Design Name: 
// Module Name: mod_counter_input
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


module mod_counter_input
    #(parameter n=4)(
    input clk,
    input reset_n,
    input enable,
    input [n-1:0] saturation_value,
    output [n-1:0] Q
    );
    
    reg [n-1:0] Q_next, Q_reg;
    wire saturation;
    
    always @(posedge clk, negedge reset_n)
    begin
        if(!reset_n)
            Q_reg = 'b0;
        else if(enable)
            Q_reg = Q_next;
        else
            Q_reg = Q_reg;
    end
    
    assign saturation = Q_reg == saturation_value;   // sets saturation to 1 when Q_reg reaches the saturation_value
    
    always @(*)
    begin
        Q_next = saturation? 'b0 : Q_reg + 1;   
    end
    
    
endmodule













