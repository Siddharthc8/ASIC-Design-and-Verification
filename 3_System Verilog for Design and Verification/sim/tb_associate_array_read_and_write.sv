`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2025 10:04:21 PM
// Design Name: 
// Module Name: tb_associate_array_read_and_write
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


module tb_associate_array_read_and_write();

     logic[7:0] assoc[int];     // Associate array
     bit [5:0] rand_a;         // 32 combinations
     logic[7:0] rand_d;  
     logic rdat;               
     logic success;
     
     
     initial begin
     
         repeat (32) begin
             success = randomize(rand_a, rand_d);
             write_mem (rand_a, rand_d);          // Method to write rand_d in index rand_a
             assoc[rand_a] = rand_d;
             
         end
         
         
         $display("Memory locations to check:%d", assoc.num());
         
         for(int i=0;i<=31; i++)
             if (assoc.exists(i))begin       // Checks if exits/written if not does not loop
             read_mem(i, rdat);
             if(rdat != assoc[i])
             $display("Error at Addr:%h", i);
             assoc.delete(i);               // Deletes after read to make sure the array is empty after complete read
         end
         
         $display("array size:%d", assoc.num());       // Checking the number of elements
     
     end


endmodule
