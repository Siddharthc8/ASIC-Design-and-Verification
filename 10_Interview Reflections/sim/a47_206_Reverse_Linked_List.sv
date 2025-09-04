`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 05:16:54 PM
// Design Name: 
// Module Name: a47_206_Reverse_Linked_List
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


module a47_206_Reverse_Linked_List();

class Node;
    
    int data;
    Node next;
    
    function new(input int d = 0, input Node n = null);
        data = d;
        next = n;
    endfunction
    
endclass


class solutions;

    function Node reverseList(input Node head);
        
        Node curr;
        Node prev;
        
        curr = head;
        prev = null;
        
        
        while( curr != null ) begin
            
             Node temp;
             
             temp = curr.next;
             curr.next = prev;
             prev = curr;
             curr = temp;
        
        end
        
        return prev;
    
    endfunction
    
    
    function Node createList(input int vals[$]);
    
        Node head;
        Node curr;
        head = new(vals[0]);
        curr = head;
        
        for(int i = 1; i < vals.size(); i++) begin
            
            curr.next = new(vals[i]);
            curr = curr.next;
            
        end
        
        return head;
    endfunction
    
    typedef int ret_type[$];
    
    function ret_type listToQueue(input Node head);
        
        int result[$];
        Node curr;
        curr = head;
        
        while(curr != null) begin
            
            result.push_back(curr.data);
            curr = curr.next;
            
        end
    
        return result;
    endfunction
    
endclass





    initial begin
        solutions solver = new();
        
        typedef struct {
            int vals[$];      // Input values
            int expected[$];  // Expected reversed values
        } test_case_t;
        
        test_case_t test_cases[$] = '{
            '{'{1,2,3,4,5}, '{5,4,3,2,1}},  // Standard case
            '{'{1,2}, '{2,1}},               // Two nodes
            '{'{1}, '{1}},                   // Single node
            '{'{}, '{0}}                      // Empty list
        };
    
        foreach (test_cases[i]) begin
            // Local variables
            Node head, reversed;
            int result[$];
            string pass;
            int expected[$];
            
            // Create and reverse list
            head = solver.createList(test_cases[i].vals);
            reversed = solver.reverseList(head);
            expected = test_cases[i].expected;
            
            // Convert to queue and verify
            result = solver.listToQueue(reversed);
            pass = (result == expected) ? "PASS" : "FAIL";
            
            // Standard output format
            $display("Input list -> %p \nExpected reversed: %p \nActual   reversed: %p \nResult -> %4s \n\n",
                     test_cases[i].vals,
                     test_cases[i].expected,
                     result,
                     pass);
        end
    
        #10 $finish;
    end

endmodule
