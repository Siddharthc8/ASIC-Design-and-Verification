`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2025 09:41:06 PM
// Design Name: 
// Module Name: tb_typical_used_cases_matching_operators
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


module tb_typical_used_cases_matching_operators();

reg clk = 0;
reg cs;
reg sclk;
reg dout;
reg ce;
reg start, stop;
reg a, b;
reg rst;
reg req;
reg load, ack;
reg wr, rd;




always #5 clk = ~clk;

// 1) sclk must toggle for entire duration of !cs
A1 : assert property ( @(posedge clk) $fell(cs) |=> !cs throughout ($changed(sclk)) );
A1_1 : assert property ( @(posedge clk) !cs |=> !cs throughout ($changed(sclk)) );

// 2) dout must count up as long as ce is true
A2 : assert property ( @(posedge clk) ce |=> ce throughout (dout == $past(dout) + 1) );

// 3) Two req from a and three req from b must complete at the same time. Assume start to be the antecedent
A3 : assert property ( @(posedge clk) $rose(start) |-> a[->2] intersect b[->3] );

// 4) a must hold till master received three requests from b.  Assume start to be the antecedent
A4 : assert property ( @(posedge clk) $rose(start) |-> a throughout b[->3] );

// 5) rst must remain deasserted for atleast read and write req
A5 : assert property ( @(posedge clk) $fell(rst) |-> !rst throughout (a[->1] and b[->1]) );

// 6) req must be followed by ack after completion of data transfer.
// Load must assert at the same clock tick when ack is received.
A6 : assert property ( @(posedge clk) req ##1 ack[->1] intersect load[->1] );

// 7) There must be atleast one write and one read request within ce if ce asserted
A7 : assert property ( @(posedge clk) $rose(ce) |-> ce throughout (wr[->1] and rd[->1]) );

// 8) Between start and stop, there must be atleast one request followed by ack
A8 : assert property ( @(posedge clk) $rose(start) |-> ( req[->1] ##1 ack ) within $rose(stop) );

// 9) Read and write must not occur at the same time
A9 : assert property ( @(posedge clk) $rose(rd) |-> not(wr[->1]) within rd[*2] );




endmodule
