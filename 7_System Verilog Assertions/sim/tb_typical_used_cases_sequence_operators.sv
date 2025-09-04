`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2025 02:15:16 PM
// Design Name: 
// Module Name: tb_typical_used_cases_sequence_operators
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


module tb_typical_used_cases_sequence_operators();
  
  reg clk = 0;
  reg a , b = 1;
  reg rst = 0;
  reg wr, rd = 1;
  reg timeout = 100;
  reg n = 5;
  reg ce = 0;
  reg req, ack;
  reg ready, done;
  reg addr;
  
  always #5 clk = ~clk;
  
  // 1) Write request must be followed by Read request. If Read does not assert before timeout, the system should reset
  A1 : assert property ( @(posedge clk) (!rst[*1:$] ##1 timeout) |-> rst );
  
  // for multiple timeouts 
  A1A : assert property ( @(posedge clk) (!rst[*1:$] ##1 timeout)[*3] |-> rst ); 
  
  // 2) Write must be followed by Read  
  A2 : assert property ( @(posedge clk) $rose(wr) |-> ##1 $rose(rd) );
  
  // 3) If a is asserted b must assert in five clock ticks
  A3 : assert property ( @(posedge clk) $rose(a) |-> ##5 $rose(b) ); 
  
  // 4) If rst deasserted then CE must be asserted within 1 to 3 clock ticks
  A4 : assert property( @(posedge clk) $fell(rst) |-> ##[1:3] $rose(ce) );
  
  // 5) If req asserted and ack not received in three clock ticks then req must deassert
  A5 : assert property ( @(posedge clk) $rose(req) ##1 !ack[*3] |-> $rose(req) );
  
  // 6) If a asserted a must reamian high for 3 clock ticks
  A6 : assert property ( @(posedge clk) $rose(a) |-> a[*3] );
  
  // 7) System operations must start with rst asserted for three consecutive clock ticks
  initial A7 : assert property ( @(posedge clk) rst[*3] );
  
  // 8) CE must assert somewhere during simulation if reset deasserted 
  A8 : assert property ( @(posedge clk) $fell(rst) |-> ##[1:$] $rose(ce) ); 
  
  // 9) Transaction start with CE become high and ends with CE become low. Each transaction must contain atleast one RD and one WR
  A9 : assert property ( @(posedge clk) $rose(ce) |-> (rd[->1] and wr[->1]) ##1 !ce ); // Ce must be zero immediately after wr and rd asserted
  
  // 10) If CE assert somewhere after rst deassert then we must receive atleast one write req
  A10 : assert property ( @(posedge clk) $fell(rst) ##[1:$] $rose(ce) |-> wr[->1] ##1 !wr );
  
  // 11) a must assert twice during simulation
  A11 : assert property ( @(posedge clk) a[->2] );
  
  // 12) If a asserted somewhere then b must become high in the immediate next clock tick(nearest)
  A12 : assert property ( @(posedge clk) $rose(a) |=> $rose(b) );
  
  // 13) If Req is received and data transfer ending is marked with Done then Ready must be high in the next clock tick
  A13 : assert property ( @(posedge clk) $rose(req) ##1 done[->1] |-> ##1 ready );
  
  // A71) If b deasserts, b must remain low for three consecutive ticks. Evaluate the property on the positive edge of the clock.
  A71 : assert property ( @(posedge clk) $fell(b) |-> !b[*3] );
  
  // If CE assert then it must deassert within 5 to 10 clock cycles. Evaluate the property on positive edge of the clock.
  A72 : assert property ( @(posedge clk) $rose(ce) |-> ##[5:10] $fell(ce) );
  
  // When CE becomes high, it must remain high for 7 consecutive cycles. Evaluation of the property at positive edge of the clock signal.
  A73 : assert property ( @(posedge clk) $rose(ce) |-> ce[*7] );
  
  // A74) 1)If rst deassert and CE assert then read must stay high for two clock ticks when user recieve rd request. 
  // 2) If rd assert then addr must remain stable for two consecutive clock ticks. 
  A74_1 : assert property ( @(posedge clk) $fell(rst) and $rose(ce) |-> ##[1:$] $rose(rd) |-> rd[*2] ); 
                                      // or  //
  P1: assert property (@(posedge clk) disable iff(rst) $rose(ce) |-> ( ##[1:$] ##1 rd[*2] ) ) $info(" P1 Succ at %0t",$time);
                                       
  A74_2 : assert property ( @(posedge clk) $rose(rd) |-> addr[*2] );
                                      // or  //
  P2: assert property (@(posedge clk) $rose(rd) |=> $stable(addr)) $info("P2 Succ at %0t",$time);  // Checks the current clock cycle and the previous
  
                                        
  initial begin
  #110;
  $finish;
  end
  
endmodule
