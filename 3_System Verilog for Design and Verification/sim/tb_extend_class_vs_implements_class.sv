`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2025 10:51:25 AM
// Design Name: 
// Module Name: tb_extend_class_vs_implements_class
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


module tb_extend_class_vs_implements_class();

    interface class int_base;        // Cannot have properties or other words placeholders
     
        pure virtual function void create_me();    //  Must be pure virtual method
        
    endclass
    
    interface class int_parent;
    
        pure virtual function void new_me();
        
    endclass

    
    class int_child implements int_base, int_parent;      // Can Implement multiple classes
        
        virtual function void create_me();
        $display("From create_me from int_base");
        endfunction
        
        virtual function void new_me();        // Both the functions must have virtual keyword
        $display("From new_me from int_parent");
        endfunction
    
    endclass
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    virtual class vir_base;        // Cannot have properties or other words placeholders
     
        pure virtual function void create_me();    //  Maybe be virtual or pure virtual method
        
        virtual function void new_me();           // Can contain plain virtual method
        endfunction
        
    endclass

    
    class vir_child extends vir_base;      // Can extends only one class
        
        virtual function void create_me();
        $display("From create_me from vir_base");
        endfunction
        
        virtual function void new_me();        // Both the functions must have virtual keyword
        $display("From new_me from vir_parent");
        endfunction
    
    endclass
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Main module 
    
    int_child ic;
    vir_child vc;
    
    initial begin
    
        // Interface class
        ic  = new();
        ic.create_me();
        ic.new_me();
        
        // Virtual class
        vc = new();
        vc.create_me();
        vc.new_me();
        
    end
    
    
endmodule