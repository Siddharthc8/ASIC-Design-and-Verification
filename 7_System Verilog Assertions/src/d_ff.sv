`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2024 12:05:49 PM
// Design Name: 
// Module Name: d_ff
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


module d_ff(
    input d,
    input rstn,  
    input clk,  
    output q, qbar
    );  
  
  
    reg temp_q    = 0;
    reg temp_qbar = 1;
  
  
   always @ (posedge clk)  
    begin      
      if (!rstn) 
        begin 
          
          temp_q    <= 1'b0;
          temp_qbar <= 1'b1;
        end
       else 
         begin
          temp_q    <= d; 
          temp_qbar <= ~d;
         end
    end
 
  ////////////////////////////////////////
    always@(posedge clk)
    begin
      A1: assert (temp_q == ~temp_qbar) $info("Suc at %0t",$time);  else $info("Error at %0t", $time);
    end
    
   assign q    = temp_q;
   assign qbar = temp_qbar;
  
endmodule 
