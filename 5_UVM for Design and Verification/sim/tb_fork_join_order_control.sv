module tb_fork_join_order_control();

// "How do you guarantee that the second display statement in a fork-join executes before the first—without using any #0 delay?"


// 1) NAIVE APPROACH
    initial begin
    fork
        $display("This is First");
        $display("This is Second");
    join
    end

    // NOTE: No control over the order
    // We can #0 but it is not a scalable solution

// 2) USING EVENTS

    event second_done;

    intial begin

        fork 

            begin
                @(second_done);
                $display("This is First");    // Wait for the event before 
            end

            begin
                $display("This is Second");   // Trigger the event to unblock the first
                -> second_done;
            end
        join

    end


// 3) USING SEMAPHORE

    semaphore sem = new(1);

    initial begin
        sem.get(1);   We are locking the semaphore so FIRST can't take it

        fork 

            begin
                sem.get(1);
                $display("This is First");    // Wait until "Second" has released
                sem.put(1);
            end

            begin
                $display("This is Second");   // Release so "First" can proceed
                sem.put(1);
            end

        join

    end

endmodule

// Thanks to Harshal Advane LinkedIn BLOG #4 