`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2025 07:33:53 PM
// Design Name: 
// Module Name: tb_Gargi_logical_problems
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


module tb_Gargi_logical_problems();




 //1.Swap variables in system verilog using the shortest number of lines of code --> a<=b;b<=a;
 
//2.
 reg a,b,c,d,w;
assign w = a;
initial
begin
a = 2;
c=5;
b<=c;
a=5;
end
what is output of all registers.
all 5 except b if display before end,if strobe is used b is also 5


//3.In Verilog/SystemVerilog, write a module to detect if a binary representation of a number (of length 5) is palindrome or not

bit [0:4] a;
int flag;

initial begin
  a=5'b10101;
  
  for (int unsigned i = 0,int unsigned j = $bits(a)-1;i < $bits(a)/2; j>= 0; i++,j--) begin
   // $display("a[%0d]=%0b,a[%0d]=%0b",i,a[i],j,a[j]);
    if(a[i] != a[j]) begin
      $display("Lol");
		flag = 1; break;
	end
end
  if(flag) $display("No");
  else $display("Yes");

end

//4. If the input number is 4 return 7 and if input number is 7 return 4 without using if condition or switch statements.  

4 ->100 7 ->111  -->invert the last 2 bits
 bit[2:0]b,c;
 initial begin
  b=4;
  c={1'b1,~b[1:0]};
  $display("b:%0d,c:%0d",b,c);
 end
 
 //5.Given a number, return the index of the first occurrence of bit 1.
 
   bit [5:0]c;

initial begin
  c=6'b001000;
   $display("bitty:%0d",bitty(c));
end
function int bitty(input bit [5:0]a);
    for(int i=0;i<$bits(a);i++)
		 if(a[i]==1'b1) return i;
		return -1;
endfunction
  
 
 
 //6. write a system verilog code to merge two sorted array and create a merged sorted array
 module t;

  bit [4:0]a[5],b[5],q[$];
int unsigned i,j,last=0;

initial begin
  a={1,4,7,9,11};b={2,3,8,10,13};
  for (i =0;i<5;i++) begin
    for(j=last;j<5;j++) begin
      if(a[i] < b[j]) begin q.push_back(a[i]); //$write("if: %0p ",q); 
                    break;
      end
		else begin
          q.push_back(b[j]); last=j+1;//$write("else %0p ",q);
		end
	end
end
  foreach(q[i])
    $write("%0d ",q[i]);
end

endmodule


//   Given an array of numbers with a known size. return a new array shifted T times to the right.


endmodule
