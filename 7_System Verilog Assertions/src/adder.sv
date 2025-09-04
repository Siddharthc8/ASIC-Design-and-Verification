`timescale 1ns / 1ps

module adder(

  input [3:0] a,b,
  input clk,sample,
  output reg [4:0] s,
  output reg done
);
  reg [3:0] ta,tb;
  
  reg state = 0;
  
  always@(posedge clk)
    begin
      case(state)
       0: begin 
              if(sample == 1'b1) 
              begin
              ta <= a;
              tb <= b;
              done <= 1'b0;
              state <= 1'b1;
              end
              else
              state <= 1'b0;
         end
      1:
        begin  
          s <= ta + tb;
          done <= 1'b1;
          state <= 0;
        end
        
      default : state <= 0;  
        
      endcase
    end
  
endmodule