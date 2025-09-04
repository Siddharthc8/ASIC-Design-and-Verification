`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2024 10:49:19 PM
// Design Name: 
// Module Name: synchronizer
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


module synchronizer
    #(parameter stages = 2)(
    input clk, 
    input reset_n,
    input D,
    output Q
    );
    
    reg [stages-1:0] c_s;
    
    always @(posedge clk)
    begin
        if(~reset_n)
            c_s <= 'b0;
        else 
            c_s <= {D, c_s[stages-1:1]};
    end
    
    assign Q = c_s[0];
endmodule
