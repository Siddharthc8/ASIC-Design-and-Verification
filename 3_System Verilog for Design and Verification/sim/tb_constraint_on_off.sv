`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2024 06:36:09 PM
// Design Name: 
// Module Name: tb_constraint_on_off
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
module tb_constraint_on_off();            // Calling the function "constrain_mode():

class Generator; 
  
  randc bit [3:0] a;
  rand bit ce;
  rand bit rst;
  
  constraint control_rst {
    rst dist {0:= 80, 1 := 20};
  }
  
  
  constraint control_ce {
    ce dist {1:= 80, 0 := 20};
  }
  
  constraint control_rst_ce_implication {
    ( rst == 1 ) -> (ce == 0);    // When rst = 0,    ce = 1 is forced
  }
  
//  constraint control_rst_ce_equality {
//    ( rst == 1 ) <-> (ce == 0);    // When rst = 0,    ce = 1 is forced
//  }                                // When ce = 0,     rst = 1 is forced
   
endclass
 
  
  Generator g;
  int  mode;
  
  initial begin
    g = new();
    
    // To check the constraint mode
    mode = g.control_rst_ce_implication.constraint_mode();  // Should not pass any arguments   Here the ans is 1 as ON by default
    
    // Syntax  --> Handler.constraint_name.constraint_mode(x);    // Where x --> 0 : OFF and 1 : ON
    g.control_rst_ce_implication.constraint_mode(0);   // To turn off a constraint
    
    $display("Constraint Status: %0d ", g.control_rst_ce_implication.constraint_mode());
    
    for (int i = 0; i<10 ; i++) begin
 
      assert(g.randomize()) else $display("Randomization Failed");
      $display("Value of rst : %0b and ce : %0b", g.rst, g.ce);
      
    end
    
  end
 
  
endmodule
