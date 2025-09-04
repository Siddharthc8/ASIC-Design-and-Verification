`timescale 1ns / 1ps




module tb_pass_by_value();

  reg [3:0] a, b; /// low - 0 to 3, mid - 4 to 10, high - 11 to 15
  
  integer i = 0;
  
  covergroup c (ref reg [3:0] varn,input string var_id, input int low, input int mid, input int high);
    option.per_instance = 1;      // "varn" is passed by ref and all others as pass_by_value
    option.name = var_id;
    
    coverpoint varn
    {
      bins lower_value = {[0:low]};     // arguments are used here
      bins mid_value =   {[low+1 : mid]};
      bins high_value =  {[mid+1 : high]};
    
    
    }
    
  endgroup 
  
 
  c cia = new(a, "Variable a", 3, 10, 15);
  c cib = new(b, "Variable b", 3, 10, 15);
 
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