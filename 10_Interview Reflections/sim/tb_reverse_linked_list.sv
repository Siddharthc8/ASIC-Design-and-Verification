`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 11:22:32 AM
// Design Name: 
// Module Name: tb_reverse_linked_list
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


module tb_reverse_linked_list();

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



initial begin
    // Create a linked list: 1 -> 2 -> 3
    Node n1 = new(1);
    Node n2 = new(2);
    Node n3 = new(3);
    
    Node reversed_head;
    Node iter;
    
    n1.next = n2;
    n2.next = n3;

    // Reverse the list

    reversed_head = reverse(n1);

    // Print reversed list: Should print 3, 2, 1
    iter = reversed_head;
    
    while (iter != null) begin
        $display("%0d", iter.data);
        iter = iter.next;
    end
end



endmodule
