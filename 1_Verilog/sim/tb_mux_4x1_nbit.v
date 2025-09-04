`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2024 11:48:15 PM
// Design Name: 
// Module Name: tb_mux_4x1_nbit
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


module tb_mux_4x1_nbit();

    parameter n=4;
    reg [n-1:0] w0,w1,w2,w3;
    reg [1:0] s;            
    wire [n-1:0] f;

mux_4x1_nbit #(.n(n)) uut(
    .w0(w0),
    .w1(w1),
    .w2(w2),
    .w3(w3),
    .s(s),
    .f(f)
);

initial begin
   w0 = 4'd3;
   w1 = 4'd5;
   w2 = 4'd7;
   w3 = 4'd11;
   
   s = 2'b00;
#5 s = 2'b01;
#5 s = 2'b10;
#5 s = 2'b11;
#5;
#5 w0 = 4'd2;
#5 w1 = 4'd4;
#5 w2 = 4'd6;
#5 w3 = 4'd10;

end
initial #55 $finish;
endmodule





















