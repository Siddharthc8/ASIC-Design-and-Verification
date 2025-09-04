`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2024 02:50:24 PM
// Design Name: 
// Module Name: tb_super_keyword
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


module tb_super_keyword();

class first; ////////////parent class
  int data;
  
  function new(input int data);
    this.data = data;  
  endfunction
  
  
endclass
 
class second extends first;
  int temp;
  
  function new(input int data,input int temp);
    super.new(data);
    this.temp = temp;
  endfunction
  
endclass
 
  second s;
  
  initial begin
    s = new(67, 45);
    $display("Value of data : %0d and Temp : %0d", s.data, s.temp);
  end
  
endmodule

