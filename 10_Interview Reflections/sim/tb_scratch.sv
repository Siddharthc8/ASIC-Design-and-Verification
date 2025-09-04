`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2025 09:16:11 AM
// Design Name: 
// Module Name: tb_scratch
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


module tb_scratch();


class first_class;
    
    rand int array[];               // Don't forget the rand
    
    constraint ranger {
        soft array.size() inside {[100:200]};        // Rnaged it within 100 to 200
        foreach(array[i]) array[i] % 2 == 0;    // All values even
     }

endclass

// FOLLOW UP :: Override the size to be something to be in the range of 1000 to 2000

initial begin
    
    automatic first_class fc = new();
    fc.randomize() with { fc.array.size() inside {[1000:2000]}; };  // In order for this to work use "soft" keyword
    $display("Size - %d \n %p", fc.array.size(), fc.array); 
end

endmodule

