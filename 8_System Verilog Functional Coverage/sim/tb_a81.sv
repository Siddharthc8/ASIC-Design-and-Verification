`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2025 10:16:50 PM
// Design Name: 
// Module Name: tb_a81
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


module tb_a81();

    reg [1:0] a,b,c;
    wire [3:0] y;
    int i;
 
 covergroup c1;
 
    option.per_instance = 1;
    
    coverpoint a{
        bins a[] = {[0:3]};
    }
    coverpoint b{
        bins b[] = {[0:3]};
    }
    coverpoint c{
        bins c[] = {[0:3]};
    }
    
    cross a, b
    {
        ignore_bins a_0_l = binsof (a) intersect {[2:3]};
    }
    
    cross b, c
    {
        ignore_bins b_11 = binsof (b) intersect {[0:2]};
    }
    
    cross a,b,c
    {
        ignore_bins a_10 = binsof (a) intersect {0, [2:3]};
        ignore_bins b_10 = binsof (b) intersect {0, [2:3]};
        ignore_bins c_10 = binsof (c) intersect {0, [2:3]};
    }
 endgroup
 
   c1 ci;
   
   initial begin
   
       ci = new();
        
        for( i = 0; i < 50; i++) 
        begin
            a = $urandom();
            b = $urandom();
            c = $urandom();
            ci.sample();
            #10;
        end
   
   end
 
 initial begin
    
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #500;
    $finish();
  end
  
endmodule
