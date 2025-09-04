`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2024 12:27:58 AM
// Design Name: 
// Module Name: tb_semaphore
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

// Used to control to flow of code execution  within / between tasks

module tb_semaphore();       //  Behaves likes a class so have to call a constructor with 1 in brackets

class First;

  rand int data;
  constraint data_c {data < 10; data > 0;}
 
endclass
 
 
class Second;
  
  rand int data;
  constraint data_c {data > 10; data < 20;}
  
endclass
 
 
class Main;
  
  semaphore sem;            // Decalring a semaphore named sem
  
  First f;
  Second s;
  
   int data;
   int i;
  
  task send_first();
    
        sem.get(1);     // Getting semaphore access is by semaphore_name.get(no_of_keys)       //   Blocking assignment
    
    for(i = 0; i<10; i++) begin
      f.randomize();
      data = f.data;
      $display("First access Semaphore and Data sent : %0d", f.data);
      #10;
    end 
    
    
    sem.put(1);        //  Putting back the semaphore that used           //   Blocking assignment
    
    $display("Semaphore Unoccupied");
  endtask
  
  
  task send_second();
    sem.get(1);       // Getting semaphore access is by semaphore_name.get(no_of_keys)       //   Blocking assignment
    
    for(i = 0; i<10; i++) begin   
      s.randomize();
      data = s.data;
      $display("Second access Semaphore and Data sent : %0d", s.data);
      #10;
    end  
    
    sem.put(1);     //  Putting back the semaphore that used           //   Blocking assignment
    $display("Semaphore Unoccupied");
    
  endtask
  
  
  task run();      // This task instantiates the required classes and helps us run the code in one command
    sem = new(123);      //   Calling a constructor for semaphore should be with a name as each semaphore has its name in the braces
    f = new();
    s = new();
  
   fork
     send_first();
     
     send_second();
   join
   
  endtask
  
  
endclass
 
 // ...........................Main module starts.......................
 
  Main m;
  
  initial begin
    m = new();
    m.run(); 
  end
  
  initial begin
    #250;
    $finish();
  end
  
endmodule
