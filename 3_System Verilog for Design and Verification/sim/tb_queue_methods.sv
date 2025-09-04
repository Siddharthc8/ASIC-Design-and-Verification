`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2025 10:28:03 PM
// Design Name: 
// Module Name: tb_queue_methods
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


 module tb_queue_methods();

    string qstr[$],res[$]; int idx[$];
    
     initial begin
     
         qstr= {"A","D","C","B","A","E","C"};
         res = qstr.find(i) with(i>="D");                     // {"D","E"}
         res = qstr.max();                                   // {"E"}
         idx = qstr.find_last_index with(item>"C");          // {5}
         res = qstr.unique();                                // {"A","D","C","B","E"}
    
    end

//..............................................................

    string qstr[$];
    
     initial begin
     
         qstr= {"A","D","C","B","E"};
         
         qstr.sort;                  // {"A","B","C","D","E"}
         qstr.rsort();              //  {"E","B","C","D","A"}
         qstr.reverse;              // {"E","D","C","B","A"}
         qstr.shuffle;              // {"D","C","E","A","B"}
         
    end


   ///...............................................................
   
    logic[7:0] narr [3:0] ='{8'ha,8'h0,8'hf,8'h5};
     int ia2d[2][2] = '{default:2};
     int j;

    initial begin
         j= narr.xor;                        // 0
         j= narr.sum;                        // 1e
         
         ia2d = '{'{1,2},'{3,4}};
         j = ia2d.sum with (item.product);  // 14 ((4*3)+(1*2))      //.... INTERSTING...//
    end
    /////......................................................................../////
    //   Implemeting without methods but using logic
    
    
    
    int q_int[$]; // queue of unlimited size
     int data;
     initial begin
     q_int ={0,q_int}; // {0} push_front
     q_int ={q_int,1}; // {0,1} push_back
     q_int ={2,q_int}; // {2,0,1} push_front
     q_int ={q_int[0],3,q_int[1:$]}; // {2,3,0,1} insert
     q_int ={q_int[0:2],4,q_int[3]}; // {2,3,0,4,1} insert
     q_int ={q_int[0:1],q_int[3:4]}; // {2,3,4,1} delete
     q_int ={q_int[0:1],5,q_int[2:3]}; // {2,3,5,4,1} insert
     data =q_int[$];q_int= q_int[0:$-1]; // {2,3,5,4} data = 1 pop_back
     data =q_int[0];q_int= q_int[1:$]; // {3,5,4} data = 2 pop_front
     while (q_int.size()> 0) begin // checking queue size
     data= q_int[$]; // loop executes 3 times pop_back
     q_int= q_int[0:$-1];end
     end
    
    
    
    



endmodule
