class read_tx extends uvm_sequence_item;
// `uvm_object_utils(write_tx)

    // rand bit wr_en;                // we will always set it to 1 as it is from write tx
    rand bit [`WIDTH-1:0] data; // Don't have to name it write_data as it is inferred as it is in write_tx

    `uvm_object_utils_begin(read_tx)
        // `uvm_field_int(wr_en, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end

    `NEW_OBJ

    task body();


    endtask
    

endclass