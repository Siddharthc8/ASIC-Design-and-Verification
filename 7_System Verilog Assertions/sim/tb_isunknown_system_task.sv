module tb_isunknown_system_task();

 reg [3:0] a; //Data Signal
 reg clk = 0; // Clock
 reg rst =0;
 
 
 always #5 clk = ~clk; ///Generation of 10 ns Clock
 
 ////Random Stimuli for a
 initial begin
 #4;
 a = 4'b0001;
 #10;
 a = 4'b000z;
 #10;
 a = 4'b1111;
 #10;
 a = 4'b000z;
 #10;
 a = 4'b0000;
 #10;
 a = 4'bzzzx;
 end
 
 
 
 initial begin
 #70;
 $finish;
 end
 
// Checks for even a single occurance of "x" or "z" and returns True if present 
 always@(posedge clk)
 begin
 $display("Value of a: %4b , $isunknown : %0b @ time: %0t", $sampled(a),$isunknown(a), $time);
 end
 
 
endmodule