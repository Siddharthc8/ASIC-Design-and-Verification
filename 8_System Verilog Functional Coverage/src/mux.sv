`timescale 1ns / 1ps




module mux
  (
input a,b,c,d,e,f,g,h,
    input [2:0] sel,
output reg y
  );
 
  
  always@(*)
    begin
      case(sel)
       0: y = a;
       1: y = b;
       2: y = c;
       3: y = d;
       4: y = e;
       5: y = f;
       6: y = g;
       7: y = h;
       default : y = 0;
      endcase
    end
  
  
  
endmodule