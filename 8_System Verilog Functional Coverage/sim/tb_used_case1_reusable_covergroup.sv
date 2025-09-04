`timescale 1ns / 1ps




module tb_used_case1_reusable_covergroup();

  reg [3:0] addr;
  integer i = 0;
  
  //lower : 0 - 3
  /// mid : 4- 11
  //high : 12- 15
  
  covergroup check_addr (ref logic [3:0] var_name, input int lower, input int higher, input string instance_name);
    option.per_instance = 1;
    option.name = instance_name;
    
    coverpoint var_name {
      bins f[] = {[lower: higher]};
    } 
  endgroup
 
 
  initial begin
    check_addr cla = new(addr, 0, 3, " Checking Lower Range Addr Hits");
    check_addr cma = new(addr, 4, 11, " Checking Mid Range Addr Hits");
    check_addr cha = new(addr, 12, 15, " Checking Higher Range Addr Hits");
    
    for (i = 0; i <20; i++) begin
      addr = $urandom();
      cla.sample();
      cma.sample();
      cha.sample();
      #10;
    end
    
    
  end
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #200;
    $finish();
  end

 
endmodule