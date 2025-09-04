`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 11:44:09 PM
// Design Name: 
// Module Name: traffic_light_controller
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


module traffic_light_controller(
    input clk, reset_n,
    input Sa, Sb,
    output reg Ra, Ya, Ga,
    output reg Rb, Yb, Gb
    );
    
    reg [3:0] c_s, n_s;
    localparam s0=0, s1=1, s2=2, s3=3,
               s4=4, s5=5, s6=6, s7=7,
               s8=8, s9=9, s10=10,
               s11=11,  s12=12;
    
    // Sequential logic
    always @(posedge clk, negedge reset_n)
    begin
        if(!reset_n)
            c_s <= s0;
        else 
            c_s <= n_s;
    end
    
    always @(*)
    begin
        n_s = c_s;
        case(c_s)
            s0, s1, s2, s3, s4, s6, s7, s8, s9, s10: 
                n_s = c_s + 1;
            s5: if(~Sa)
                    n_s = s5;
                else 
                    n_s = s6;
            s11: if(~Sa & Sb)
                    n_s = s11;
                 else if(Sa | ~Sb)
                    n_s = s12;
            s12: n_s = s0;
            
            default: n_s = s0;
        endcase
    end
    
    // Output Logic
    always @(*)
    begin
        Ra = 1'b0;
        Ya = 1'b0;
        Ga = 1'b0;
        Rb = 1'b0;
        Yb = 1'b0;
        Gb = 1'b0;
        
        case(c_s)
            s0, s1, s2, s3, s4, s5: 
                begin
                    Ga = 1'b1;
                    Rb = 1'b1;    
                end
            s6: 
                begin
                    Ya = 1'b1;
                    Rb = 1'b1;
                end
            s7, s8, s9, s10, s11:
                begin
                    Ra = 1'b1;
                    Gb = 1'b1;      
                end  
            s12: 
                begin
                    Ra = 1'b1;
                    Yb = 1'b1;
                end
        endcase
    end
endmodule



















