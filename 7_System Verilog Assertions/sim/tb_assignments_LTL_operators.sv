`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2025 09:39:14 PM
// Design Name: 
// Module Name: tb_assignments_LTL_operators
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


module tb_assignments_LTL_operators();

reg clk =0;
reg wr = 0, rd = 0;
reg rst = 0, ce = 0;

always #5 clk = ~clk;

initial begin

//    #10;
//    wr = 0;
//    #10;
//    rd = 1;
//    wr = 0;
//    #10;
//    rd = 1;
//    #10;
//    rd = 0;
//    #20 $finish;
end
   initial begin
    rst = 1;
     repeat(4) @(negedge clk);
     rst = 0;
     ce = 1;
     #50 $finish;
  end

// A91) Create a Single thread that will verify user must first write the data to RAM before reading. 
// " There must be at least single write request (wr) before the arrival of the read request (rd)"
initial A91 : assert property ( @(posedge clk) $rose(wr)[*1] |-> ##[*] $rose(rd)  ) $info("Suc at %0t", $time);
//---------------------------------------------------------------------------------------------------------------------

// A92) RST remain asserted until CE become active high.
initial A92 : assert property ( @(posedge clk) rst until ce)$info("Suc at %0t", $time);
//---------------------------------------------------------------------------------------------------------------------

// A93) CE must assert after sixth clock tick.
initial A93 : assert property( @(posedge clk) ##[6:$] rst ) $info("success at %0t ",$time);

initial A93_0 : assert property (@(posedge clk) nexttime[6] rst ) $info("success at %0t ",$time);

initial A93_1 : assert property( @(posedge clk) !rst ##[6:$] rst ) $info("success at %0t ",$time);

A93_2 : assert property( @(posedge clk) $fell(rst) |-> ##[6:$] $rose(rst) ) $info("success at %0t ",$time);

initial A93_3 : assert property (@(posedge clk) !rst[*6] ##1 rst ) $info("success at %0t ",$time);

initial A93_4 : assert property (@(posedge clk) $rose(rst) |=> ($stable(rst)==0) ) $info("success at %0t ",$time); // NOT Working
//---------------------------------------------------------------------------------------------------------------------

// A94) RST must become low after 4 clock tick.
A94 : assert property( @(posedge clk) ##[4:$] $fell(rst) ) $info("Suc at %0t", $time);

initial A94_0 : assert property (@(posedge clk) nexttime[4] !rst ) $info("success at %0t ",$time);

initial A94_1 : assert property( @(posedge clk) rst ##[4:$] !rst ) $info("success at %0t ",$time);

A94_2 : assert property( @(posedge clk) $rose(rst) |-> ##[4:$] $fell(rst) ) $info("success at %0t ",$time);

initial A94_3 : assert property (@(posedge clk) rst[*4] ##1 !rst ) $info("success at %0t ",$time);

initial A94_4 : assert property (@(posedge clk) $fell(rst) |=> ($stable(rst)==1) ) $info("success at %0t ",$time); // NOT Working
//---------------------------------------------------------------------------------------------------------------------

// A95) CE must become high immediately if reset deassert. Property must failed if rst never become high.
initial A95 :  assert property( @(posedge clk) (rst and !ce) s_until (!rst and ce) )$info("success at %0t ",$time); 
  else $error("Failed at %0t", $time);    // NOTE --------------------------------------------------------------------> Perfect and Simple  
  
A95_0 :  assert property( @(posedge clk) $fell(rst) |-> strong(##0 (ce)) )$info("success at %0t ",$time); 
else $error("Failed at %0t", $time); // Does not account if ce rose before

A95_1 :  assert property( @(posedge clk) $fell(rst) |-> strong(##0 $rose(ce)) )$info("success at %0t ",$time); 
else $error("Failed at %0t", $time); // Accounts for failure even if ce rose before but fail message with 1 cycle delay

// Student example ( Wrong )
//sequence ce_immediate_assertion; 
//( @(posedge clk) assert(event !rst) imply (event nexttime @(posedge clk) ce);  // student example
//endsequence

initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
//    $assertvacuousoff(0);
  end
endmodule

