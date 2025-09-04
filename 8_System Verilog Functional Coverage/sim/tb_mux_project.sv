`timescale 1ns / 1ps




module tb_mux_project();

reg a,b,c,d,e,f,g,h;
reg [2:0] sel;
wire y;
  
 mux dut (a,b,c,d,e,f,g,h,sel,y); 
 
 
  
  
  covergroup cvr_mux;
    
    option.per_instance = 1;
    
    coverpoint a
    {
      bins a_lo = {0};
      bins a_hi = {1};
    }
    
    
    coverpoint b    {
      bins b_lo = {0};
      bins b_hi = {1};
    }
    
    coverpoint c    {
      bins c_lo = {0};
      bins c_hi = {1};
    }
    
    coverpoint d    {
      bins d_lo = {0};
      bins d_hi = {1};
    }
    
    
    coverpoint e    {
      bins e_lo = {0};
      bins e_hi = {1};
    }
    
    coverpoint f    {
      bins f_lo = {0};
      bins f_hi = {1};
    }
    
    coverpoint g    {
      bins g_lo = {0};
      bins g_hi = {1};
    }
    
    
    coverpoint h    {
      bins h_lo = {0};
      bins h_hi = {1};
    }
    
    coverpoint sel;
    
    coverpoint y;
    
    
    cross_a_sel:cross sel,a {     // Cross between respective sel value with a high and low
      
      ignore_bins sel_other = binsof(sel)intersect{[1:7]};
    }
    
    cross_b_sel:cross sel,b {  // Cross between respective sel value with b high and low
      
      ignore_bins sel_other = binsof(sel)intersect{0,[2:7]};
    }
    
    cross_c_sel:cross sel,c { // Cross between respective sel value with c high and low
      
      ignore_bins sel_other = binsof(sel)intersect{[0:1],[3:7]};
    }
    
    cross_d_sel:cross sel,d { // Cross between respective sel value with d high and low
      
      ignore_bins sel_other = binsof(sel)intersect{[0:2],[4:7]};
    }
    
    cross_e_sel:cross sel,e {  // Cross between respective sel value with e high and low
      ignore_bins sel_other = binsof(sel)intersect{[0:3],[5:7]};
    }
    
    cross_f_sel:cross sel,f {  // Cross between respective sel value with f high and low
      
      ignore_bins sel_other = binsof(sel)intersect{[0:4],[6:7]};
    }
    
    cross_g_sel:cross sel,g {  // Cross between respective sel value with g high and low
      
      ignore_bins sel_other = binsof(sel)intersect{[0:5],7};
    }
    
    cross_h_sel:cross sel,h {   // Cross between respective sel value with h high and low
      
      ignore_bins sel_other = binsof(sel)intersect{[0:6]};
    }
    
       
  endgroup
  
 cvr_mux ci = new();
  
  initial begin
    for (int i = 0; i < 100; i ++) begin
    sel = $urandom();
    {a,b,c,d,e,f,g,h} = $urandom();
    ci.sample();
    #10;
  end 
end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #1200;
    $finish;
    
  end
  
  
  
endmodule