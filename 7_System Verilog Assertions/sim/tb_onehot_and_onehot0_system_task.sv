module tb_onehot_and_onehot0_system_task();

 reg [3:0] a = 4'b0000;
 reg clk = 0;
 
 always #5 clk = ~clk;
 
 
 /////////////onehot and onehot0
 initial begin
 for(int i = 0; i< 20 ; i++) begin
 a = $urandom_range(0,4);
 // $onehot checks if there is a a single bit of 1 in the variable. Returns False for all zeros ie 4'b0000 = False
 // $onehot0 does the same function but returns true for all zeros ie 4'b0000 = True
 $display("a:%0b $onehot:%0d and $onehot0:%0d @ time:%0t",a,$onehot(a),$onehot0(a),$time);
 $display("-----------------------------");
 @(negedge clk);
 end
 end
 
 
 
 
 initial begin
 $dumpfile("dump.vcd"); 
 $dumpvars;
 #120;
 $finish();
 end
 
 
endmodule