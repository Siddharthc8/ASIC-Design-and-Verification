`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2024 10:19:48 AM
// Design Name: 
// Module Name: clk_gen_for_different_baud_rate
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


module clk_gen_for_different_baud_rate(

input clk, rst,
input [16:0] baud,
output  tx_clk
);
  
  
reg  t_clk = 0;
int  tx_max = 0;
int  tx_count = 0;
//////////////////////////////////////////////
 
always@(posedge clk) begin
		if(rst)begin
			tx_max <= 0;	
			end
		else begin 		
			case(baud)
				4800 :	begin
						  tx_max <=14'd10416;	//10418
			            end
				9600  : begin
						  tx_max <=14'd5208;
				    	end
				14400 : begin 
						  tx_max <=14'd3472;
						 end
				19200 : begin 
						  tx_max <=14'd2604;
						end
				38400: begin
						  tx_max <=14'd1302;
						end
				57600 : begin 
						  tx_max <=14'd868;	
						end 						
				 default: begin 
						  tx_max <=14'd5208;	
						 end
			endcase
		end
	end
 
///////////////////////////////////////////
 
 
always@(posedge clk)
begin
 if(rst) 
   begin
     tx_count <= 0;
     t_clk    <= 0;
   end
 else 
 begin
   if(tx_count < tx_max/2)
       begin
         tx_count <= tx_count + 1;
       end
    else 
       begin
        t_clk   <= ~t_clk;
        tx_count <= 0;
       end
 end
end
 
/////////////////////////////////////////////////////
  assign tx_clk = t_clk;
endmodule
 
 
////////////////////////////////////////////////////////////////////////
 
interface clk_if;
logic clk, rst;
logic [16:0] baud;
logic tx_clk;
endinterface
