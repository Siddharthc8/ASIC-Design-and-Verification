`timescale 1ns / 1ps


module FSM_project(input clk,rst,din,output reg dout);
  
  enum bit [2:0]
  {
   idle = 3'b001,//1
    s0 = 3'b010, //2
    s1 = 3'b100 //4
  }state = idle ,next_state = idle;
  
  ///reset decoding logic
  always@(posedge clk)
    begin
      if(rst == 1'b1)
         state <= idle;
      else 
         state <= next_state;
    end
  
 //////output logic and next state decoding logic 
 //   Outputs 1 when transitioning from s1 to s0
  always@(state,din)
    begin
      case(state)
        idle: 
          begin
          dout = 1'b0;
          next_state = s0;
          end
        
        s0: begin
          if(din == 1'b1)begin
            next_state = s1;
            dout = 0;
          end
          else begin  
            next_state = s0;
            dout = 0;
          end
        end
          
         s1:begin
          if(din == 1'b1)begin
            next_state = s0;
            dout = 1'b1;
          end
          else begin  
            next_state = s1;
            dout = 0;
          end  
        end
          
        default:
          begin  
            next_state = idle;
            dout = 0;
          end 
        
      endcase
    end
 
        
endmodule