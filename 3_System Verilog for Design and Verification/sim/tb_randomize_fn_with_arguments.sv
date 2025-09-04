`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2025 02:18:45 PM
// Design Name: 
// Module Name: tb_randomize_fn_with_arguments
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


module tb_randomize_fn_with_arguments();

 class randclass;
 
 rand bit[1:0] p1;
 randc bit[1:0] p2;
 bit [1:0] s1,s2;          // Non-rand variables
 
 endclass
 
 
 class randwrap;
 
 rand int prw;
 rand randclass c1;   // Since randclass has randomizable variables and is called in another class "rand" keyword should be used
 
     function new();
        c1 = new();
     endfunction
 
 endclass
 
 
 randwrap mywrap = new();
 int ok;
 
 initial begin
    ok = mywrap.randomize();
 end
 
 /// .................................................
 
 randclass myrand = new;
 int ok;
 initial begin
 ok = myrand.randomize();          // randomize p1 and p2 only; s1 and s2not randomized
 ok = myrand.randomize(p1);        // randomize p1 only; Others unchanged
 ok = myrand.randomize(p1,s1);     // randomize p1and s1only (others unchanged)
 ok = myrand.randomize(s1,s2);     //  randomize s1and s2only (others unchanged)
 end
 

endmodule
