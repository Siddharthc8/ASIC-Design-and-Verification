module tb_onecold_system_task();

 reg [3:0] a = 4'b0000;
 reg clk = 0;
 
 always #5 clk = ~clk;
 
 
 
 //////////////onecold 
 initial begin
 for(int i = 0; i< 20 ; i++) begin
 a = $urandom_range(0,15);
 // Checks if there is only a single bit zero present in the variable
 // There is nothing called $onecold. Just the compliment of the variable used with onehot and onehot0
 $display("a:%4b $onecold:%0d @ %0t",a,$onehot(~a),$time);
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