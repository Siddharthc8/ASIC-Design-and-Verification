`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2025 09:07:09 PM
// Design Name: 
// Module Name: int_pracc
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


module int_pracc (
  input logic clk, rst,
  input logic [4:0] a, b,
  input logic func, valid,
  output logic [7:0] res,
  output logic done
);
  logic [7:0] next_res;
  logic next_done;
  
  // Sequential logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      res <= 8'b0;
      done <= 1'b0;
    end else begin
      res <= next_res;
      done <= next_done;
    end
  end
  
  // Combinational logic
  always_comb begin
    if (valid && !rst) begin
      // Perform operation when valid is high
      next_done = 1'b1; // Signal operation completion
      if (func == 1'b0)
        next_res = a + b; // Addition
      else
        next_res = a - b; // Subtraction
    end else begin
      // No operation: hold current result, no done signal
      next_done = 1'b1;
      next_res = 'b0;
    end
  end
endmodule




interface int_pracc_if;
  logic clk;
  logic rst;
  logic [4:0] a, b;
  logic func;
  logic valid; // Added valid signal
  logic [7:0] res;
  logic done;
endinterface
