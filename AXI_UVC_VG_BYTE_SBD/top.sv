`include "uvm_macros.svh"
// `include "uvm_pkg.sv"   //. For VG
import uvm_pkg::*;

`include "axi_intf.sv"
`include "axi_common.sv"
`include "axi_tx.sv"
`include "axi_sqr.sv"
`include "axi_drv.sv"
`include "axi_mon.sv"
`include "axi_cov.sv"
`include "axi_responder.sv"
`include "axi_master_agent.sv"
`include "axi_slave_agent.sv"
`include "axi_sbd_byte.sv"
`include "axi_env.sv"
`include "axi_seq_lib.sv"
`include "test_lib.sv"

module top;

    reg clk, rst; 
    axi_intf vif(clk, rst);

    initial begin
        uvm_config_db#(virtual axi_intf)::set(null, "*", "PIF", vif);
    end

    initial begin 
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        repeat(2) @(posedge clk);
        rst = 0;
    end

    initial begin
        run_test("axi_wr_rd_test");
    end

    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, top);   // Replace with top module name
    end

endmodule