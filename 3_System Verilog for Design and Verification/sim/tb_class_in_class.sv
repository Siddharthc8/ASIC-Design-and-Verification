`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 05:36:25 PM
// Design Name: 
// Module Name: tb_class_in_class
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

class First;
    int data = 34;
    local int local_data = 34;                  // Cannot be read or written outside this class or can't be inherited
    
    task set(input int local_data);       // This helps access the local variables through this function enbaling chage of local variables value explicitly if needed
        this.local_data = local_data;
    endtask
    
    function int get();
        return local_data;
    endfunction
    
    task disp();
        $display("The value of data: %0d",data);
    endtask
endclass

class Second;
    
    First f1;                      // Create a hancler inside the class first
    function new(); 
        f1 = new();                // Create an object of the class inside the class's constructor 
    endfunction                    // So whenever you create an object of this class the an object of the first class is also created
endclass

module tb_class_in_class();
    Second s1;    
    
    initial begin
        s1 = new();                // Here object of class second s1 has also created an onject of class first
        $display("The value of data: %0d", s1.f1.data);
        s1.f1.disp();              // Since the object of first is inside the constructor of class second 
                                   // it can only be accessed through the handler of class second
        
        s1.f1.data = 50;           // Also values can be changes
        s1.f1.disp();
//        $display("The value of data: %0d", s1.f1.local_data);    // This line is throwing an error because the scope of the local variable is only within the class
        s1.f1.set(123);                                             // We are updating the value of the local variable using the special function
        $display("The value of data: %0d", s1.f1.get());           // The function helps access the value of a local variable 
        
    end

endmodule
