`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 12:42:07 PM
// Design Name: 
// Module Name: swap_fsm
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


module swap_fsm(
    input clk, reset_n,
    input swap,
    output w,
    output [1:0] sel
    );
    
    reg [1:0] c_s, n_s;
    parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3;
    
    always @(posedge clk, negedge reset_n)
    begin
        if(~reset_n)
            c_s <= s0;
        else
            c_s <= n_s;
    end
    
    always @(*)
    begin
        n_s = c_s;
        case(c_s)
            s0: if (~swap) n_s = s0;
                else n_s = s1;
            s1: n_s = s2;
            s2: n_s = s3;
            s3: n_s = s0;
            default: n_s = s0;
        endcase                        
    end
    
    // Output logic
    assign sel = c_s;
    assign w = (c_s != s0);
    
endmodule
