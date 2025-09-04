`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2024 11:16:45 AM
// Design Name: 
// Module Name: fsm_counter
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


module fsm_counter(
    input clk,reset_n,
    input en,
    output [2:0] num
    );
    
    reg [2:0] c_s, n_s;
    localparam s0 = 0, s1 = 1, s2 = 2, s3 = 3,
               s4 = 4, s5 = 5, s6 = 6, s7 = 7;
    
    //State register
    always @(posedge clk, negedge reset_n)
    begin
        if(!reset_n)
            c_s <= s0;
        else
            c_s = n_s;
    end
    
    always @(*)
    begin
        if(en)
            case(c_s)
                s0 : n_s = s1;
                s1 : n_s = s2;
                s2 : n_s = s3;
                s3 : n_s = s4;
                s4 : n_s = s5;
                s5 : n_s = s6;
                s6 : n_s = s7;     
                s7 : n_s = s0;
                default: n_s = c_s;
                endcase
         else
            n_s = c_s;
    end
    
    assign num = c_s;
endmodule
