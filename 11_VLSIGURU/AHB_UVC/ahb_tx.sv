class ahb_tx extends uvm_sequence_item;

    function new(string name = "ahb_tx");
        super.new(name);
    endfunction

    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit wr_rd;

    `uvm_object_utils_begin(ahb_tx)
        `uvm_field_int(addr, UVM_ALL_ON | UVM_NO_PACK)
        `uvm_field_int(data, UVM_ALL_ON | UVM_NO_PACK)
        `uvm_field_int(wr_rd, UVM_ALL_ON | UVM_NO_PACK)
    `uvm_object_utils_end
    

endclass
