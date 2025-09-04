`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2024 01:40:53 PM
// Design Name: 
// Module Name: tb_a22
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

module tb_a22();

class my_object extends uvm_object;
//`uvm_object_utils(my_object)

    function new(string path = "my_object");
        super.new(path);
    endfunction
    
    rand bit [1:0] a;
    rand bit [3:0] b;
    rand bit [7:0] c;
    
    `uvm_object_utils_begin(my_object)
    `uvm_field_int(a, UVM_DEFAULT);
    `uvm_field_int(b, UVM_DEFAULT);
    `uvm_field_int(c, UVM_DEFAULT);
    `uvm_object_utils_end
    
endclass

    my_object obj, obj1;
    int status;
    
    initial begin
        obj = my_object::type_id::create("obj");
        obj1 = my_object::type_id::create("obj1");
        
        obj.randomize();
        obj1.copy(obj);
        
        obj.print();
        obj1.print();
        
        status = obj1.compare(obj);
        `uvm_info("tb", $sformatf("%0d", status), UVM_NONE);
    end

endmodule