`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 07:39:55 PM
// Design Name: 
// Module Name: tb_custom_class_copying_method
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

// This method is for a class containing objects of another class and for deep copying
module tb_custom_class_copying_method();

class First;

    int data = 34;
    bit [7:0] temp = 8'h11;
    
    // Custom copy method   
    // Think of this method to be calling a Class handler in function style  --> First copy();     also "First" is the return data type
    function First copy();   // The output return type is of the class object "First"
        copy = new();        // Since the return type is of the class type we gotta use a constructor to use it
        copy.data = data;
        copy.temp = temp;
    endfunction

endclass

//...........................
    First f1;
    First f2;
    
    initial begin
        f1 = new();
        f1.data = 45;
       
        f2 = new();      // To access the contents of class First
        f2 = f1.copy();  // Equivalent expression f2 = new f1;
        
        $display("Data : %0d and Temp : %0x", f2.data, f2.temp); 
        
    end

endmodule
