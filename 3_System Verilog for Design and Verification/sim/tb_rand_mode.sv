`timescale 1ns / 1ps




module tb_rand_mode();

 class randclass;
 
 rand bit[1:0] p1;
 randc bit[1:0] p2;
 bit[1:0] s1, s2;
 
 endclass
 
 
 randclass myrand = new;
 int ok, state;
 
 initial begin
 
     myrand.rand_mode(0);             //  Disable randomization of all random variables of myrand
     myrand.p2.rand_mode(1);          //  Re-enable p2randomization
     state = myrand.p2.rand_mode();   //  Read p2 mode ans = (1)
     ok = myrand.randomize();         //  Only p2randomized
     state = myrand.s1.rand_mode();   //  Error - s1 is not a  random variable
     
 end
    
endmodule