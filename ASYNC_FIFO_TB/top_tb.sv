`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "async_fifo_common.sv"
`include "async_fifo.sv"
`include "async_fifo_intf.sv"
`include "write_agent.sv"
`include "read_agent.sv"
`include "async_fifo_env.sv"
`include "test_lib.sv"


module top;

parameter DEPTH = 16, WIDTH = 8;
parameter NUM_TXS = 100;
parameter MAX_WR_DELAY = 13;
parameter MAX_RD_DELAY = 10;

reg wr_clk_i, rd_clk_i, rst_i;

// Interface instantiation
async_fifo_intf pif(rst_i, wr_clk_i, rd_clk_i);

// DUT instantiation
async_fifo dut(
    .wr_clk_i (wr_clk_i),   // These three are local signals generated from TB_TOP
    .rd_clk_i (rd_clk_i), 
    .rst_i   (rst_i),

    .wr_en_i. (pif.wr_en_i), 
    .wdata_i. (pif.wdata_i), 
    .full_o.  (pif.full_o),

    .rd_en_i. (pif.rd_en_i), 
    .rdata_o. (pif.rdata_o), 
    .empty_o. (pif.empty_o),

    .error_o. (pif.error_o)
);

// Write domain clock
initial begin
    wr_clk_i = 0;
    forever #5 wr_clk_i = ~wr_clk_i;
end

// Read domain clock
initial begin
    rd_clk_i = 0;
    forever #7 rd_clk_i = ~rd_clk_i;
end


initial begin
    run_test("async_fifo_base_test");
end


initial begin
    reset_dut();
end

task reset_dut();
    rst_i = 1;
    wr_en_i = 0;
    rd_en_i = 0;
    wdata_i = 0;
    #20;
    rst_i = 0;
endtask
    


endmodule