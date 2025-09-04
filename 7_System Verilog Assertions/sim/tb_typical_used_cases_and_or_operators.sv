`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2025 05:22:02 PM
// Design Name: 
// Module Name: tb_typical_used_cases_and_or_operators
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


module tb_typical_used_cases_and_or_operators();

 reg clk = 0,rd,wr,start;
 
 always #5 clk = ~clk;
 
 
 
 
 
 initial begin
 start = 0;
 #20;
 start = 1;
 #10;
 start = 0;
 end
 
 
 initial begin
 wr = 0;
 #30;
 wr = 1;
 #10;
 wr = 0;
 end
 
 initial begin
 rd = 0;
 #40;
 rd = 1;
 #20;
 rd = 0;
 end
 
 
 
 sequence swr;
 wr[*1];
 endsequence
 
 sequence srd;
 ##1 rd[*2];
 endsequence
 
 // Strong qualifier returns a property so can only be used in a property
 property wrrd;
 strong (##[0:$] wr && rd) ; 
 endproperty
 
 ///atleast single read and write cycle during simulation
 A1: assert property (@(posedge clk) $rose(start) |=> swr and srd ) $info("suc at %0t",$time);
 
 /////read and write should not occur at same time
 A2: assert property (@(posedge clk) $rose(start) |=> not(wrrd) ) $info("A2 suc at %0t",$time);
 
 
 
 
 initial begin
 $dumpvars;
 $dumpfile("dump.vcd");
// $assertvacuousoff(0);
 #110;
 $finish;
 end
 
 
endmodule