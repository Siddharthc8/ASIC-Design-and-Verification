`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2025 04:52:50 PM
// Design Name: 
// Module Name: tb_test
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


module tb_test();

  reg clk = 0, rst = 0, wr = 0, rd = 0;
  reg [7:0] din = 0;
  wire [7:0] dout;
  wire empty, full;
  integer i = 0;
  reg start = 0;
  
  initial begin
    #2;
    start = 1;
    #10;
    start = 0;
  end
  
  
  reg temp = 0;
  initial begin
    #292;
    temp = 1;
    #10;
    temp = 0;
  end
  
  test dut (clk,rst,wr,rd,din,dout,empty,full);
  bind test test_assert dut2 (clk,rst,wr,rd,din,dout,empty,full);
  
  
  
  always #5 clk = ~clk;
  
  
    task write();
    for( i = 0; i < 15; i++)
      begin   
        
        din = $urandom();
        wr = 1'b1;
        rd = 1'b0;
        @(posedge clk);
      end
  endtask
  
  
      task read();
    for( i = 0; i < 15; i++)
      begin   
        
        wr = 1'b0;
        rd = 1'b1;
        @(posedge clk);
      end
  endtask
  
  
  initial begin
    @(posedge clk) {rst,wr,rd} = 3'b100;
    @(posedge clk) {rst,wr,rd} = 3'b101;
    @(posedge clk) {rst,wr,rd} = 3'b110;
    @(posedge clk) {rst,wr,rd} = 3'b111;
    @(posedge clk) {rst,wr,rd} = 3'b000; 
    
    write();
    @(posedge clk) {rst,wr,rd} = 3'b010;
    @(posedge clk);
    
    read();
    
  end
  
  
  /*
  initial begin
 
    $display("------------Starting Test-----------------");
    $display("------(1) Behavior of FULL and EMPTY on RST High------");
    @(posedge clk) {rst,wr,rd} = 3'b100;
    @(posedge clk) {rst,wr,rd} = 3'b101;
    @(posedge clk) {rst,wr,rd} = 3'b110;
    @(posedge clk) {rst,wr,rd} = 3'b111;
    @(posedge clk) {rst,wr,rd} = 3'b000;
    @(posedge clk);
    #20;
 
    $display("------(2) Reading from Empty FIFO------");
    @(posedge clk) {rst,wr,rd} = 3'b001;
    @(posedge clk);
    
    #20;
    $display("------(3) Writing Data to FULL FIFO------");
    $display("--------(4) RPTR and WPTR behavior during Writing--------");
    write();
    @(posedge clk) {rst,wr,rd} = 3'b010;
    @(posedge clk);
    
    #20;
    $display("--------(5) RPTR and WPTR behavior during reading--------");
    read();
    
        
    
  end
  */
 
  
  //// ---------------- (6) Data Matched during read and write operation
  /*
  initial begin
    write();
    repeat(5) @(posedge clk);
    read(); 
  end
  
 */ 
     
   
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
//    $assertvacuousoff(0);
    #500;
    $finish();
  end
  
endmodule  

