`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2024 06:16:37 PM
// Design Name: 
// Module Name: tb_dut
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


module tb_constraint_assert_randomize();

class Generator;             // rand and randc are called modifiers
    randc bit [3:0] a, b;     // rand and randc both can be used
    bit [3:0] y;
    
// .............................................//  Method 1

//    constraint data_a { a > 3; a < 16;}    // Data is the name for the constraint
//    constraint data_b { b == 13;}

// .............................................//  Method 2    
    //                    MENTIONING A RANGE                //
    constraint data_range {  a inside { [0:8], [10:11], 15 };   // 0 1 2 3 4 5 6 7 8   10 11  15
                             b inside { [3:11] };               // 3 4 5 6 7 8 9 10 11 
                          }
                          
// .............................................//  Method 2   
    //                    EXCLUDING A RANGE                         //
    constraint except_data_range {  !(a inside { [0:8], [10:11], 15 });   // 9 12 13 14       Limited by data length
                                    !(b inside { [3:11] });               // 1 2 12 13 14 15  Limited by data length
                                 }


    
endclass

    Generator g;
    int status;
    
    initial begin
        
        
        for (int i=0; i<19 ;i++) begin
            
            g = new();    // Doing this will create a new object everytime and keep us away from unwanted errors    
// .............................................//  Method 1
            
            status = g.randomize();  
            if(status == 0) begin
                $display("Status Method: Randomization failed at %0t", $time);     
                //$finish();           
            end                   // This function returns a value to show whether it worked or not
            $display("%0d   Value of a: %0d, b: %0d with status: %0d", i, g.a, g.b, status);

// .............................................//  Method 2
            
//            assert(g.randomize())else  
//            begin
//              $display("Assert Method: Randomization failed at %0t", $time);     
//              //$finish();           
//            end
//            $display("%0d   Value of a: %0d, b: %0d", i, g.a, g.b); 
            
//// .............................................//  Method 3
             
//            if(!g.randomize()) begin
//                $display("Randomization failed at %0t", $time);     
//                //$finish();           
//            end
//            $display("%0d   Value of a: %0d, b: %0d", i, g.a, g.b);
            
   
            #10;
        end
    end


endmodule
