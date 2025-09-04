`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2025 06:50:27 PM
// Design Name: 
// Module Name: tb_conditional_constraint
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


module tb_conditional_constraint();

    // Randomize with constraints
    
    reg clk = 0;
    reg dat1;
    reg ok;
    
    typedef enum bit[2:0] { ADDI, SUBI, ANDI, XORI, JMP, JMPC, CALL } op_t;
    typedef enum bit[1:0] { REG0, REG1, REG2, REG3 } reg_t;
    
    op_t opc;
    reg_t regs;
    
    initial begin
    
        ok = randomize(dat1) with { dat1>= 32; dat1<= 126; };
        
        ok = randomize(opc) with { opc inside {[ADDI:ANDI], JMP, JMPC}; };
        
        ok = randomize(regs) with { regs dist { [REG0:REG1]:=2, [REG2:REG3]:=1 }; };            // using weights 
        
        ok = randomize(dat1) with { opc == ADDI -> dat1 <100;              // "->" is used to say this is what has to be done when not using "if" keyword
                                    opc == SUB1 -> dat1>100; };
                                    
        ok = randomize(dat1) with { if (opc == ADDI)  dat1 <100; else     // if else can be used to metion constraints
                                    if (opc == SUB1)  dat1>100; };
    end
    
endmodule
