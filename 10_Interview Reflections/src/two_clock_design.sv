`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 01:13:01 AM
// Design Name: 
// Module Name: two_clock_design
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


module two_clock_design(

  input  logic clk_a,
  input  logic rst_n,
  input  logic sig_from_b,
  output logic sig_a_sync
);

  logic sync_ff1, sync_ff2;
  
  always_ff @(posedge clk_a or negedge rst_n) begin
    if (!rst_n) begin
      sync_ff1 <= 0;
      sync_ff2 <= 0;
    end else begin
      sync_ff1 <= sig_from_b;
      sync_ff2 <= sync_ff1;
    end
  end
  assign sig_a_sync = sync_ff2;
  
  
  
  //---------------------------
  module dff(input clk1,input clk2,input reset,input d,output reg q);
     reg m1,m2;
     
     always@(posedge clk1) begin
        m1 <= d;
     end
     
     always@(posedge clk2 or negedge reset) begin
         if(!reset) begin
             m2 <= 1'b0;
             q <= 1'b0;
         end else begin
             m2 <= m1;
             q <= m2;
         end
     end
endmodule
  
endmodule

