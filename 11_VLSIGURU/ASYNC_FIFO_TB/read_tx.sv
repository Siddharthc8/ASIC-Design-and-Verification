class read_tx extends uvm_sequence_item;
// `uvm_object_utils(write_tx)

    // rand bit rd_en;                // we will always set it to 1 as it is from write tx
    bit [`WIDTH-1:0] data;   // Do not randomize read_tx, as data is inferred from the FIFO.
    rand int delay;
    bit empty;
  	bit error;

    `uvm_object_utils_begin(read_tx)
        // `uvm_field_int(wr_en, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end

    `NEW_OBJ
  	
  	constraint read_delay_c {
        soft delay == 0;
    }

endclass