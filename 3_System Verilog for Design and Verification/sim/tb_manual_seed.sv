`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2025 06:49:08 PM
// Design Name: 
// Module Name: tb_manual_seed
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


module tb_manual_seed();

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
endmodule
