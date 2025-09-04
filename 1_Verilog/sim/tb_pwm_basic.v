`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2024 11:20:04 AM
// Design Name: 
// Module Name: tb_pwm_basic
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


module tb_pwm_basic();
    localparam n = 8;
    reg clk, reset_n;
    reg [n-1:0] duty;
    wire pwm_out;
    
    pwm_basic #(.n(n)) dut (
        .clk(clk),
        .reset_n(reset_n),
        .duty(duty),
        .pwm_out(pwm_out)
        );
        
        // Clk generation
        localparam T = 10;
        always
        begin
            clk = 1'b0;
            #(T/2);
            clk = 1'b1;
            #(T/2);       
        end
        
        initial begin
            reset_n = 'b0;
            #2;
            reset_n = 'b1;
            
            duty = 0.25 * (2**n);
            repeat(2 * 2**n) @(negedge clk);
            
            duty = 0.50 * (2**n);
            repeat(2 * 2**n) @(negedge clk);
            
            duty = 0.75 * (2**n);
        end
        
        // Stop timer
        initial begin
        #(7 * 2**n * T);
        $stop;
        end
        
endmodule











