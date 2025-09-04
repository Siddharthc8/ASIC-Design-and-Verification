module tb_constraint_implication_and_equality_operator();

class Generator;
  
  randc bit [3:0] a;
  rand bit ce;
  rand bit rst;
  
  constraint control_rst {
    rst dist {0:= 80, 1 := 20};
  }
  
  
  constraint control_ce {
    ce dist {1:= 80, 0 := 20};
  }
  
  constraint control_rst_ce_implication {
    ( rst == 1 ) -> (ce == 0);    // When rst = 0,    ce = 1 is forced
  }
  
  constraint control_rst_ce_equality {
    ( rst == 1 ) <-> (ce == 0);    // When rst = 0,    ce = 1 is forced
  }                                // When ce = 0,     rst = 1 is forced
   
endclass
  
  
  Generator g;
  
  initial begin
    g = new();
    
    for (int i = 0; i<10 ; i++) begin
      assert(g.randomize()) else $display("Randomization Failed");
      $display("Value of rst : %0b and ce : %0b", g.rst, g.ce);
    end
    
  end
 
  
endmodule