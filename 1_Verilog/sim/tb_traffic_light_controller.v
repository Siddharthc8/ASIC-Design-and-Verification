`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2024 12:42:48 AM
// Design Name: 
// Module Name: tb_traffic_light_controller
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


module tb_traffic_light_controller();
    reg clk, reset_n;
    reg Sa, Sb;
    wire Ra, Ya, Ga, Rb, Yb, Gb;
    
    // Instantiation
    traffic_light_controller TRAFFIC_LIGHT (
        .clk(clk),
        .reset_n(reset_n),
        .Sa(Sa),
        .Sb(Sb),
        .Ra(Ra),
        .Ya(Ya),
        .Ga(Ga),
        .Rb(Rb),
        .Yb(Yb),
        .Gb(Gb)
    );
    
    // For readability
    wire [1:0] light_A, light_B;
    
    localparam R = 0;
    localparam Y = 1;
    localparam G = 2;
    
    assign light_A = Ra? R: Ya? Y: Ga? G: light_A;
    assign light_B = Rb? R: Yb? Y: Gb? G: light_B;
    // Clock
    localparam T = 10;
    always
    begin
        clk = 1'b0;
        #(T/2);
        clk = 1'b1;
        #(T/2);
    end

    initial 
    begin
        // Reset
        reset_n = 1'b0;
        #2;
        reset_n = 1'b1;
        
        // No cars in either streets
        Sa = 0;
        Sb = 0;
        #80;
        
        // No cars at A but B
        Sa = 0;
        Sb = 1;
        #100;
        
        // Cars in both streets
        Sa = 1;
        Sb = 1;
        #300; 
        
        // Car appears at B, then no cars at either streets
        Sa = 0;
        Sb = 1;
        #20;
        Sa = 0;
        Sb = 0;
        
        #200 $finish;
    end     
endmodule
