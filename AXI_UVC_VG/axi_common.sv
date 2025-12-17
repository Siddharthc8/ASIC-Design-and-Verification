`define NEW_COMP \
function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
endfunction

`define NEW_OBJ \
function new(string name = "");
    super.new(name);
endfunction

uvm_factory factory = uvm_factory::get();   // This is global scope