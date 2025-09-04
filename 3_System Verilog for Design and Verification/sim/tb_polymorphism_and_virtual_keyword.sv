`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2024 01:50:16 AM
// Design Name: 
// Module Name: tb_polymorphism
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

module tb_polymorphism_and_virtual_keyword();

class First;  ///parent class
  
  int data = 12;
  
  virtual function void display();
     $display("FIRST : Value of data : %0d", data);
  endfunction
  
endclass
 
 
class Second extends First; //child class
  
  int temp = 34;
  int data = 24;
  
  function void add();
    $display("secomd:Value after process : %0d", temp+4);
  endfunction
 
  function void display();
    $display("SECOND : Value of data : %0d", data);
  endfunction
 
endclass
  
  
  First f;
  Second s;
  
  initial begin
    f = new();
    s = new();
    
//    f.add();        // Parent cannot access child class methods 
    
    // BEFORE COPYING
    // Before copying they access the methods in their own class
    f.display();      // Outputs result from first class
    s.display();      // Outputs result from second class
    
    
    // AFTER COPYING         
    f = s;        // ONLY Child's Class similar METHODS are copied to Parent if Virtual keyword is used
    
    // Case 1 --> Virtual keyword NOT USED in function                   // Equal priority to both the methods       
    
    f.display();     // Outputs result from first class
    s.display();     // Outputs result from second class
    
    // Case 2 --> Virtual keyword USED in function                       // Less priority for Virtual
    
    f.display();     // Outputs result from second class
    s.display();     // Outputs result from second class
    
//    f.add();     // Even after copying Second to First, Parent class cannot access methods of Child class

//    $display("Second : Value of data : %0d", s.data);     // Still access its own data member
    
    
  end
  
endmodule