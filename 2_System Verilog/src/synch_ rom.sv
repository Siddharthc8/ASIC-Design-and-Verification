`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2024 10:34:37 AM
// Design Name: 
// Module Name: synch_ rom
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


module synch_rom(
    input  logic clk,
    input logic [2:0] addr,
    output logic [1:0] data
    );
    
    (* rom_style = "block" *)logic [1:0] rom [0:7];  
    initial
    begin
        $readmemb("truth_table.mem", rom);
    end
    
    always_ff @(posedge clk)
    begin
        data <= rom[data];
    end
endmodule
