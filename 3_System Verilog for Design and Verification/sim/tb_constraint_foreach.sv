`timescale 1ns / 1ps




module tb_constraint_foreach();

    class randclass2;
    
     rand logic[3:0]arr[7:0];
     
     
     constraint c1{ foreach (arr[i]) (i <=4) -> arr[i] <= i; }
     
     
     constraint c2{ foreach (arr[i]) (i >4) -> arr[i] >= i; }
    endclass


endmodule