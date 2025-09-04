`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 10:42:20 PM
// Design Name: 
// Module Name: timer_input
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


module timer_input                      
    #(parameter n=4)(
    input clk,
    input reset_n,
    input enable,
    input [n-1:0] saturation_value,         // Counts 0 to saturation value so timer count is saturation value + 1
    output done
);

    reg [n-1:0] Q_next, Q_reg;
    
    always @(posedge clk or negedge reset_n)
    begin
        if(!reset_n)
            Q_reg = 'b0;
        else if(enable)
            Q_reg <= Q_next;
        else
            Q_reg <= Q_reg;
    end
    
    assign saturation = Q_reg == saturation_value;
    
    always @(*)
    begin
        Q_next = saturation ? 'b0 : Q_reg + 1;
    end
    
endmodule






