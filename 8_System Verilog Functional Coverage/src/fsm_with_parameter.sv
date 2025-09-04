`timescale 1ns / 1ps




module fsm_with_parameter(input clk, input reset, input din, output reg dout);

  reg state, nstate;
  
  parameter S0=0, S1=1;
  
always @(posedge clk or posedge reset) // always block to update state
if (reset)
 state <= S0;
else
 state <= nstate;
  
  always @(state or din) // always block to compute both output & nextstate
  begin
  dout = 1'b0;
     case(state)
       S0: if(din)
         begin
            dout = 0; 
            nstate = S1;
         end
         else
            nstate = S0;
            
       S1: if(din) begin
         nstate = S0;
         dout = 1;
         end
         else
            nstate = S1;
         
       default: nstate = S0;
       
      endcase
  end


endmodule