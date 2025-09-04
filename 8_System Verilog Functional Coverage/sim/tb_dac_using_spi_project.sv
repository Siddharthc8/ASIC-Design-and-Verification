`timescale 1ns / 1ps




module tb_dac_using_spi_project();

reg clk = 0, start = 0;
  reg [11:0] din;
  wire mosi;
  wire cs;
  integer i = 0;
  
 
 
dac dut (clk,din,start,mosi, cs);
 
always #5 clk = ~clk;
 
initial begin
  #20;
  start = 1;
  #1000;
  start = 0;
end
  
  initial begin
    for(i = 0; i< 200; i++) begin
      @(posedge clk);
      din = $urandom();
    end
  end
 
 
  covergroup c @(posedge clk);
    option.per_instance = 1;
    coverpoint dut.state {
      
      bins out_of_idle = (dut.idle => dut.init);           // IDLE to 1st State
      
      bins setup_data_send = (dut.idle => dut.init[*33] => dut.data_gen);   // Checking if 33cycles of inititation is done
      
      bins user_data_send = (dut.data_gen => dut.send[*33] => dut.cont);    // Data_gen takes only one cycle so Checking if 33cycles of sending is done and to "cont" 
      
      bins data_gen_loop = ( dut.data_gen => dut.send[*33] => dut.cont => dut.data_gen);  // Cheking if it goes back to data_gen state when start is 1
      
      bins stay_send_33 = (dut.send[*33]);   // To check only if send takes 33 cycles or not
      
      bins stay_init_33 = (dut.init[*33]);   // To check only if init takes 33 cycles or not
      
      bins start_deassert = (dut.send => dut.cont => dut.idle);
        
    }
    
    
  endgroup
 
  c ci;
  
 
  
  initial begin
    ci = new();
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #2000;
    $finish();
  end
 
 
endmodule