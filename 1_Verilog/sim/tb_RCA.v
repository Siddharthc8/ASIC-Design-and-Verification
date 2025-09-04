`timescale 1ns / 1ps

module tb_RCA_4bit();

    reg x, y, cin;
    wire [3:0]sum, cout;
    
    RCA_4bit dut(
        
        .x(x),
        .y(y),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
    
    initial begin  //Initialization
        x=0;
        y=0;
        cin=0;
    end
    
    initial begin  // Assertions
        #10 x=4'd4; y=4'd1; cin=1'd0;
        #10 x=4'd10; y=4'd15; cin=1'd0;
        #10 x=4'd3; y=4'd5; cin=1'd1;
        #10 x=4'd4; y=4'd1; cin=1'd0;
        #10 x=4'd4; y=4'd1; cin=1'd0;
        
    end
    
    initial begin
        $monitor ($time, "a=%d, b=%d, cin=%d, sum=%d, cout=%d", x,y,cin,sum,cout);
        #100 $finish;
    end
endmodule
