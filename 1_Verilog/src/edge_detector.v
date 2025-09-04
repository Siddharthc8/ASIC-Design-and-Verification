`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2024 06:18:09 PM
// Design Name: 
// Module Name: edge_detector
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


module edge_detector(
    input clk, reset_n,
    input level,
    output p_edge, n_edge, edge_detected
    );
    
        
    reg [1:0] c_s, n_s;
    parameter s0 = 0, s1 = 1;
    
    always @(posedge clk, negedge reset_n)
    begin
        if(!reset_n)
            c_s <= s0;
        else
            c_s <= n_s;
    end 
    
    always @(*)
    begin 
        case(c_s)
            s0: if(level)
                    n_s = s1;
                else
                    n_s = s0;
            s1: if(level)
                    n_s = s1;
                else
                    n_s = s0;
            default: n_s = s0;
        endcase
    end
    
    assign p_edge = (c_s == s0) & level;
    assign n_edge = (c_s == s1) & ~level; 
    assign edge_detected = p_edge | n_edge;

endmodule
