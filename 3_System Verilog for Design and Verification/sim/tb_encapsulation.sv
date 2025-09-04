`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2025 02:13:22 AM
// Design Name: 
// Module Name: tb_encapsulation
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


module tb_encapsulation();

 class frame;
 
 logic no_protection;
 
 local logic [4:0] addr;     // Can be accessed by only that class       Denied for outside access
 local logic [7:0] payload;
 protected bit parity;       // can only be accessed by class and extensions    Denied for outside access

 function new(input int add, dat);
 super.new(add,dat);
 endfunction

 endclass
 
 //.................................
 
 class tagframe extends frame;
 
 static int frmcount;
 int tag;
 
 function new(input int add, dat);
 super.new(add,dat);
 endfunction 
endclass
 
 //.......................................
 
 class errframe extends tagframe;
 
 local static int errcount;
 
 function new(input int add, dat);
 super.new(add,dat);
 endfunction
 
 function void add_error();
     parity = ~parity;
     errcount++;
 endfunction
 
 static function int geterr();
     return (errcount);
 endfunction
 
 endclass


//////            AMIN MODULE     ///////////

logic add1, data1;
logic no_errs;

errframe one = new( add1, data1 );
frame fr = new( add1, data1 );

 initial begin
     
     fr.no_protection = 1; // OK
     one.no_protection = 0; // OK
//     one.errcount = 0; // ERROR
//     one.parity= 1; // ERROR
//     one.add_error(); // OK
//     no_errs= one.errcount; // ERROR
     no_errs= errframe::geterr();// OK
 end

endmodule
