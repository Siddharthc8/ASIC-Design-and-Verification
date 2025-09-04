`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 06:08:49 PM
// Design Name: 
// Module Name: timer_parameter
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


module timer_parameter     // Timer does not care about contents but the time it takes to complete the count cycle
    #(parameter saturation_value = 255)(
    input clk,
    input reset_n,
    input enable,
    //output [n-1:0] Q
    output saturation
    );
    
    localparam n = $clog2(saturation_value);
    
    reg [n-1:0] Q_next, Q_reg;
    
    always @(posedge clk, negedge reset_n)
    begin
        if(!reset_n)
            Q_reg <= 'b0;
        else if(enable)
            Q_reg <= Q_next;
        else
            Q_reg <= Q_reg;
    end
    
    assign saturation = Q_reg == saturation_value;   // sets saturation to 1 when Q_reg reaches the saturation_value
    
    always @(*)
    begin
        Q_next = saturation? 'b0 : Q_reg + 1;   
    end
    
endmodule
