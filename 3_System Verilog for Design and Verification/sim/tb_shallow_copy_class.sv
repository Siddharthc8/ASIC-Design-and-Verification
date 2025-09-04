`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 10:42:41 PM
// Design Name: 
// Module Name: tb_shallow_copy_class
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

// When a class(X) is copied to another class(X) the handler(Y) within the class pointing to another classY will not be copied
// Instead the original and the copy class point to the same handler(Y) which reflects changes in both the original and the copy

module tb_shallow_copy_class();

class First;

    int data = 12;
    
endclass

class Second;
    
    int ds = 34;
    
    First f1;    
    function new();
        f1 = new();
    
    endfunction
    
endclass
    
  First f1, f2;
  
  initial begin
    
    f1 = new();
    f2 = new();
    
    f1 = f2;     // Direct link so any changes made to one of them will aslo be reflected onto the other
    
    f1.data = 24; // This will reflect on both f1 and f2 as we have linked them both
        
    $display("F1 data: %0d",f1.data);     // f1 data is changed 
    $display("F2 data: %0d",f2.data);     // Reflects on f2 as well even if f1 is the destination
    
  end
  
  // ............................//

    Second s1, s2;
    
    initial begin
        #10;
        s1 = new();        
             
        s2 = new s1;      // Creates a separate copy of all the data memebers except for the handlers inside the class
        
        s1.f1.data = 56;                 // We are changing S1's F1
        
        $display("s1's Data changed from s1: %0d",s1.f1.data);     // S1's F1 changes
        $display("s2's Data changed from s1: %0d",s2.f1.data);     // S2's F1 also changes
        
        s2.f1.data = 128;
        
        $display("s1's Data changed from s2: %0d",s1.f1.data);     // S1's F1 changes
        $display("s2's Data changed from s2: %0d",s2.f1.data);
        
        s1.ds = 45;
        $display("s1's ds Data changed from s1: %0d",s1.ds);
        $display("s2's ds Data changed from s1: %0d",s2.ds);
        
    end

endmodule















