`timescale 1ns / 1ps


// Reference sequence should either enclose or be equal to the LHS signal 

module tb_within_matching_operator();

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
 // Question) b should remain stable at 1 thru 3 clock ticks followed by c becoming high(seq_bc). a should be stable for 4 ticks(seq_a).
 // seq_a should remain stable during seq_bc
 
 
 sequence seq_bc;
 b[*3] ##1 c;
 endsequence
 
 
 sequence seq_a;
 a[*4];
 endsequence
 
 A1: assert property (@(posedge clk) $rose(b) |-> seq_a within seq_bc) $info("Suc @ %0t", $time);
 
 
 initial begin
// $assertvacuousoff(0);
 $dumpfile("dump.vcd");
 $dumpvars;
 #150;
 $finish;
 end
 
 
endmodule