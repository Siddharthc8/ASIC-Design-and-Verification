`timescale 1ns/1ps




module a48_21_Merge_Two_Sorted_Lists();
    
    class Node;
        
        int data;
        Node next;
        
        function new(input int d = 0, input Node n = null);
            data = d;
            next = n;
        endfunction
    
    endclass
    
    class solutions;
    
        
        function Node mergeTwoLists(input Node list1, input Node list2);
            
            Node dummy = new(0);
            Node curr;
            curr = dummy;
            
            while ( list1 != null && list2 != null) begin
                
                if(list1.data < list2.data) begin
                    curr.next = list1;
                    list1 = list1.next;
                    curr = curr.next;
                end
                else begin
                    curr.next = list2;
                    list2 = list2.next;
                    curr = curr.next;
                end
                
            end
            
            if ( list1 != null) curr.next = list1;  // OR //   curr.next = list1 != 1 ? list1 : list2;
            else curr.next = list2;                 
            
            return dummy.next;
        endfunction
        
        
        // Create linked list from queue
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
            int list1[$];
            int list2[$];
            int expected[$];
        } test_case_t;
        
        test_case_t test_cases[$] = '{
            // Standard cases
            '{'{1,2,4}, '{1,3,4}, '{1,1,2,3,4,4}},
            '{'{}, '{0}, '{0,0}},
            '{'{}, '{}, '{0,0}},
            
            // Edge cases
            '{'{5}, '{1,2,4}, '{1,2,4,5}},
            '{'{2,6,7}, '{3,5}, '{2,3,5,6,7}},
            '{'{1,3,5}, '{2,4,6}, '{1,2,3,4,5,6}}
        };
    
        foreach (test_cases[i]) begin
            // Local variables
            Node l1 = solver.createList(test_cases[i].list1);
            Node l2 = solver.createList(test_cases[i].list2);
            Node merged;
            int result[$];
            int expected[$];
            string pass;
            
            // Merge lists
            merged = solver.mergeTwoLists(l1, l2);
            expected = test_cases[i].expected;
            
            // Convert and verify
            result = solver.listToQueue(merged);
            pass = (result == expected) ? "PASS" : "FAIL";
            
            // Standard output format
            $display("Input list1 -> %p \nInput list2 -> %p \nExpected merged: %p \nActual   merged: %p \nResult -> %4s \n\n",
                     test_cases[i].list1,
                     test_cases[i].list2,
                     test_cases[i].expected,
                     result,
                     pass);
        end
    
        #10 $finish;
    end

endmodule




