`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2024 07:59:29 PM
// Design Name: 
// Module Name: assertion_types_glitches
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


module assertion_types_glitches();
 
  reg am = 0;
  reg bm = 0;
  reg clk = 0;
  
  wire a, b;
 
  assign a = am;
  assign b = bm;
  
  always #5 clk = ~clk;
 
 initial begin
   am = 1;
   bm = 1;
   #10;
   am = 0;
   bm = 1;
   #10;
   am = 1;
   bm = 0;
   #10; 
 end
  
  always_comb
  begin
//   Immediate assertion
  A1 : assert (a == b) $info("A1:a and b are equal at %0t",$time);
  else $error("A1:assertion failed at %0t",$time);

  // Observed deferred immediate assertion
  A2 : assert #0 (a == b) $info("A2:a and b are equal at %0t",$time);   // Add the #0 which evaluates after 0
  else $error("A2:assertion failed at %0t",$time);
  
  // Final deferred immediate assertion
  A3 : assert final (a == b) $info("A3:a and b are equal at %0t",$time);  // Include the keyword "final"
  else $error("A3:assertion failed at %0t",$time);          // Behaves more like deferred immediate
  
  // Concurrent asertion checks at the mentioned timeframe
  A4: assert property (@(posedge clk) (a == b)) $info("A4:a and b are equal at %0t",$time);
  else $error("A4:assertion failed at %0t", $time);   
  
  end
 endmodule
