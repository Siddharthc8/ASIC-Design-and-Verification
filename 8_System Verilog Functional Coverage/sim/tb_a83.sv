`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2025 11:07:05 PM
// Design Name: 
// Module Name: tb_a82
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


module tb_a83();
  reg [1:0] a,b,c;
  wire [3:0] y;
  int i = 0;
  
   covergroup c1;
 
    option.per_instance = 1;
    
    coverpoint a{
        bins a[] = {[0:$]};
    }
    coverpoint b{
        bins b[] = {[0:$]};
    }
    coverpoint c{
        bins c[] = {[0:$]};
    }
    
    cross a, b
    {
        ignore_bins b_odd = binsof (b) intersect {1,3};
    }
    
    cross a, c
    {
        ignore_bins c_even = binsof (c) intersect {0,2};
    }
    
    cross b, c
    {
        ignore_bins b_odd =  binsof (b) intersect {1,3};
        ignore_bins c_even = binsof (c) intersect {0,2};
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
