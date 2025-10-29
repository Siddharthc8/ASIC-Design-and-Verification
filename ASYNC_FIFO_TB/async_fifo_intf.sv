interface async_fifo_intf(
    input bit wr_clk_i, rd_clk_i, rst_i
);

bit wr_en_i, rd_en_i;
bit [`WIDTH-1:0] wdata_i;
bit [`WIDTH-1:0] rdata_o;
bit error_o;
bit full_o, empty_o;
endinterface