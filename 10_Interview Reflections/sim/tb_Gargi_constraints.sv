
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2025 07:19:49 PM
// Design Name: 
// Module Name: tb_Gargi_constraints
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


module tb_Gargi_constraints();



//1.	Write a constraint to generate all numbers of power of 2. (Don't use 2**n` or any inbuilt function for power.)

class C;
  
rand int unsigned a[];

constraint pow2 {
soft  $size(a,1)==10;
foreach(a[i]) {
  if(!i) a[i]==1;
  else if (i==1) a[i]==2;
  else a[i]==a[i-1]*2;
}
};


function void print();
	foreach(a[i])
		$write("%0d\t",a[i]);
endfunction
  
  endclass
module test;
 C c1;
 initial begin
	c1=new;
   if(c1.randomize() with { $size(a,1)==5;})  c1.print();
	else $display("Failed to randomize");
 end


endmodule


//2.	Write a constraint to generate a number that is always a multiple of 4.
class A;

    int a[10];
   
    constraint cs{ 
        foreach(a[i]) {
          a[i] % 4 == 0;
        }
    }
    

endclass


//3.	Write a constraint for an array such that all the elements are unique and in ascending order

/*Usual uniq way
rand int myArray[];
constraint uniqueValues {
unique(myArray);
}

without unique ,you just create an ascending array and  in function post_randomize();  -->myArray.shuffle();
*/


class C;
  
rand int unsigned a[];

constraint pow2 {
  
soft  $size(a,1)==10;
soft foreach(a[i])  a[i] inside {[0:200]};
  foreach(a[i]) {
    foreach(a[j]){
  if(i>0) a[i] > a[i-1]; //ascending   **Note just putting this constraint is enough,it will be unique with just this.
    if(i!=j)  a[i] != a[j]; //unique
}
}
  }

function void print();
	foreach(a[i])
		$write("%0d\t",a[i]);
endfunction
  
  endclass
  
  //4. Unique elements for 2D array
  
  class C;
 rand int unsigned a[][];
 
 
constraint uniq2D{

  foreach (a[i,j]) a[i][j] inside {[0:10]};
  soft $size(a,1)==5; 
  foreach (a[i]) a[i].size==$size(a,1);
  
  foreach(a[i,j]) {
    foreach(a[p,q]) {
      if(i !=p || j !=q) a[i][j] !=a[p][q];
	
	}
  }
}
   
      function void print();
    for(int i =0;i< $size(a,1);i++) begin
      for(int j=0;j< $size(a,1);j++) begin
       $write("%0d\t",a[i][j]);
      end
      $display("\n");
    end
endfunction
  


endclass
module test;
 C c1;
 initial begin
   c1=new;
   if(c1.randomize() with {$size(a,1)==3;})  c1.print();
	else $display("Failed to randomize");
 end


endmodule

//If && is used
0	5	7(0,2)	

3	10	3	

4	10	7(2,2)

0!=2 && 2!=2 --> 1&&0=0 so a[0][2] can be equal to a[2][2]	


//5.	Write a constraint for a 2D array of integers such that the value of any element in that array should not be equal to its adj element.

class C;
 rand int unsigned a[][];
 
 
constraint uniq2D {

  foreach (a[i,j]) a[i][j] inside {[0:10]};
  soft $size(a,1)==5; 
  foreach (a[i]) a[i].size==$size(a,1);
  
  foreach(a[i,j]) {
    foreach(a[p,q]) {
      if(    ((p==i+1 ||i==p+1) && q==j) || (  (q==j+1 || j== q+1 ) && p==i))  a[i][j] !=a[p][q];
	
	}
  }
}
   
      function void print();
    for(int i =0;i< $size(a,1);i++) begin
      for(int j=0;j< $size(a,1);j++) begin
       $write("%0d\t",a[i][j]);
      end
      $display("\n");
    end
endfunction
  


endclass
module test;
 C c1;
 initial begin
   c1=new;
   if(c1.randomize() with {$size(a,1)==3;})  c1.print();
	else $display("Failed to randomize");
 end


endmodule

//6.neighbouring elements(diag also included)

class C; 
 rand int unsigned a[][];
 
 
constraint uniq2D{

  foreach (a[i,j]) a[i][j] inside {[0:10]};
  soft $size(a,1)==5; 
  foreach (a[i]) a[i].size==$size(a,1);
  
  foreach(a[i,j]) {
    foreach(a[p,q]) {
      if( p==i+1 ||i==p+1 ||q==j+1 || j== q+1 ) a[i][j] !=a[p][q];
	
	}
  }
}
   
      function void print();
    for(int i =0;i< $size(a,1);i++) begin
      for(int j=0;j< $size(a,1);j++) begin
       $write("%0d\t",a[i][j]);
      end
      $display("\n");
    end
endfunction
  


endclass
module test;
 C c1;
 initial begin
   c1=new;
   if(c1.randomize() with {$size(a,1)==5;})  c1.print();
	else $display("Failed to randomize");
 end


endmodule


//7.	Write constraint for the below requirements : 
//a.	The queue size will be 15. Randomize a queue such that it exactly has four 7 in it.
//b.	No 7's should be at the consecutive next to each other 


class C;
  
  rand int unsigned a[],q[$];
  
  constraint size {
    $size(a,1) ==15;
  foreach(a[i])  a[i] inside {[5:20]};
  }
 
    constraint count_sevens {
    (a.sum() with (int'(item == 7))) == 4;
    }

constraint noadj_7s {
  
   foreach(a[i]) 
    if(i > 0 && a[i]==7) a[i-1] !=7;
   }
  
  
  //For the other elements to be unique -optional
  constraint uniq {
    foreach(a[i]) {
      foreach(a[j]) {
        if ((i!=j) &&!(a[i] ==7 && a[j] ==7))a[i]!=a[j];
      }}}
  
  
function void post_randomize();
  foreach(a[i]) q.push_back(a[i]);
  $display("q:%0p ",q);
endfunction
  
  endclass
module test;
 C c1;
 initial begin
	c1=new;
   if(c1.randomize()) $display("Yaay...");
	else $display("Failed to randomize");
 end


endmodule

//8.3.	Write a constraint to generate all numbers of power of 2.

rand int unsigned a[];

constraint pow2 {
soft  $size(a,1)==10;
 
foreach(a[i]) {
  a[i] inside {[0:200]};
  if(i>0) a[i] > a[i-1];
}
};

//9 Number should not be from in last 5 iterations
class test;
  
  rand bit[7:0] a ;
  bit [7:0]b[4:0];
  
  
  constraint c {!(a inside b);};
  
 function void post_randomize();
 
   for(int i=4;i>0;i--)
     b[i]=b[i-1];
   
   b[0]=a;
   $display("a=%0h,b=%0p",a,b);
   
 endfunction
endclass
  
  program p;
    test t;
    initial begin
      t=new;
      repeat(10)
        void'(t.randomize());
    end
  endprogram
      
/*10. Write a constraint to follow the rules for the given matrix below. 
 NOTE : the last value of the matrix SHOULD NOT be randomized or touched. */
 
 /* [  X    O   E   O  ]    O -> Odd
    [  O    X   O   E  ]    E -> Even 
    [  E    O   X   O  ]
    [  O    E   O   Z  ]  -> Z indicates do not touch/randomize
*/
 class transaction;
    rand logic [7:0] matrix [4][4];
    rand logic temp;
    
    function void post_randomize();
    
        foreach(matrix[i,j]) begin
            if(i == j && i != $size(matrix)-1 ) begin
                matrix[i][j] = 'z;
            end
        end
        
    endfunction
    
    constraint arr2d { 
    foreach(matrix[i,j]) {
  
        if((i+j) % 2 == 0) {                                                                                               
            matrix[i][j] % 2 == 0;  // Must be even                                                                             
        }                                                                                                                       
         
        else {                                                                                                                  
            matrix[i][j] % 2 != 0;  // Must be odd                                                                              
        }                                                                                                                       
                                                                                                                                
        if(i != j ) {                                                                                                           
            matrix[i][j] inside {[2:20]};                                                                                       
        }                                                                                                                       
    }                                                                                                                           
}                                                                                                                               
endclass
      
    module t;
    initial begin                                                                                                               
     transaction tr = new(); 
//    tr.matrix[3][3].rand_mode(0);         
    if(!tr.randomize()) $display("error");                                                                                             
    else begin
        for(int i=0; i<4; i++) begin
            for(int j=0; j<4; j++) begin
              $write("%d ", tr.matrix[i][j]);
            end
            $display("");
        end
    end
end

endmodule

endmodule
