`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2024 12:39:43 AM
// Design Name: 
// Module Name: dff
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


module dff (dff_if uif);

    always_ff @(posedge uif.clk) begin
        if(uif.rst)
            uif.dout <= 1'b0;
        else if (uif.din >= 1'b0)
            uif.dout <= uif.din;
        else
            uif.dout <= 1'b0;
    end
endmodule


interface dff_if;
    logic clk; 
    logic rst;
    logic din;
    logic dout;
endinterface 