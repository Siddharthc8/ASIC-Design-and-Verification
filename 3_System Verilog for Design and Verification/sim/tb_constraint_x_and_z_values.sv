module tb_constraint_x_and_z_values;

class four_state_randomizer;
    
    rand bit [1:0] value;
    logic result;
    
    constraint four_state {
        value inside {2'b00, 2'b01, 2'b10, 2'b11};
    }
    
    function void post_randomize();
        case(value)
            2'b00: result = 1'b0;
            2'b01: result = 1'b1;
            2'b10: result = 1'bx;
            2'b11: result = 1'bz;
        endcase
    endfunction
    
endclass


    initial begin
        four_state_randomizer fsr = new();
        
        repeat(10) begin
            if(fsr.randomize()) begin
                $display("Randomized value: %b", fsr.result);
            end
        end
    end
endmodule