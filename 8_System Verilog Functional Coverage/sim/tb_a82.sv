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


module tb_a82();

  reg [2:0] a, b;
  reg rst;
  reg feed;
  wire [2:0] y;
  wire done;
  int i=0;
  
   covergroup c1;
 
    option.per_instance = 1;
    
    coverpoint a{
        bins a[] = {[0:$]};
    }
    coverpoint b{
        bins b[] = {[0:$]};
    }
    coverpoint rst{
        bins rst[] = {[0:$]};
    }
    
    cross rst, a
    {
        ignore_bins rst_h = binsof (rst) intersect {1};
    }
    
    cross rst, b
    {
        ignore_bins rst_h = binsof (rst) intersect {1};
    }
    
    cross a,b,rst
    {
        ignore_bins a_1_to_2 = binsof (a) intersect {[1:2]};
        ignore_bins b_1_to_2 = binsof (b) intersect {[1:2]};
        ignore_bins rst_h = binsof (rst) intersect {1};
    }
 endgroup
 
   c1 ci;
   
   initial begin
   
       ci = new();
        
        for( i = 0; i < 50; i++) 
        begin
            a = $urandom();
            b = $urandom();
            rst = $urandom();
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
