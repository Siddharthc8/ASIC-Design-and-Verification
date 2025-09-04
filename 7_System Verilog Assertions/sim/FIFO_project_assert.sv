`timescale 1ns / 1ps


module FIFO_project_assert
(
    input clk, rst, wr, rd, 
    input [7:0] din,input [7:0] dout,
    input empty, full
);
  
  
  // (1) status of full and empty when rst asserted
  
  ////check on edge
  
 RST_1: assert property (@(posedge clk) $rose(rst) |-> (full == 1'b0 && empty == 1'b1))$info("A1 Suc at %0t",$time);
 // Checking on the same clock edge doesn't make sense

  /////check on level
   
 RST_2: assert property (@(posedge clk) rst |-> (full == 1'b0 && empty == 1'b1))$info("A2 Suc at %0t",$time);  
 // May give error when rst asserted and full & empty take one cycle to update
 
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
   //  (2) operation of full and empty flag
     
   FULL_1: assert property (@(posedge clk) disable iff(rst) $rose(full) |=> (FIFO.wptr == 0)[*1:$] ##1 !full)$info("full Suc at %0t",$time); 
   // The full flag is raised and the wptr is set to zero in the following clock tick. so we are checking this
   
   
   FULL_2 : assert property (@(posedge clk) disable iff(rst) (FIFO.cnt == 15) |-> full)$info("full Suc at %0t",$time);
   // When cnt == 15, full flag is raised in the same clock tick
       
   EMPTY_1:  assert property (@(posedge clk) disable iff(rst) $rose(empty) |=> (FIFO.rptr == 0)[*1:$] ##1 !empty)$info("full Suc at %0t",$time); 
   // When empty is raised the next clock tick rptr goes to zero until empty falls
  
  EMPTY_2: assert property (@(posedge clk) disable iff(rst) (FIFO.cnt == 0) |-> empty)$info("empty Suc at %0t",$time); 
   // Notice that empty flag is high when cnt = 0 and the last instruction in still read in that clock tick 
       
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       
   ///////  (3) read while empty
  
    READ_EMPTY: assert property (@(posedge clk) disable iff(rst) empty |-> !rd)$info("Suc at %0t",$time);  
    // We cannot have rd asserted when empty is raised as it is an indication there is nothing to read in the next clock tick so that'll be na error 
    
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
      ////////// (4) Write while FULL
     
    WRITE_FULL: assert property (@(posedge clk) disable iff(rst) full |-> !wr)$info("Suc at %0t",$time);
  // Same case like empty and read
    
    
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
      ////////////// (5) Write+Read pointer behavior with rd and wr signal
      
      //////if wr high and full is low, wptr must incr
       
  WPTR1: assert property (@(posedge clk)  !rst && wr && !full |=> $changed(FIFO.wptr));
  // During write wpte must change
         
    //////// if wr is low, wptr must constant
  WPTR2: assert property (@(posedge clk) !rst && !wr |=> $stable(FIFO.wptr));
  // During no write wptr must be stable
    
    /////// if rd is high, wptr must stay constant
  WPTR3: assert property (@(posedge clk)  !rst && rd |=> $stable(FIFO.wptr)) ;
  // During read wptr must be stable  ( NOTE : Not possible for simultaneous read and write FIFOs )        
   
   
  RPTR1: assert property (@(posedge clk)  !rst && rd && !empty |=> $changed(FIFO.rptr));
  // During read and not empty rptr must change
         
  RPTR2: assert property (@(posedge clk) !rst && !rd |=> $stable(FIFO.rptr));
    
  RPTR3: assert property (@(posedge clk)  !rst && wr |=> $stable(FIFO.rptr));
 
  
      
    
    //////////  (6) state of all the i/o ports for all clock edge

  always@(posedge clk)
    begin
      assert (!$isunknown(dout));       // Using uknown returns True if known present
      assert (!$isunknown(rst));        // So using !$unknown yields false when unkown present
      assert (!$isunknown(wr));
      assert (!$isunknown(rd));
      assert (!$isunknown(din));
    end
 
 
 
    //////////////////// (7) Data must match
    
  property p1;
    integer waddr;
    logic [7:0] data;
 
    (wr, waddr = tb_FIFO_project.i, data = din) |-> ##[1:30] rd ##0 (waddr == tb_FIFO_project.i - 1, $display("din: %0d dout :%0d",data, dout));
  endproperty
  
  assert property (@(posedge clk) disable iff(rst) p1) $info("Suc at %0t",$time);
 
endmodule