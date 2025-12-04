module tb_m_&_p_sequencer_wroking_basics();

class parent;
  
  int a = 5;
  
  
  function void print();
    $display(a);
  endfunction
  
  
endclass


class child extends parent;
  
  int a = 5;
  int b = 10;
  
  function void print();
    $display(b);
  endfunction 
  
endclass

   //.    MAIN MODULE
  
  parent p;
  child c, c1;
  
  initial begin
    
    p = new();
    c = new();
    c1 = new();
    
    p = c;
    c1.b = 20;
    
    // c1 = p;        // This is not allowed by the compiler/language
    $cast(c1, p);
    
    $display(c1.b);   // The op is 10 ie from class "c"
    
    
    
  end
  
  


// Note : Objects come in to existence only during run_time and not compilation time



endmodule