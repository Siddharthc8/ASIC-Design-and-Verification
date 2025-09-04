`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2024 10:54:03 AM
// Design Name: 
// Module Name: tb_constraint_weighted_distribution
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


module tb_constraint_weighted_distribution();

class First;
  
rand bit wr; // :=
rand bit rd; // :/
  
  rand bit [1:0] var1;
  rand bit [1:0] var2;
  
  constraint data {
  
    var1 dist {0 := 30, [1:3] := 90};   //0 --> 30 / 30 + (90*3),     1 --> 90/300   2 --> 90/300  3 --> 90/300
    
    var2 dist {0 :/ 30, [1:3] :/ 90}; //0 --> 30/ 90+30 ,             1 --> 30/90   2 --> 30/90  3 --> 30/90
  
  } 
  
  constraint cntrl {
  
    wr dist {0 := 30 , 1 := 70};    // 0 --> 30/70+30     1 --> 70/30+70
    
    rd dist {0 :/ 30 , 1 :/ 70};    // 0 --> 30/70+30     1 --> 70/30+70
  
  }  
 
endclass
  
  First f;
  
  initial begin
    f = new();
    
    for(int i = 0; i < 15; i++) begin
      f.randomize();
      $display("Value of Var1(:=) : %0d and Var2(:/) : %0d", f.var1, f.var2);    
    end
    
  end
   
endmodule
