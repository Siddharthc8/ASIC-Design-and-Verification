`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2025 10:51:43 AM
// Design Name: 
// Module Name: tb_interface_class
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

// An interface class does not inherit properties of the class but only method signatures(names)
// Can implement multiples interface classes
// Primarily for reusability
// All the methods in the Interface class must be implemented


module tb_interface_class();    

    
    interface class base;        // Cannot have properties or other words placeholders
     
        pure virtual function void create_me();    //  Must be pure virtual method
        
    endclass
    
    interface class parent;
    
        pure virtual function void new_me();
        
    endclass

    
    class child implements base, parent;      // Can Implement multiple classes
        
        virtual function void create_me();
        $display("From create_me from base");
        endfunction
        
        virtual function void new_me();        // Both the functions must have virtual keyword
        $display("From new_me from parent");
        endfunction
    
    endclass
    
    
    // Main module 
    
    child c;
    
    initial begin
        c  = new();
        c.create_me();
        c.new_me();
    end
    
    
endmodule
