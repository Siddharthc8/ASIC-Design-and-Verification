class axi_tx extends uvm_sequence_item;

`NEW_OBJ

rand bit[31:0] addr;

`uvm_object_utils_begin(axi_tx)

`uvm_field_int(addr, UVM_ALL_ON);

`uvm_object_utils_end

endclass