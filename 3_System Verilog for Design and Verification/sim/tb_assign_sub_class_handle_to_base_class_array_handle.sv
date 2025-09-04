`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2025 12:21:57 PM
// Design Name: 
// Module Name: tb_assign_sub_class_handle_to_base_class_array_handle
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


module tb_assign_sub_class_handle_to_base_class_array_handle();

class base;

    function void i_am();   
        $display("Base");
    endfunction

endclass

class parent extends base;

    function void i_am();
        $display("Base");
    endfunction

endclass

class child extends parent;

    function void i_am();
        $display("Base");
    endfunction

endclass

////////////////     MAIN MODULE   /////////////

    base base_arr[7:0];     // base_arr is an instance of array with each bit capable of holding a subclass instance through it's subclass's handle
    parent p1;
    child c1;
    
    initial begin : initial_block
        
       foreach( base_arr[i] )
       begin : fe_loop
       
        randcase
            2: begin
                    p1 = new();
                    base_arr[i] = p1;   // assigning p1 to base_class array type handle 
               end
               
            1: begin
                    c1 = new();
                    base_arr[i] = c1;  // assigning p1 to base_class array type handle
               end
            endcase
        
       end : fe_loop
       
    end : initial_block


endmodule