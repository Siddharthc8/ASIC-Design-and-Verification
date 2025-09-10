interface ahb_intf(input logic clk, rst);
    
    logic [31:0] addr;
    logic [31:0] data;
    logic wr_rd;

endinterface
