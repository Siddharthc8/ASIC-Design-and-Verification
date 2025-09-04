`timescale 1ns / 1ps




module counter_8 (
    input clk, rst, up, load,
    input [7:0] loadin,
    output reg [7:0] y
);
 
    always@(posedge clk)
    begin
        if(rst == 1'b1)
        begin
            y <= 8'b00000000;
        end
      
        else if (load == 1'b1)
        begin
            y <= loadin;
        end
        
        else 
        begin
            if(up == 1'b1)
                y <= y + 1;
             else
                y <= y - 1;
         end
    end
  
endmodule
 
////////////////////////////
 
interface counter_8_intf();
logic clk,rst, up, load;
logic [7:0] loadin;
logic [7:0] y;
endinterface