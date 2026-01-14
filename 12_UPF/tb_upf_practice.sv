`timescale 1ns/1ps

module tb_top;

    reg clk;
    reg rst;
    reg in0;
    reg in1;
    reg sel;
    wire out;
    logic iso_enable; 
    logic save; 
    logic restore;

    // Instantiate DUT
    top dut (
        .iso_enable (iso_enable),
        .save (save),
        .restore (restore),
        .clk (clk),
        .rst (rst),
        .in0 (in0),
        .in1 (in1),
        .sel (sel),
        .out (out)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #2 clk = ~clk;
    end

    // Stimulus
    initial begin
        // Initialize
        rst = 1;
        in0 = 0;
        in1 = 0;
        sel = 0;

        // Hold reset for a few cycles
        #12;
        rst = 0;

        // Drive inputs
        #10 in0 = 1;  sel = 0;   // select in0
        #10 in1 = 1;  sel = 1;   // select in1
        #10 in0 = 0;  sel = 0;
        #10 in1 = 0;  sel = 1;

        // Toggle both inputs
        #10 in0 = 1; in1 = 0; sel = 0;
        #10 in0 = 0; in1 = 1; sel = 1;

        // Finish
        #20;
        $finish;
    end

    // Optional monitor
    initial begin
        $monitor("time=%0t rst=%b sel=%b in0=%b in1=%b out=%b",
                  $time, rst, sel, in0, in1, out);
    end

    //  UPF  //
    import UPF::*;

    initial begin
        supply_on("VDD_TOP", 1.0); // Give the port and not net
        supply_on("VDD_MUX", 0.9);
        supply_on("VDD_FLOP", 0.8);
        #5;
        supply_off("VDD_MUX");
        #5;
        supply_on("VDD_MUX", 0.9);


    end 

    initial begin
        iso_enable = 0;
        #4;            
        iso_enable = 1;     // Isolate at 4 as the domain tuens off at 5
        #7;
        iso_enable = 0;
    end

    initial begin
        #5;
        supply_off("VDD_FLOP");
        #5;
        supply_on("VDD_FLOP", 0.9);
    end

    initial begin
        save = 0;
        restore = 0;
        #4;
        save = 1;
        #1;
        save = 0;
        #5;
        //wait for reset condition so extra 2ns
        #2;
        restore = 1;
        #1;
        restore = 0;
    end

endmodule
