`timescale 1ns/1ps

class first;
  
  reg [2:0] data; 
  reg [1:0] data2;
  
  
endclass
 
 
module tb_basic_class_rules();
  
  first f;            // To create a class handler
  
  initial begin
    f = new();        // Creating a constructor for a class
    f.data = 3'b010;   // Acessing the properties of a class
    f.data2 = 2'b10;  
    f = null;          // To deallocate the memory allocated to the class
    #1;
    $display("Value of data : %0d and data2 : %0d",f.data, f.data2);
  end
  
  
  
endmodule



