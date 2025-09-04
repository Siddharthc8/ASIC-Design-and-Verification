`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2025 12:08:33 PM
// Design Name: 
// Module Name: tb_pure_virtual
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


module tb_pure_virtual();

    virtual class base;                  // A virtual class exists only to be inherited – it cannot be instantiated. 
    
     pure virtual function void iam();   // A pure virtual class method means an object of this can't be created and has to be inherited if not will throw an error
//         $display ("Base");           // Cannot contain any statemnets either
//     endfunction                 // Should not containt "endfuncton" keyword as well
      
    endclass
     
     class parent extends base;
     
         virtual function void iam();
         $display ("Parent");
         endfunction
         
     endclass
     
     class child extends parent;
     
         virtual function void iam();
            $display ("Child");
         endfunction
     
    endclass
    
    
endmodule
