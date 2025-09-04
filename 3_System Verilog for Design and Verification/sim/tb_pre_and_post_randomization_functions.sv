`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2024 12:05:42 AM
// Design Name: 
// Module Name: pre_and_post_randomization_funcctions
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_pre_and_post_randomization_functions();

class Generator;
  
  randc bit [3:0] a,b; 
  bit [3:0] y;
  
  int min;
  int max;
  
  function void pre_randomization(input int min=0,input int max=0);
    this.min = min;
    this.max = max;  
  endfunction
  
  constraint data {
    a inside {[min:max]};
    b inside {[min:max]};
  }
  
  function void post_randomization();
    $display("Value of a :%0d and b: %0d", a,b);
  endfunction

endclass
 
  int i =0;
  Generator g;
  
  initial begin
    g = new();
    
    for(i = 0; i<10;i++)begin
      g.pre_randomization(3,8);
      g.randomize();
      g.post_randomization();
      #10;
    end
    
  end

endmodule

