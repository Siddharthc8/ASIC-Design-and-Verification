module tb_changed_and_stable_system_task();

 reg [2:0] a = 0;
 reg clk = 0;
 
 always#5 clk = ~clk;
 
 
 initial begin
 
 for(int i = 0; i < 15; i++ ) begin
 
 a = $urandom_range(0,3);
 
 @(posedge clk);
 
 end
 
 end
 
 
 
 
 always@(posedge clk)
 
 begin
 // Checks if the variable changed from the last triggering point ir posedge in our case
 $display("Value of a:%0b $changed(a):%0b $stable(a):%0b @ %0t", a, $changed(a),$stable(a), $time); 
 // Records even a single bit change or in other words variable should be exactly the same
 $display("-------------------------------------------------------------"); 
 
 end
 
 
 
 initial begin
 
 #100;
 
 $finish;
 
 end
 
 
 
endmodule