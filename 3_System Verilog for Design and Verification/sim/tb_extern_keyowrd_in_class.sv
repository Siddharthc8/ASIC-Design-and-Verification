`timescale 1ns / 1ps




module tb_extern_keyowrd_in_class();
    
    
    class myclass;
    
     int number;
     
     task set (input int i);
     number = i;
     endtask
     
     extern function int get();   // Use extern keyword to call sub-routine outside the class
     
     endclass
         
     function int myclass::get();  // Should mention the scope of it
     return number;
         
     endfunction

endmodule