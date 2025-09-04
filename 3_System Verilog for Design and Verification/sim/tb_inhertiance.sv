`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2024 01:33:48 AM
// Design Name: 
// Module Name: tb_inhertiance
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


module tb_inhertiance();

class First;
    
    int data = 12;
    
    function void display();
        $display("Data:%0d", data);
  endfunction
    
endclass

class Second extends First;

    int temp = 34;
    
    function void disp();
        $display("Temp added :%0d", temp);
    endfunction
  
    function void parent_data();              // Parent class data memebr used in Child class function
        $display("Accessing parent class data member Data: %0d", data);
    endfunction
    
endclass

    Second s;
    
    initial begin
        s = new();
        
        s.data = 23;               // Changes the Parent class data mameber's value
        s.display();
        s.parent_data();
    end
    
endmodule
