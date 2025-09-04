`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2025 11:59:26 PM
// Design Name: 
// Module Name: tb_empty_bin
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


module tb_empty_bin();
  
  reg [2:0] a;
  
  covergroup c;
    option.per_instance  = 1;
    coverpoint a {
    
      bins a_Valid[] = {[0:5]};
      illegal_bins a_invalid[] = {[5:7]};
     
      // NOTE : There is no syntax called empty bin only the result is displayed as empty bin 
             // when there is a clash only between illegal/ignore and normal bins
      // NOTE : Illegal bins also get precedence over any other normal bin    
    }
    
    
  endgroup
  
 
  c ci;
 
  initial begin
     ci = new();
    
    
    
    for (int i = 0; i <15; i++) begin
      a = $urandom();
      ci.sample();
      #10;
    end
    
    
  end

  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #400;
    $finish();
  end
 
 
endmodule
