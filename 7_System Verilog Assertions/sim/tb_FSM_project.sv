`timescale 1ns / 1ps




module tb_FSM_project();

  reg clk = 0;
  reg  din = 0;
  reg rst = 0;
  wire dout;
  
  FSM_project dut (clk,rst,din,dout);
  
  always #5 clk = ~clk;
  
  initial begin
    #3;
    rst = 1;
    #30;
    rst = 0;
    din = 1;
    #45;
    din = 0;
    #25;
    rst = 1;
    #40;
    rst = 0;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
//    $assertvacuousoff(0);
    #180;
    $finish;    
  end
  
  // NOTE : When checking with next_state there is a possibility that there will be errors. 
  // Because din or rst becoming T/F will temporarily change the next state but not the actual state until posedge  
  
  ////////// (1) State is one hot encoded //////////////////////////////////////////
  
  state_encoding : assert property (@(posedge clk) 1'b1 |-> $onehot(dut.state));   // 1'b1 is to trigger by default
  // Checks if all the states are one-hot encoded
 
 
  ////////////// (2) Behavior on rst high  //////////////////////////////////////////
  
  state_rst_high:  assert property (@(posedge clk) rst |=> (dut.state == dut.idle));
  // Checking if the state stays in idle during reset 
  
  state_thr_rst_high:   assert property (@(posedge clk) $rose(rst) |=> (((dut.state == dut.idle)[*1:18]) within (rst[*1:18] ##1 !rst)));
  // When reset is asserted we are checking if the FSm stays in idle for the entire sim time until reset deasserted
  
  
/////////////////    (3) Behavior on rst low and din high  //////////////////////////////////////////
     
  sequence s1;
    (dut.next_state == dut.idle) ##1 (dut.next_state == dut.s0);    
  endsequence
 // Checking transition from idle to s0
 
   sequence s2;
     (dut.next_state == dut.s0) ##1 (dut.next_state == dut.s1);    
  endsequence
  // Checking transition from s0 to s1
      
  sequence s3;
    (dut.next_state == dut.s1) ##1 (dut.next_state == dut.s0);    
  endsequence
  // Checking transition from s1 to s0
  
    state_din_high: assert property (@(posedge clk) disable iff(rst) din |-> (s1 or s2 or s3));  
    // If rst deasserted and din asserted then current must be "s1 or s2 or s3"
    
    
///////////////////   (4) Behavior on rst low and din low  //////////////////////////////////////////

  sequence s4;
     (dut.next_state == dut.idle) ##1 (dut.next_state == dut.s0);    
  endsequence
  // Checking transition from idle to s0 
 
  sequence s5;
     (dut.next_state == dut.s0) ##1 (dut.next_state == dut.s0);    
  endsequence
  // If din low state should not change
      
  sequence s6;
    (dut.next_state == dut.s1) ##1 (dut.next_state == dut.s1);    
  endsequence 
  // If din low state should not change
      
   state_din_low: assert property (@(posedge clk) disable iff(rst) !din |-> (s4 or s5 or s6));
   // If rst deasserted and din asserted then current must be "s4 or s5 or s6"    
   //////////////////////////////////////////////////////////////////////////////////////////////
             
 // Clubbing all the sequences in a property for din high and din low
 
 property p1;
   @(posedge clk)   // clock mentioned
   if(din)
     (s1 or s2 or s3)
   else
     (s4 or s5 or s6);
 endproperty
    
 state_din: assert property (disable iff(rst) p1);
      
  ///////////////////////////////////////////////////////////////////////////////////////////////////
        
            
  
  ///////////////   (4) all states are covered check ////////////////////////////////////////
 
  initial assert property (@(posedge clk) (dut.state == dut.idle)[->1] |-> ##[1:18] (dut.state == dut.s0) ##[1:18] (dut.state == dut.s1)); 
  // Goto here makes sure that the idle state holds true anywhere for only 1 clock tick and not more
    
  
  /////////////////   (5)  Output check    /////////////////////////////////////////////////
  
  assert property (@(posedge clk) disable iff(rst) ((dut.next_state == dut.s0) && ($past(dut.next_state) == dut.s1)) |-> (dout == 1'b1) );
  // To check s1 -> s0 which is checked if the past state was s1 so checking if dout == 1
     
 
    
endmodule