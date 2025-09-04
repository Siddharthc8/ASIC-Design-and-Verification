`timescale 1ns / 1ps


module tb_bind_adder();

  reg [3:0] a = 0,b = 0;
  wire [4:0] y;
  
  bind_adder dut (a,b,y);
  
  // Used to bind the assertion file with the testbench module
  bind bind_adder bind_adder_assert dut2 (a,b,y); // Syntax :: bind  design_file  assertion_file  dut (x,x,x);
  
  initial begin
    for(int i =0; i < 15; i++)
      begin
        a = $urandom();
        b = $urandom();
        #20;
      end
  end
  
  initial begin
   $dumpfile("dump.vcd");
   $dumpvars;
//   $assertvacuousoff(0);
   #350;
   $finish;
 end
  
  
  
endmodule