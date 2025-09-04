`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2025 01:59:00 AM
// Design Name: 
// Module Name: tb_static_methods
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


module tb_static_methods();

 class frame;  
 
 static int frmcount;      // Static variable
 int tag;    
 logic [4:0] addr;
 logic [7:0] payload;
 logic parity;
 
 function new(input int add, dat);
     addr = add;
     payload = dat;
     genpar();
     frmcount++;         // Static variable is incremented to count number of objects created 
     tag = frmcount;
 endfunction
 
 static function int getcount();
    return (frmcount);            // Can only access static members of the class
 endfunction
 
 endclass
 
 ///////    MAIN MODULE   ////
 
 frame f1,f2;
 int frames;
 
 initial
 begin
     frames = frame::getcount();// 0    // Called using scope operator
     frames = f2.getcount(); // 0       // dot operator on f2 even before f2 object is created and yes this is allowed
     f1 = new(3,4);
     f2 = new(5,6);
     frames = f2.getcount(); // 2      // Since 2 objects were created o/p is 2 as count increases with object creation
 end
 

endmodule