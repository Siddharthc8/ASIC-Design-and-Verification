`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2024 07:12:29 PM
// Design Name: 
// Module Name: virtual_sequncer
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


module virtual_sequencer(  // Module of an adder and a multiplier

  input [3:0] aa,ab,ma,mb,
  input clk, rst,
  output [4:0] aout,
  output [7:0] mout
 
);
  
  adder adder_inst (aa,ab,clk,rst,aout);
  mul   mul_inst (ma, mb, clk, rst, mout);
  
endmodule
 
//////////////////////////////////////////4-bit adder
module adder (input [3:0] add_in1,add_in2, 
              input clk, rst,
              output reg [4:0] add_out
             );
  
  always@(posedge clk)
    begin
      if(rst)
        begin
          add_out <= 5'b00000; 
        end
      else
        begin
          add_out <= add_in1 + add_in2;
        end
    end
endmodule
 
//////////////////////////////////////
 
module mul (input [3:0] mul_in1,mul_in2, 
              input clk, rst,
            output reg [7:0] mul_out
             );
  
  always@(posedge clk)
    begin
      if(rst)
        begin
          mul_out <= 5'b00000; 
        end
      else
        begin
          mul_out <= mul_in1 * mul_in2;
        end
    end
endmodule
// ////////////////////////////////
 
 
interface add_if;
  logic [3:0] add_in1,add_in2;
  logic clk, rst;
  logic [4:0] add_out;
endinterface
 
 
//////////////////////////////
 
interface mul_if;
  logic [3:0] mul_in1,mul_in2;
  logic clk, rst;
  logic [7:0] mul_out;
endinterface