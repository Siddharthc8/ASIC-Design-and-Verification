`timescale 1ns / 1ps




module tb_local_variable_use_case2();

  reg [3:0] a = 0, b = 0;
  reg clk = 0, sample = 0;
  wire [4:0] s;
  wire done;
  
  
  top dut (a,b,clk,sample,s,done);
  
  always #5 clk = ~clk;
  
 
  
  integer i = 0;
  
  initial begin
  for( i = 0; i <10; i++) begin
     @(posedge clk);
    a = $urandom();
    b = $urandom();
    sample  = 1'b1;
    @(posedge clk);
    sample  = 1'b0;
    @(posedge done);
    @(posedge clk);
  end
  end
  
  /*
  initial begin
    #8;
    sample = 1'b1;
    #10;
    sample = 1'b0;
    #15;
    sample = 1'b0;
    #10;
    sample = 1'b0;
    #15;
    sample = 1'b1;
    #10;
    sample = 1'b0;
    #15;
    
  end
  */
  
  property p1;
    logic [3:0] lva = 0;
    logic [3:0] lvb = 0;
    logic [4:0] lvs = 0;
    
    ($rose(sample), lva = a, lvb = b, $display("Value of a : %0d and b : %0d",lva,lvb)) |-> ($rose(done)[->1],lvs = s, $display("Value on output bus : %0d", lvs)) ##0 (lvs == lva + lvb);
    
  endproperty
  
  A1 : assert property (@(posedge clk) p1) $info("Suc at %0t",$time); else $error("Fail at %0t", $time);
  
 
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    $assertvacuousoff(0); 
    #120;
    $finish;
  end
  
  
 
  
endmodule