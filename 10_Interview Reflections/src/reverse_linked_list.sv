`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 11:23:22 AM
// Design Name: 
// Module Name: reverse_linked_list
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


module reverse_linked_list();

class Node;
    int data;
    Node next;

    // Constructor
    function new(int d = 0);
        data = d;
        next = null;
    endfunction
endclass

// Reverse function (standalone or in another class)
function Node reverse(Node head);
    Node prev = null;
    Node curr = head;
    Node next;

    while (curr != null) begin
        next = curr.next;
        curr.next = prev;
        prev = curr;
        curr = next;
    end
    return prev;
endfunction


class Node1;
    
    int data;
    Node1 next;
    
    function new(input int d = 0,input Node1 n = null);
        
        data = d;
        next = n;
    
    endfunction 

endclass


function Node1 reverse1(input Node1 head);
    
    Node1 curr;
    Node1 prev;
    
    curr = head;
    prev = null;
    
    while( curr != 0) begin
        
        Node1 temp;
        
        temp = curr.next;
        curr.next = prev;
        
        prev = curr;
        curr = temp;
        
    end
    
    return prev;
    
endfunction


endmodule
