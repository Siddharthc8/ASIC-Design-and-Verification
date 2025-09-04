`timescale 1ns / 1ps




module tb_fsm_with_enum();

  reg clk = 0;
  reg reset = 0;
  reg din = 0;
  wire dout;
  
 
  fsm_with_enum dut (reset,clk,din, dout);
  
 always #5 clk = ~clk;
  
  initial begin
    reset = 1;
    #30;
    reset = 0;
    #40;
    din = 1;
  end
 
  covergroup c;
    option.per_instance = 1;    
    coverpoint dut.state;        // NOTE : options.auto_bin_max does not work but does not throw an error either
  endgroup
  
  c cia;
  
  
  initial begin
    cia = new();
    
    forever begin
      @(posedge clk);
      // $cast(dut.state, 2'b00);     // $cast() method is to be used for enum and paramterized values
      cia.sample();
    end
  end
  
  
 
 initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #300;
    $finish();
  end
  
 
endmodule