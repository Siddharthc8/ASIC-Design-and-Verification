`timescale 1ns / 1ps




module tb_pass_by_reference();

  reg [3:0] a, b;
  
  integer i = 0;
  
  //                 Type and size are madatory
  covergroup c (ref reg [3:0] varn, input string var_id); // The 1st argument is passed by reference.  2nd is the "Instance" name. ignoring inout will cause error
    option.per_instance = 1;                             // Don't forget to mention the direction of the 2nd argument as direction is mandatory for pass_by_value
    option.name = var_id;                     // Should mention name here as well 
    coverpoint varn;
    
  endgroup 
  
  
 
  c cia = new(a, "Variable a");
  c cib = new(b, "Variable b");
 
  initial begin 
    
    for (i = 0; i <50; i++) begin
      a = $urandom();
      b = $urandom();
      cia.sample();
      cib.sample();
      #10;
    end
    
    
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #500;
    $finish();
  end
  
 
 
 
 
endmodule