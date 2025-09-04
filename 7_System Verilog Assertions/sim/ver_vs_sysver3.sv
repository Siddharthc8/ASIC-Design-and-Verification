`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2024 07:41:32 PM
// Design Name: 
// Module Name: ver_vs_sysver3
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


module ver_vs_sysver3();

  reg clk = 0;
  reg rst = 0;
  reg wr = 0;
  reg rd = 0;
  
  integer i = 0, j = 0;
  integer hitwr = 0, hitrd = 0,err = 0;
   
  
  initial begin
    rst = 1;
    #20;
    rst = 0;
  end
  
  initial begin
    #40;
    wr = 1;
    #10;
    wr = 0;
  end
  
  initial begin
    #60;
    rd = 1;
    #10;
    rd = 0;
  end
  
  always #5 clk =~clk;
  
  default clocking 
    @(posedge clk);
  endclocking
 
////////////////Verilog
  
  task checkreset();
    repeat(2) @(posedge clk);
    for(i = 0; i< 10; i++) begin
      @(posedge clk);
      if(rst == 1'b1)
        err++;
    end
   endtask
    
    task hit();
      repeat(2) @(posedge clk);
      for(j = 0; j< 10; j++) begin
           @(posedge clk);
            if(!rst && wr)
               hitwr++;
            if(!rst && rd)
               hitrd++;
         end   
    endtask
    
  initial begin
    fork
      checkreset();
      hit();
    join  
    
    if(err == 0 && hitwr > 0 && hitrd > 0)
      $display("Verilog Suc at %0t",$time);
    else
      $error("Verilog Failure at %0t",$time);    
  end
    
 
 ///////////////////SVA
 
  // Checks if the rst stays low for the entire operation
  // [0:9] deonotes 0 to 9 clock cycles so that is to be considered as delay
  
  initial assert property (##2 !rst |-> !rst throughout ##[0:9] wr ) $info("WR Suc at %0t",$time);
    
  initial assert property (##2 !rst |-> !rst throughout ##[0:9] rd ) $info("RD Suc at %0t",$time);
 
  
initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    //$assertvacuousoff(0); 
    #120;
    $finish;
  end
  
  
endmodule
