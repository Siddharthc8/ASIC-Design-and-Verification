`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2025 06:59:20 PM
// Design Name: 
// Module Name: tb_randcase
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


module tb_randcase();

    
    reg a;
    reg b;
    reg c;
    
    function void func1();   // Empty functions
    endfunction
    
    function void func2();
    endfunction
    
    function void func3();
    endfunction
    
    function void func4();
    endfunction
    
    initial begin
        repeat(50) begin
        
            randcase           // The left side are the weights and not conditions
            
            20 :  func1();     // Allwos for funciton calls as well
            10 :  func2();
            30 :  func3();
             5 :  func4();
            
            endcase
            
            randcase           // The left side are the weights and not conditions
            
            a+b :  func1();     // Variables can also be used as well on the left side
            a   :  func2();
            b   :  func3();
            c   :  func4();
            
            endcase
            
        end
    end
    
    
endmodule
