`timescale 1ns / 1ps




module penc(
  input [7:0]y,
  output reg [2:0] a
);
  
  always@(y)
  begin
    casez(y)
 
  8'b00000001:a = 3'b000;
  8'b0000001?:a = 3'b001;
  8'b000001??:a = 3'b010;
  8'b00001???:a = 3'b011;
  8'b0001????:a = 3'b100;
  8'b001?????:a = 3'b101;
  8'b01??????:a = 3'b110;
  8'b1???????:a = 3'b111;
 
  default:a = 3'bzzz;
  endcase
 end
  
endmodule