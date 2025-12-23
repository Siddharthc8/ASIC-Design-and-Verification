class axi_tx extends uvm_sequence_item;

`NEW_OBJ

// Request phase fields 

rand bit wr_rd;

rand bit[3:0]  tx_id;    // For resuability
rand bit[31:0] addr;       // Not set a awaddr becuase we want to reuse for read and write
rand bit[3:0]  burst_len; 
rand bit[2:0]  burst_size;
rand bit[1:0]  burst_type;
rand bit[1:0]  lock;
rand bit[3:0]  cache;
rand bit[2:0]  prot;

// Data phase fields
rand bit[31:0] dataQ[$];
rand bit[3:0]  strbQ[$];
rand bit[1:0]  respQ[$];


`uvm_object_utils_begin(axi_tx)

`uvm_field_int(wr_rd, UVM_ALL_ON);
`uvm_field_int(tx_id, UVM_ALL_ON);
`uvm_field_int(addr, UVM_ALL_ON);
`uvm_field_int(burst_len, UVM_ALL_ON);
`uvm_field_int(burst_size, UVM_ALL_ON);
`uvm_field_int(burst_type, UVM_ALL_ON);
`uvm_field_int(lock, UVM_ALL_ON);
`uvm_field_int(cache, UVM_ALL_ON);
`uvm_field_int(prot, UVM_ALL_ON);
`uvm_field_int(lock, UVM_ALL_ON);
`uvm_field_queue_int(dataQ, UVM_ALL_ON);
`uvm_field_queue_int(strbQ, UVM_ALL_ON);
`uvm_field_queue_int(respQ, UVM_ALL_ON);

`uvm_object_utils_end


// Constraints
constraint rsvd_c {
    burst_type != 2'b11;
    lock != 2'b11;
}

constraint dataQ_c {
    dataQ.size() == burst_len + 1;
    strbQ.size() == burst_len + 1;
    foreach(strbQ[i]) {
        soft strbQ[i] == 4'hF;
    }
    // RespQ will be updated by the driver
}

constraint soft_c {
    soft burst_type == INCR;
    soft burst_size == 2;   // 4 bytes by default 
    soft addr % (2**burst_size) == 0;
}

function void post_randomize();
    if(wr_rd == 0) begin
        axi_common::total_beats += burst_len+1;
    end
endfunction

endclass