`timescale 1ns / 1ps


// The LHS can only take a signal or a boolean value and the right side can take all and a sequence
// Condition must stay true until the reference sequence and also can exceed the reference sequence

module tb_throughout_matching_operator();

 reg a = 0, b = 0, c = 0; //Data Signal
 reg clk = 0; // Clock
 
 
 always #5 clk = ~clk; ///Generation of 10 ns Clock
 
 
 initial begin
 #28;
 b = 1;
 #30;
 b= 0; 
 end
 
 
 initial begin
 #63;
 c = 1;
 #10;
 c= 0; 
 end
 
 
 initial begin
 #28;
 a = 1;
 #40;
 a = 0; 
 end
 
 /////////reference sequence
 // Question) b should remain stable at 1 thru 3 clock ticks followed by c becoming high. a should be stable during this sequence
 
 sequence seq_bc;
 b[*3] ##1 c;
 endsequence
 
 // "a" should stay high until the seq_bc is true. "a" can hold true eevn after the RHS seq
 A1: assert property (@(posedge clk) $rose(b) |-> a throughout seq_bc) $info("Suc @ %0t", $time);
 
 
 initial begin
 $dumpfile("dump.vcd");
 $dumpvars;
 #150;
 $finish;
 end
 
 
endmodule