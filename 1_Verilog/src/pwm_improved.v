`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2024 03:12:18 PM
// Design Name: 
// Module Name: pwm_improved
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


module pwm_improved
    #(parameter n=8, timer_bits = 15)(
    input clk,
    input reset_n,
    input [n:0] duty,   // Mention Duty cycle number Change from basic
    input [timer_bits-1:0] saturation_value,
    output pwm_out
    );
    
    wire tick;
    
    // Up counter
    reg [n-1:0] Q_reg, Q_next;
    reg D_reg, D_next;
    
    always @(posedge clk or negedge reset_n)
    begin
        if(!reset_n) begin
            Q_reg <= 'b0;
            D_reg <= 'b0;
        end
        else if(tick) begin
            Q_reg <= Q_next;
            D_reg <= D_next;
        end
        else begin
            Q_reg <= Q_reg;
            D_reg <= D_reg;
        end
    end
    
    // Next State Logic
    always @(*)
    begin
        Q_next = Q_reg + 1;   
        D_next = (Q_reg < duty);
    end
    
    // Output Logic
    assign pwm_out = D_reg;
    
    // Timer
    timer_input #(.n(timer_bits)) timer0(
        .clk(clk),                    
        .reset_n(reset_n),                
        .enable(1'b1),                 
        .saturation_value(saturation_value),
        .saturation(tick)
        );            
endmodule
