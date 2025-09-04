`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2025 12:08:59 PM
// Design Name: 
// Module Name: tb_virtual
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


module tb_virtual();

class base;

    virtual function void i_am();   // Once virtual is declared here all subclasses can ignore using as it is hierarchical
        $display("Base");
    endfunction

endclass

class parent extends base;

    virtual function void i_am();   // "Virtual" keyword is optional but is used to know that base class is virtual
        $display("Base");
    endfunction

endclass

class child extends parent;

    virtual function void i_am();  // "Virtual" keyword is optional but is used to know that base class is virtual
        $display("Base");
    endfunction

endclass

////////////////     MAIN MODULE   /////////////

    base b1 = new();
    parent p1 = new();
    child c1 = new();
    
    initial begin
        
        b1 = p1;
        b1.i_am();    // Prints "Parent"
                      // Using virtual gives precedence to the sub_class and then to superior ie "p1" is checked first.
        p1 = c1;
        p1.i_am();   // Prints "Child"
        
    end


endmodule
