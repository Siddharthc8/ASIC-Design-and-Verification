`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 06:40:10 PM
// Design Name: 
// Module Name: tb_copying_object_of_class
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

module tb_copying_object_of_class();
    
class First;
    
    int data = 23;
    
endclass    

    First f1;
    First f2;
    
    initial begin
        f1 = new();
        f1.data = 24;        
        
        f2 = new f1;           // Copying class f1 --> f2 
        
        f1.data = 30;        // After copying they behave like two diferent objects 
        f2.data = 50;        // so any changes made to the either of them wont reflect on the other one unless you do a copy function again
        $display("Data member: %0d", f1.data);
        $display("Data member: %0d", f2.data);
    end

endmodule
