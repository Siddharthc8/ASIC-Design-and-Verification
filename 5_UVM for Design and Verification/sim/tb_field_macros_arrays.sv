`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2024 01:04:16 AM
// Design Name: 
// Module Name: tb_field_macros_arrays
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



`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_field_macros_arrays();

 
class array extends uvm_object;
  
  ////////static array
  int arr1[3] = {1,2,3};
  
  ///////Dynamic array
  int arr2[];
  
  ///////Queue
  int arr3[$];
  
  ////////Associative array
  int arr4[int];
  
  
  
  function new(string path = "array");
    super.new(path);
  endfunction 
  
  `uvm_object_utils_begin(array)             // Notice the differnce in commands for static, dynamic, queue and associative arrays 
  `uvm_field_sarray_int(arr1, UVM_DEFAULT);
  `uvm_field_array_int(arr2, UVM_DEFAULT);
  `uvm_field_queue_int(arr3, UVM_DEFAULT);
  `uvm_field_aa_int_int(arr4, UVM_DEFAULT);     // 1st int: datatype ,  2nd int: key
  `uvm_object_utils_end
  
  task run();
    
    ///////////////////Dynamic array value update
    arr2 = new[3];          // Dynmaic array assigned a capacity of 3
    arr2[0] = 2;
    arr2[1] = 2;
    arr2[2] = 2;
    
    ///////////////////Queue
    arr3.push_front(3);
    arr3.push_front(3);
    
    ////////////////////Associative arrays
    arr4[1] = 4;
    arr4[2] = 4;
    arr4[3] = 4;
    arr4[4] = 4;
    
  endtask
  
endclass
 
///////////////////// MAIN MODULE  ///////////////////////
 
  array a;
  
  initial begin
    a = new("array");
    a.run();
    a.print();
  end
  
endmodule