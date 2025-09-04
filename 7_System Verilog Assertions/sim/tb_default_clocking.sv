`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2024 04:01:00 PM
// Design Name: 
// Module Name: tb_default_clocking
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

module tb_default_clocking();
 
reg clk = 0;
 
 
reg req = 1;
reg ack = 0;
 
 
 
initial begin
#5;
ack = 1;
#5;
ack = 0;
end
 
 
always #2 clk = ~clk;
 
clocking c1
@(posedge clk);
endclocking
 
 
clocking c2
@(negedge clk);
endclocking
 
 
/*
default clocking c1
@(posedge clk);
endclocking
*/
 
 
default clocking c1;    // Makes c1 as the default clock
 
 
 
 
A1 : assert property ( req |-> ack) $info("A1 Suc at %0t", $time);
 
A2 : assert property ( req |-> ack) $info("A2 Suc at %0t", $time);
 
A3 : assert property ( req |-> ack) $info("A3 Suc at %0t", $time);
 
 
 
initial begin
$dumpfile("dump.vcd");
$dumpvars;
#20;
$finish();
end
 
endmodule
