module tb_setup_and_hold_assertion();

// SETUP CHECK 
$setup(data, posedge clk, 500);       

// HOLD CHECK 
$hold(posedge clk, hold, 500);

// SETUP AND HOLD CHECK 
$setuphold(data, posedge clk, 500);


endmodule