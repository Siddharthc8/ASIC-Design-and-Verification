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