`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2025 12:17:59 PM
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


module tb_polymorphism();

class base;

    function void i_am();   
        $display("Base");
    endfunction

endclass

class parent extends base;

    function void i_am();
        $display("Parent");
    endfunction

endclass

class child extends parent;

    function void i_am();
        $display("Child");
    endfunction

endclass

////////////////     MAIN MODULE   /////////////

    base b1 = new();
    parent p1 = new();
    child c1 = new();
    
    initial begin
        
        b1 = p1;       
        b1.i_am();     // Prints "Base" 
                       // Checks the handle if not superior class ie "b1" is checked "p1" is ignored
        p1 = c1;
        p1.i_am();     // Prints "Parent" as that is highest in the hierarchy for now as after the "c" was passed to "p" we did not pass "p" to "b" after that
        
        // NOTE : If "i_am" method not available in parent class it check its superior class ie "Base"
    end


endmodule
