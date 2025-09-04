`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2025 05:06:38 PM
// Design Name: 
// Module Name: tb_meta_interview
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


module tb_meta_interview();

// Q.1) Write a constraint to generate a random number such that it does not repeat its values for last 5 iterations.
class transaction;
    
    rand int data;
    int history[$];
    
    constraint no_last_5_values { !(data inside { history }); data inside {[0:6]};}
    
    function void post_randomize();
        history.push_front(data);
        
        if (history.size() > 5) begin
            history.pop_back();
        end    
    endfunction
    
endclass


    initial begin
    
        transaction tr = new();
        
        for (int i = 0; i < 20; i++) begin
            if(!tr.randomize()) $display("Error");
            else $write("%4d", tr.data);
        end
        
    end
    
//------------------------------------------------------------------------------------------------//

// Q.2) create a 2D arrray with unique elements.

// NOTE: Unique keyword works on 2D arrays does not work on Vivado

  class transaction1;
    
    rand int array[4][4];
    
    constraint unique_keyword 
    { 
      foreach(array[i, j]) 
      {
        foreach(array[k, l]) 
        {
          if(i != k || j != l) 
          {
            array[i][j] != array[k][l]; 
          }
        }
      }
      foreach(array[i, j]) array[i][j] inside {[0:20]};
    }
    

    endclass

    initial begin
    
        transaction1 tr = new();
        $display("Unique_keyword");
            if(!tr.randomize()) $display("Error");
  			else $display("%p", tr.array);
        
    end

//------------------------------------------------------------------------------------------------//

// Q.3) create a 2D arrray with unique elements using UNIQUE keyword

// Using UNIQUE keyword on flat array

  class transaction2;
    
    rand int array[4][4];
    rand int flat_array[16];
    
    constraint unique_keyword 
    { 
      foreach(array[i,j]) 
      {
        flat_array[i * 4 + j] == array[i][j];
      }
      foreach(array[i, j]) array[i][j] inside {[0:20]};
    }
    

    endclass

    initial begin
    
        transaction2 tr = new();
        $display("Unique_keyword");
            if(!tr.randomize()) $display("Error");
  			else  begin
  			   $display("2D array : %p", tr.array);
  			   $display("Flat array %p", tr.flat_array);
            end
    end
//////////////////////////////////////////
// Using just UNIQUE keyword

    class transaction3;
    
    rand int matrix [4][4];
  
  constraint unique_me { 
      unique { matrix }; 
      foreach(matrix[i,j]) matrix[i][j] inside {[0:20]};
  }  
    
endclass
  
    initial begin
        transaction3 tr = new();
        if(!tr.randomize()) $display("error");
      
        else begin
          for(int i=0; i<4; i++) begin
              for(int j=0; j<4; j++) begin
                  $write("%4d ", tr.matrix[i][j]);
              end
              $display("");
          end
        end
    end
    
    
//-------------------------------------------------------------------------------------------------------------------------------//
//Q.4) what will be the output of this logic.
initial begin
    for (int i = 0; i < 10; i++ ) begin  //---------------|
        fork                                //            |
          $display("Iteration = %0d", i);   //            |
        join_none                           //            |
    //                 <<<<-------------------------------|  Imagine for loop taking palce here
    end
end

// ANSWER

/*
Iteration = 10
Iteration = 10
Iteration = 10
Iteration = 10
Iteration = 10
Iteration = 10
Iteration = 10
Iteration = 10
Iteration = 10
Iteration = 10
*/
    
// EXPLANATION: This is because since it is join_none, the execution of for loop claculation will take place and then display statements will be executed one by one
// The reason it is "10" because the value of i has already incremented for the next iteration internally
// REMEDY : To avoid this issue use automatic infront of the new variable and assign i to this new variable --->> Example below
initial begin
  for (int i = 0; i < 10; i++ ) begin
        fork
          automatic int j = i;
          $display("Iteration = %0d", j);
        join_none
    end
end

// The above code will print like answer for Q4a


//-------------------------------------------------------------------------------------------------------------------------------//
//Q.4a) what will be the output of this logic.
initial begin
    for (int i = 0; i < 10; i++ ) begin  
        fork                             
          $display("Iteration = %0d", i);  // Waits for this operation and then proceeds to next instruction
        join                             
    end
end

// ANSWER

/*
Iteration = 0
Iteration = 1
Iteration = 2
Iteration = 3
Iteration = 4
Iteration = 5
Iteration = 6
Iteration = 7
Iteration = 8
Iteration = 9
*/

//-------------------------------------------------------------------------------------------------------------------------------//
/* Q.5) Explain uvm_config_db syntax

 uvm_config_db#(virtual and_if)::get(this, "", "aif", aif) 
    
    Syntax  -> uvm_config_db#(Type)::<get/set>(arg1, arg2, arg3, arg4);
    1st arg ->  Context is where this is present
    2nd arg ->  Path from which it gets or sets
    3rd arg ->  Key is the name of the value/field being configured
    4th arg ->  This is the actual value being transported 

*/

endmodule


