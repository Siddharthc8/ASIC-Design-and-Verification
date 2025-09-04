`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 11:36:02 AM
// Design Name: 
// Module Name: tb_scratch
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


module tb_scratch();

    reg clk = 0;
    reg clk50 = 0;
    
    always #5 clk = ~clk;
    
    task calc(input real freq_hz, input real duty_cycle, input real phase, output real pout, output real ton, output real toff);
        pout = phase;
        ton = (1.0 / freq_hz) * 1000_000_000 * duty_cycle;
        toff = (1.0 / freq_hz) * 1000_000_000 * (1 - duty_cycle);
    endtask
    
    task clkgen(input real pout, input real ton, input real toff);
        @(posedge clk);               // 
        #pout;
        while(1) begin
            clk50 = 1;
            #ton;
            clk50 = 0;
            #toff;
        end
    endtask
    
    real pout;
    real ton;
    real toff;
    
    initial begin
        calc(100_000_000, 0.1, 0, pout, ton, toff);
        clkgen(pout, ton, toff);
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
    
    initial begin
        #200;
        $finish();
    end
endmodule

