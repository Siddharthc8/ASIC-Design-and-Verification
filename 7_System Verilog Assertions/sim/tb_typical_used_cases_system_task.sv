module tb_typical_used_cases_system_task();

/*
 ---------------------------------------------------------------------------------------------

 1) If a assert, b must assert in next clock tick
 
 assert property ( @(posedge clk) $rose(a) |=> $rose(b)) ;
 
 assert property ( @(posedge clk) $rose(a) |=> ##[n] $rose(b)) ;      // Custom delay
 assert property ( @(posedge clk) $rose(a) |=> ##[n : m] $rose(b)) ;  // Custom range delay
 
 ---------------------------------------------------------------------------------------------
 
 2) Each new request must be followed by acknowledgement.
 
 assert property ( @(posedge clk) $rose(req) |=> $rose(ack) );
 
 ---------------------------------------------------------------------------------------------

 3) If rst deassert, CE Must assert in same clock tick.
 
 assert property ( @(posedge clk) $fell(rst) |-> $rose(ce) );
 
 ---------------------------------------------------------------------------------------------

 4) Wr request must be followed by Rd request
 
  assert property ( @(posedge clk)  $rose(wr) |=> $rose(rd));

  ---------------------------------------------------------------------------------------------

 5) Current Value of addr Must be one greater than the previous value If start assert.
 
  assert property ( @(posedge clk) $rose(start) |-> addr == $past(addr + 1 ) );

  ---------------------------------------------------------------------------------------------
  
 6) If rst deasseert, dout must be zero
 
 assert property ( @(posedge clk) $fell(rst) | -> ( dout == 0 ) )
 
  ---------------------------------------------------------------------------------------------
 
 7) If LoadIn deasert, dout must be equal to load value
 
 assert property ( @(posedge clk) $fell(loadin) |-> (dout == load) )
  
  ---------------------------------------------------------------------------------------------
 
 8) If rst deasserted, output of the shift register must be shifted to left by one in the next clock tick ie  sout[7:0] ( 8 bit long)
 
 assert property ( @(posedge clk) $fell(rst) |=> ( sout == sout { sout[6:0], 0 }
  
  ---------------------------------------------------------------------------------------------
 
 9) If rst deassert, current value and past value of the signal differ only in single bit
 
 assert property ( @(posedge clk) $fell(rst) |=> ( $onehot( signal ^ $past(signal) ) );
 
 // To check exact number of changes we can use $countones system task
 assert property ( @(posedge clk) !rst |-> ( $countones( signal ^ $past(signal) ) == 1 ) );  // The number represents the desired bit change

   
  ---------------------------------------------------------------------------------------------
 
 10) In DFF, output must remain constant if CE is low
 
 assert property ( @(posedge clk) (!ce) |=> ( q == $past(q) ) );
   
  ---------------------------------------------------------------------------------------------
 
 11) In TFF, if CE aserted output must toggle
 
  assert property ( @(posedge clk) ce |=> ( q != $past(q) ) );
   
  ---------------------------------------------------------------------------------------------
 
 
 
*/

endmodule