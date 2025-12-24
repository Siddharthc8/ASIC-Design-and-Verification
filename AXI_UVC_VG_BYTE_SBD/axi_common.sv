`define NEW_COMP \
function new(string name = "", uvm_component parent = null); \
    super.new(name, parent); \
endfunction

`define NEW_OBJ \
function new(string name = ""); \
    super.new(name); \
endfunction

uvm_factory factory = uvm_factory::get();   // This is global scope

typedef enum bit[1:0] { 
    FIXED, 
    INCR, 
    WRAP, 
    RSVD_TYPE 
} burst_type_t;

typedef enum bit[1:0] { 
    NORMAL, 
    EXCL, 
    LOCKED, 
    RSVD_LOCK 
} lock_t;

typedef enum bit[1:0] {
    OKAY   = 2'b00,
    EXOKAY = 2'b01,
    SLVERR = 2'b10,
    DECERR = 2'b11
} resp_type_e;



class axi_common;

static int num_matches;
static int num_mismatches;
static int total_tx_count = 50;
static int total_beats;
static burst_type_t burst_type = FIXED;
// static bit [3:0] burst_len = 4;

endclass //