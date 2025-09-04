`timescale 1ns / 1ps




module fsm_with_enum(
input rst,clk,
input din,
output logic dout
);
 
typedef enum {s0,s1} state_type;
state_type state = s0;
state_type next_state = s0;
 
/////////////Reset Logic
always_ff@(posedge clk)
begin
if(rst == 1'b1)
state <= s0;
else
state <= next_state;
end
 
///////////////Next state Decoder Logic
always_comb
begin
case(state)
s0: begin
if(din == 1'b1)
next_state = s1;
else
next_state = s0;
end
 
s1: begin
if(din == 1'b1)
next_state = s0;
else
next_state = s1;
end
 
default : next_state = s0;
endcase
end
 
///////////////Output Logic
 
always_comb
begin
case(state)
s0: dout = 1'b0;
s1: dout = 1'b1;
default : dout = 1'b0;
endcase
end
 
 
 
endmodule