`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/01/2025 09:12:35 AM
// Design Name: 
// Module Name: tb_test_file
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




`include "uvm_macros.svh"
import uvm_pkg::*;


module tb_test_file(); 

    int a[14], b[14], q[$], q1[$];
    int temp;
    int res[$];
//    a = {1,2,2,3,4,4,5,5,6,6,6,6,7,9};
    
    initial begin
        a = {1,2,2,3,4,4,5,5,6,6,6,6,7,9};
        
        foreach(a[i]) begin
            if(i == 0) q.push_back(a[i]);
            else if(a[i] != a[i-1]) q.push_back(a[i]);
        end
        $display("q : %0p", q);
        
    end
    
    initial begin
        b = {1,2,2,3,4,4,5,5,6,6,6,6,7,9};
        
        foreach(b[i]) begin

            if(i == 0 || b[i] != b[i-1]) begin
                q1.push_back(b[i]);
            end
        end
        
        
        $display ("find(x)         : %p", res);
        $display("q1 : %0p", q1);
        
    end

endmodule 

//module tb_test_file(); 

//class some_class;
  
//  parameter int WIDTH = 8;
  
//  logic [WIDTH - 1:0] a;
//  rand logic [1:0] a_temp [WIDTH - 1:0];
  
//  function void post_randomize; 
//    for (int index = 0; index < WIDTH; index++) begin
//      case (a_temp[index])
//        2'd0 : a[index] = 1'b0;
//        2'd1 : a[index] = 1'b1;
//        2'd2 : a[index] = 1'bz;
//        2'd3 : a[index] = 1'bx;        
//      endcase
//    end    
//  endfunction : post_randomize 
  
//endclass : some_class

//initial begin
    
//    some_class sc = new();
//    sc.randomize();
//    $display("a: %b %p", sc.a, sc.a_temp);
    
//end
    
//endmodule





//////////////////////////////////////////////////////////////////



