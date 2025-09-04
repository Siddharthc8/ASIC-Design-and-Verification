`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2024 02:13:32 AM
// Design Name: 
// Module Name: clkdiv2
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


module clkdiv2(
    input clk,rst,
    output f2,f4,f8
    );
    
    reg [3:0] count;
    
    always @(posedge clk, posedge rst)
        if(rst)
            count <= 0;
            
        else begin
        
            if(count == 4'd15)
            count <= 0;
            else 
            count = count + 1;
            
        end
        
     assign f2 = count[0];
     assign f4 = count[1];
     assign f8 = count[2];
     assign f2 = count[0];

endmodule
