module tb_a21();

  reg [3:0] a, b;
  wire [4:0] s;
  
  a21 dut (a, b, s);
  
  initial begin
    for(int i = 0; i < 10; i++) begin
      a = $urandom;
      b = $urandom;
      #10;
    end    
  end
  
  always @(*) 
  begin
    A1: assert (s == (a + b)) $info("A1: Assertion Passed at %0t", $time);
    else $info("A1:Assertion Failed");  
  end
  
   initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    //$assertvacuousoff(0);
    #110;
    $finish();
  end
  
  
endmodule