`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 12:57:40 AM
// Design Name: 
// Module Name: binary_to_gray
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



module binary_t #(
  parameter WIDTH = 4
)(
  input  logic              clk,
  input  logic              rst_n,
  input  logic              enable,
  output logic [WIDTH-1:0]  gray
);

  logic [WIDTH-1:0] binary;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      binary <= '0;
    else if (enable)
      binary <= binary + 1;
  end

  // Gray code = binary ^ (binary >> 1)
  assign gray = binary ^ (binary >> 1);



endmodule
