`timescale 1ns / 1ps




module tb_packed_array();
    
    // Only logic, reg or bit can be used in packed array as packed arrays are generally sysnthesizable
    // can be assigned to variable lengths as it either truncates or pads
    
    logic [1:0] [7:0] packarr;   // This is considered to be 2  dimensional 16 bit logic vector
    logic [7:0] short = 8'hAA;
    logic [23:0] long = 24'h55AACC;
    
    initial begin
        packarr = 16'h0;
        packarr = packarr << 1;
        packarr = ~packarr;
        
        packarr = short;   // Short is 16 bit logic vector and packarr is 1 dimensional 8 bit so pads the extra bits to "0"
        packarr = long;    // Long is a 24 bit logic vector so the extra bits are truncated
    end
    
endmodule