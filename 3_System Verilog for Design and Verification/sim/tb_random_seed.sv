`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2025 06:38:27 PM
// Design Name: 
// Module Name: tb_random_seed
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


module tb_random_seed();

    reg clk = 0;
    reg ok;
    reg dat1; 
    
    always #5 clk = ~clk;
    
    always @(posedge clk)
    begin
        
        // used to manually seed a particular data variable
        process::self.srandom(10);   // Process is a built-in class
        
        ok = randomize(dat1);    // Returns whether it was randiomized or not
        
    end
    
    // Randomize with constraints
    
    typedef enum bit[2:0] { ADDI, SUBI, ANDI, XORI, JMP, JMPC, CALL } op_t;
    typedef enum bit[1:0] { REG0, REG1, REG2, REG3 } reg_t;
    
    op_t opc;
    reg_t regs;
    
    initial begin
    
        ok = randomize(dat1) with { data>= 32; data<= 126; };
        
        ok = randomize(opc) with { opc inside {[ADDI:ANDI], JMP, JMPC}; };
        
        ok = randomize(regs) with { regs dist { [REG0:REG1]:=2, [REG2:REG3]:=1 }; };
        
    end
    
endmodule
