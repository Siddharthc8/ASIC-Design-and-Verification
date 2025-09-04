`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2024 12:28:59 AM
// Design Name: 
// Module Name: tb_rand_c_limitatations
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


module tb_rand_c_limitatations();

class Generator;
  
  randc bit [3:0] a,b; 
  bit [3:0] y;
  
  int min;
  int max;
  
  function void pre_randomization(input int min=0, input int max=0);
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
    
    $display("SPACE 1");           
    g.pre_randomization(3,12);
    for(i = 0; i<6;i++)begin
      g.randomize();
      g.post_randomization();
      #10;
    end
    $display("SPACE 2");       // Space 1 and 2 will have repeated values as a new bucket of values is created everytime we call randc
    g.pre_randomization(3,12);     
     for(i = 0; i<6;i++)begin
      g.randomize();
      g.post_randomization();
      #10;
    end                              // Space 1 and 2 will have repeated values as a new bucket of values is created everytime we call randc
    
  end
  
endmodule