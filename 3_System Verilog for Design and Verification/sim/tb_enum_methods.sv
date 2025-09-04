`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2025 06:21:47 PM
// Design Name: 
// Module Name: tb_enum_methods
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


module tb_enum_methods();
    
    reg clk = 0;
    
    always #5 clk = ~clk;
    
    typedef enum bit[2:0] { ADDI, SUBI, ANDI, XORI, JMP, JMPC, CALL } op_t;
    typedef enum bit[1:0] { REG0, REG1, REG2, REG3 } reg_t;
    
    op_t opc;
    reg_t regs;
    logic [7:0] data;
    
    initial begin
    
        opc = opc.first();   // assigns the first one int he enum type ie "ADDI"
        
        regs = regs.first();
        
        repeat(opc.num()) begin       // Loops through opc data_type variables
        
            repeat(regs.num()) begin  // Loops through regs data_types variables
            
                 for(data=0; data<1; data++)
                    @(posedge clk);
                    
                 regs = regs.next();
            end
            
        opc = opc.next();
        end 
        
    end
endmodule
