`timescale 1ns / 1ps


module counter_project(
    input clk,
    input rst,
    input up,
    output reg [3:0] dout
);
  
  always@(posedge clk,posedge rst)
    begin
      if(rst == 1'b1)
         dout <= 0;
      else begin
        if(up == 1'b1)
           dout <= dout + 1;
        else
           dout <= dout - 1;
      end
    end
  
  
endmodule 