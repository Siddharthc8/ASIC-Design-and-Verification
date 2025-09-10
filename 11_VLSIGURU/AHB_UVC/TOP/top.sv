`include "uvm_pkg.sv"
import uvm_pkg::*;

`include "ahb_common.sv"
`include "ahb_tx.sv"
`include "ahb_seq_lib.sv"
`include "ahb_sqr.sv"
`include "ahb_drv.sv"
`include "ahb_mon.sv"
`include "ahb_cov.sv"
`include "ahb_magent.sv"
`include "ahb_sagent.sv"
`include "ahb_env.sv"

module top
    
    reg clk, rst;
    integer count = 3;

    ahb_intf pif(clk, rst);

    initial begin
        clk = 0;
        forever #5 clk = !clk;
    end

    initial begin
        rst = 1;
        #20;
        rst = 0;
    end

    `include "test_lib.sv"

    initial begin
        run_test("");
    end

    initial begin
        $value$plusargs("count=%d", count);
        uvm_resource_db#(virtual ahb_intf)::set("AHB", "VIF", vif, null);
        uvm_config_db#(virtual ahb_intf)::set(uvm_root::get(), "*", "vif" pif);
        uvm_config_db#(integer)::set(uvm_root::get(), "*", "count", count);
    end
    

endmodule 
