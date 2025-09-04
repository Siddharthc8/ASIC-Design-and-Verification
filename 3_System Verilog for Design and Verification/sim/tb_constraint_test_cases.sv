`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2025 09:50:08 AM
// Design Name: 
// Module Name: tb_constraint_test_cases
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


module tb_constraint_test_cases();

class RandomGen;
  rand int value;
  int last_5_values[$]; // dynamic queue to store last 5 values

  constraint no_repeat {
    !(value inside {last_5_values}); // new value must not be in last 5
  }

  function void post_randomize();
    last_5_values.push_back(value);   // Add new value to the list
    if (last_5_values.size() > 5)
      last_5_values.pop_front();      // Maintain only last 5
  endfunction
endclass


class mango_distributor;
  rand int boys[4];   // Mangoes per boy (each >= 1)
  rand int girls[5];  // Mangoes per girl (each >= 1)

  constraint fair_distribution {
    // Sum of all mangoes must be 20
    boys.sum() + girls.sum() == 20;

    // Each boy and girl gets at least 1 mango
    foreach (boys[i])  boys[i]  >= 1 && boys[i] <= 5;
    foreach (girls[i]) girls[i] >= 1 && girls[i] <= 5;

  }
  
  constraint favor_boys {
  boys.sum() > girls.sum();  // Boys get more mangoes
 }
  
  constraint equal_avg {
  boys.sum() / 4 == girls.sum() / 5;  // Same average per child
}
  
  
endclass



class pirate_distributor;
  rand int coins[3];  // coins[0] = captain

  constraint fair_plunder {
    coins.sum() == 100;
    foreach (coins[i]) coins[i] >= 10;
    coins[0] >= 2 * coins[1];  // Captain's share
    coins[0] >= 2 * coins[2];
  }
endclass

class poker_dealer;
  rand bit [5:0] cards[5];  // 6-bit to represent 52 cards

  constraint no_duplicates {
    //unique {cards};
    foreach (cards[i]) cards[i] inside {[1:52]};
  }
endclass


class unique_2D_array;

    rand bit [7:0] array2d[4][4];
        
    constraint all_unique { 
                             foreach (array2d[i,j]){
                               foreach(array2d[k,l]) {
                                 array2d[i][j] != array2d[j][l]; 
                                } 
                              }
       } 
       
       //constraint single { unique {array2D}; }
  
 endclass
   
class unique_2D_array1;

    rand bit [7:0] array2d[4][4];
        
    constraint all_unique {
    foreach (array2d[i1, j1]) {
      foreach (array2d[i2, j2]) {
        if ((i1 != i2) || (j1 != j2)) {
          array2d[i1][j1] != array2d[i2][j2];
        }
      }
    }
  }
    //constraint isaac { foreach(process[start_time]){ process[start_time] inside {start_time, start_time+5}; }

endclass

class task_scheduler;

function int abs(input int n);

    if ( n < 0) begin
        return -n;
    end
    else begin
        return n;
    end
    
endfunction

  rand int start_time[3];  // Hours (0-23)
    
  constraint valid_schedule {
    foreach (start_time[i]) {
      start_time[i] inside {[0:19]};  // 5hr task must end by 24hr
      foreach (start_time[i,j]) if (i != j) {
        abs(start_time[i] - start_time[j]) >= 5;  // No overlap
      }
    }
  }
endclass


class task_scheduler1;


  rand int start_time[3];  // Hours (0-23)
    
  constraint valid { foreach (start_time[i]) start_time[i] inside {[0:19]};
                     foreach(start_time[i,j]) if (i!=j) {
                        (start_time[i] - start_time[j]) >= 5 || (start_time[i] - start_time[j]) <= -5
                        };
                     }
endclass


  
class array2D;

    rand bit [7:0] array2d[4][4];
        
    constraint uniq { foreach(array2d[i1,j1]) {
                        foreach(array2d[i2,j2]) {
                            if((i1 != i2) || (j1 != j2)) {
                                array2d[i1][j1] != array2d[i2][j2];
                            }
                        }
                      }
                      
                    }
                                
    //constraint isaac { foreach(process[start_time]){ process[start_time] inside {start_time, start_time+5}; }

endclass

  unique_2D_array a = new();
  
initial begin
          
      a.randomize();
      
  $display("%p", a.array2d); 
end
endmodule
