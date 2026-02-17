class tb_task_n_function_inside_class_vs_module;

  // Tasks and functions variables are AUTOMATIC by defualt
  // This mimics software so it is AUTOMATIC
  task task_class();

    int i = 0;
    i++;
    $display(i);

  endtask
    
  function void function_class();
    
    int j = 0;
    j++;
    $display(j);
    
  endfunction

endclass

// MODULE 

module module_for_test;

  // Tasks and functions variables are STATIC by defualt
  // This mimics hardware so it is STATIC
  task task_module();

  int i = 0;
  i++;
  $display(i);

endtask
   
function void function_module();
  
  int j = 0;
  j++;
  $display(j);
  
endfunction

endmodule

module one;

  module_for_test m();
  tb_task_n_function_inside_class_vs_module c;
 initial begin
	
   c = new();
         // Cannot create object for module
   
   $display("Inside class for tasks(automatic by default)");
   c.task_class(); 
   c.task_class(); 
   c.task_class(); 
   
   $display("Inside class for functions (automatic by default)");
   c.function_class();
   c.function_class();
   c.function_class();

  // MODULE
   $display("Inside module for tasks (static by default)");
   m.task_module(); 
   m.task_module(); 
   m.task_module(); 
   
   $display("Inside module for tasks (static by default)");
   m.function_module();
   m.function_module();
   m.function_module();
   
 end
  
endmodule