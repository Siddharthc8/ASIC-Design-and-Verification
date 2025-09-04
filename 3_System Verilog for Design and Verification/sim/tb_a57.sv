`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2024 12:24:31 AM
// Design Name: 
// Module Name: tb_a57
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


module tb_a57();
// Create a deep copy of the Generator class. 
// To verify the deep copy code assign value of the copy method to another instance of the generator class in TB top. 
// Print the value of data members in the generator class as well as copied class. 
// Refer Instruction tab for Generator class code.    
// Generator class is given


class Generator;
  
  bit [3:0] a = 5,b =7;
  bit wr = 1;
  bit en = 1;
  bit [4:0] s = 12;
  
  function void display();
    $display("a:%0d b:%0d wr:%0b en:%0b s:%0d", a,b,wr,en,s);
  endfunction
  
  function Generator copy();
      copy = new();
      copy.a = a; 
      copy.b = b;
      copy.wr = wr;
      copy.en = en;
      copy.s = s;  
         
  endfunction
 
endclass

// Just creating two haandlers using the Generator class and copying one's properties to another one didn't make sense because when two handlers are created they already behave as separate entitites

class Copy;
    
    Generator gen;
    function new();
        gen = new();
    endfunction
    
    function Copy copy;
      copy = new();
      copy.gen = gen.copy();    // All Generator class data members are replicated       
      
  endfunction
    
endclass
    
    Copy original1, copy1;
    
    initial begin
        original1 = new();
        copy1 = new();
        
        copy1 = original1.copy();
        
        copy1.gen.a = 10; 
        copy1.gen.b = 14;
        copy1.gen.wr = 0;
        copy1.gen.en = 0;
        copy1.gen.s = 24; 
        
        original1.gen.display();
        copy1.gen.display();
        
        $display("Original Values: %0d, %0d, %0d, %0d, %0d",original1.gen.a, original1.gen.b, original1.gen.wr, original1.gen.en, original1.gen.s);
        $display("Copied Values: %0d, %0d, %0d, %0d, %0d",copy1.gen.a, copy1.gen.b, copy1.gen.wr, copy1.gen.en, copy1.gen.s); 
    end


endmodule
