`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2024 08:43:58 AM
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
    input logic clk,
    input logic rst,
    input logic din,
    output logic dout
    );
    
always_ff @(posedge clk) begin
    
    if(rst)
        dout <= 0;
    else
        dout <= din;
    
end

endmodule


interface d_ff_if();

    logic clk;
    logic rst;
    logic din;
    logic dout;
    
endinterface
