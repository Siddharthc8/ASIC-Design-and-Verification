`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/20/2024 03:58:47 PM
// Design Name: 
// Module Name: tb_consecutive_repetiton_operator
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


module tb_consecutive_repetiton_operator();

 
 reg clk = 0;
 
 reg req1 = 0;
 reg req2 = 0;
 reg psel = 0;
 reg penable = 0;
 int delay1 = 0, delay2 = 0;
 
 
 
 always #5 clk = ~clk;
 
 initial begin
 for(int i = 0; i < 4; i++)
 begin
 delay1 = $urandom_range(4,8);
 #4;
 req1 = 1;
 #23;
 req1 = 0;
 #30;
 end
 end
 
 initial begin
 for(int i = 0; i < 4; i++)
 begin
 delay2 = $urandom_range(3,5);
 #4;
 req2 = 1;
 repeat(delay2) #11;
 req2 = 0;
 #20;
 end
 end
 
 initial begin
    
    #12; 
    psel = 1;
    repeat(3) @(posedge clk);
    penable = 1;
    @(posedge clk);
    penable = 0; 
    psel = 0;
       
 end
 
 //if req1 asserts, then it should remain stable for 2 clock ticks
 // Consecuitive for a Constant Count
 A1: assert property (@(posedge clk) $rose(req1) |-> req1[*2] ) $info("req1 rep suc @ %0t", $time); 
 
 //------------------------------------------------------------------------------------------------------
 
 //if req2 asserts, then it should remain stable for 3 to 5 clock ticks 
 // Consecuitive for a Constant Delay Range
 A2: assert property (@(posedge clk) $rose(req2) |-> req2[*3:5] ) $info("req2 rep suc @ %0t", $time); 
 
 // Psel deasserted after Penable deassert
 // Consecuitive for a Unbounded Delay Range
 A3: assert property (@(posedge clk) $rose(psel) |-> psel[*2:$] ##1 $fell(penable) ) $info("A3 Suc @ %0t", $time);
 else $info("Assertion failed @ %0t", $time);
 
 
 initial begin 
 #250;
 $finish();
 end
 
endmodule


