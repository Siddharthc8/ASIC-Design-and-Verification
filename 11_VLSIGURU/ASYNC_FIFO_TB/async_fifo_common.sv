`define DEPTH 16
`define WIDTH 16
`define ADDR_WIDTH 8
`define MAX_WR_DELAY 13
`define MAX_RD_DELAY 10


`define NEW_COMP \
function new(string name = "", uvm_component parent); \
    super.new(name, parent); \
endfunction


`define NEW_OBJ \
function new(string name = ""); \
    super.new(name); \
endfunction


class async_fifo_common;

static int num_matches;
static int num_mismatches;

endclass