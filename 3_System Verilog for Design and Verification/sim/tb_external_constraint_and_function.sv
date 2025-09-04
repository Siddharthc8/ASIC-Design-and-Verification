`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2024 09:58:37 PM
// Design Name: 
// Module Name: tb_external_constraint
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

module tb_external_constraint_and_function();


class Generator;             // rand and randc are called modifiers

    randc bit [3:0] a, b;     // rand and randc both can be used
    bit [3:0] y;
    
    extern constraint data;
    
    extern function void display();
     
endclass

// First make sure to call it inside a class
    
 // Syntax --> constraint class_name::constraint_name { constraints } 
    constraint Generator::data {  a inside { [0:8] };       // 0 1 2 3 4 5 6 7 8   
                                  b inside { [3:11] };      // 3 4 5 6 7 8 9 10 11 
                               }       
                                                
 // Syntax -->  function return_type class_name::function_name();  ......  endfunction                            
    function void Generator::display();
        $display( "Value of a: %0d, b: %0d ", a, b);
    endfunction
    

    
    Generator g;
    int status;
    
    initial begin
        
        for (int i=0; i<19 ;i++) begin
            
            g = new();
            
            status = g.randomize();  
            if(status == 0) begin
                $display("Status Method: Randomization failed at %0t", $time);     
                //$finish();           
            end                   // This function returns a value to show whether it worked or not
            g.display();
            #10;
        end
    end

endmodule
