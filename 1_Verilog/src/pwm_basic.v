`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2024 11:07:47 AM
// Design Name: 
// Module Name: pwm_basic
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


module pwm_basic
    #(parameter n=8)(
    input clk,
    input reset_n,
    input [n-1:0] duty,   // Mention Duty cycle number
    output pwm_out
    );
    
    // Up counter
    reg [n-1:0] Q_reg, Q_next;
    
    always @(posedge clk or negedge reset_n)
    begin
        if(!reset_n)
            Q_reg = 'b0;
        else
            Q_reg = Q_next;
    end
    
    always @(*)
    begin
        Q_next = Q_reg+1;    
    end
    
    assign pwm_out = (Q_reg < duty);
    
endmodule
