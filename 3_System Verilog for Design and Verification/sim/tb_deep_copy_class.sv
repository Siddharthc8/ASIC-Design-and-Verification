`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 11:03:23 PM
// Design Name: 
// Module Name: tb_deep_copy_class
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

// Deep copy not only copies the data members but we also have to write down a function to copy the class handler inside the base class 
// The copy function is done using a handler type function method
module tb_deep_copy_class();

class First;
    
    int data = 12;
    
    function First copy();           //  Handler type function creation is required to copy all the 
        copy = new();                // Treat like a handler of class First 
        copy.data = data;            // Then assign copy calues
     endfunction
    
endclass

class Second;

    int ds = 34;
     
     First f1;
     
     function new();        // To accomodate another class's handler
        f1 = new();
     endfunction
     
     function Second copy();
        copy = new();
        copy.ds = ds;
        copy.f1 = f1.copy();         // To allocate space for the Generator handler / class
     endfunction

endclass
    
    Second s1, s2;
    
    
    initial begin
        s1 = new();
        s2 = new();
        
        s2 = s1.copy();
        
        $display("Value of s2.ds : %0d", s2.ds);
        
        s2.ds = 78;
    
        $display("Value of s1.ds : %0d", s1.ds);
        
        s1.f1.data = 98;
    
        $display("Value of s2.f1.data : %0d", s2.f1.data);
        
        s2.f1.data = 29;                          
                                                  
        $display("Value of s1.f1.data : %0d", s1.f1.data);
    end
endmodule
