`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 12:22:47 AM
// Design Name: 
// Module Name: first_one_detector
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



module first_one_detector(
  input  logic [7:0] in_bus,
  output logic [7:0] out_bus
);
  integer i;
  always_comb begin
    out_bus = 8'b0;
    for (i = 0; i < 8; i++) begin
      if (in_bus[i]) begin
        out_bus[i] = 1'b1;
        break; // Stop after the first '1' is found
      end
    end
  end
  
  
  // Structural
  
assign out_bus[0] = in_bus[0];
assign out_bus[1] = ~in_bus[0] & in_bus[1];
assign out_bus[2] = ~in_bus[0] & ~in_bus[1] & in_bus[2];
assign out_bus[3] = ~in_bus[0] & ~in_bus[1] & ~in_bus[2] & in_bus[3];
assign out_bus[4] = ~in_bus[0] & ~in_bus[1] & ~in_bus[2] & ~in_bus[3] & in_bus[4];
assign out_bus[5] = ~in_bus[0] & ~in_bus[1] & ~in_bus[2] & ~in_bus[3] & ~in_bus[4] & in_bus[5];
assign out_bus[6] = ~in_bus[0] & ~in_bus[1] & ~in_bus[2] & ~in_bus[3] & ~in_bus[4] & ~in_bus[5] & in_bus[6];
assign out_bus[7] = ~in_bus[0] & ~in_bus[1] & ~in_bus[2] & ~in_bus[3] & ~in_bus[4] & ~in_bus[5] & ~in_bus[6] & in_bus[7];

////----------------------------------------

module first_one_detector #(
  parameter WIDTH = 8
)(
  input  logic [WIDTH-1:0] in_bus,
  output logic [WIDTH-1:0] out_bus
);

  genvar i;
  generate
    for (i = 0; i < WIDTH; i = i + 1) begin : one_hot_gen
      // out_bus[i] is '1' only if all lower bits are '0' and in_bus[i] is '1'
      assign out_bus[i] = in_bus[i] & ~(|in_bus[i-1:0]);
    end
  endgenerate

endmodule

  
endmodule
