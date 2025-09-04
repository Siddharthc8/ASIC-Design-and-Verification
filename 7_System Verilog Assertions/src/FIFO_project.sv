`timescale 1ns / 1ps




module FIFO_project
(
    input clk, rst, wr, rd, 
    input [7:0] din,output reg [7:0] dout,
    output reg empty, full
);
  
  reg [3:0] wptr = 0,rptr = 0,cnt = 0;
  reg [7:0] mem [15:0];
  
  always@(posedge clk)
    begin
      if(rst== 1'b1)
         begin
           cnt <= 0;
           wptr <= 0;
           rptr <= 0;
         end
      else if(wr && !full)
          begin
            if(cnt < 15) begin
            mem[wptr] <= din;
            wptr <= wptr + 1;
            cnt <= cnt + 1;
            end
          end
      else if (rd && !empty)
        begin
          if(cnt > 0) begin
          dout <= mem[rptr];
          rptr <= rptr + 1;
          cnt <= cnt - 1;
          end
        end 
      
      if(wptr == 15)
         wptr <= 0;
      if(rptr == 15)
         rptr <= 0;
    end
  
  assign empty = (cnt == 0) ? 1'b1 : 1'b0;
  assign full = (cnt == 15) ? 1'b1 : 1'b0;
  
endmodule
 