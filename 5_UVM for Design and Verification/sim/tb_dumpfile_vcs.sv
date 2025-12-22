module top;

    // reg clk, rst;
    // axi_intf vif(clk, rst);

    // initial begin
    //     uvm_config_db#(virtual axi_intf)::set(null, "*", "PIF", vif);
    // end

    // initial begin 
    //     clk = 0;
    //     forever #5 clk = ~clk;
    // end

    // initial begin
    //     rst = 1;
    //     repeat(2) @(posedge clk);
    //     rst = 0;
    // end

    // initial begin
    //     run_test("axi_wr_rd_test");
    // end

    initial begin
        $fsdbDumpfile("waves.vcd");
        $fsdbDumpvars(0, top);   // Replace with top module name (OR) no args or brackets
    end

endmodule