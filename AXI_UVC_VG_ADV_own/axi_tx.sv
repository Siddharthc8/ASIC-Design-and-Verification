class axi_tx extends uvm_sequence_item;

`NEW_OBJ

// Request phase fields 

rand bit wr_rd;

rand bit[3:0]  tx_id;    // For resuability
rand bit[`ADDR_BUS_WIDTH-1:0] addr;       // Not set a awaddr becuase we want to reuse for read and write
rand bit[3:0]  burst_len; 
rand bit[2:0]  burst_size;
rand burst_type_t  burst_type;
rand bit[1:0]  lock;
rand bit[3:0]  cache;
rand bit[2:0]  prot;

// Data phase fields
rand bit[`DATA_BUS_WIDTH-1:0] dataQ[$];
rand bit[`STRB_WIDTH-1:0]  strbQ[$];
rand bit[1:0]  respQ[$];

// Transaction local signals
bit [`ADDR_BUS_WIDTH-1:0] wrap_lower_addr;
bit [`ADDR_BUS_WIDTH-1:0] wrap_upper_addr;

`uvm_object_utils_begin(axi_tx)

`uvm_field_int(wr_rd, UVM_ALL_ON);
`uvm_field_int(tx_id, UVM_ALL_ON);
`uvm_field_int(addr, UVM_ALL_ON);
`uvm_field_int(burst_len, UVM_ALL_ON);
`uvm_field_int(burst_size, UVM_ALL_ON);
`uvm_field_enum(burst_type_t, burst_type, UVM_ALL_ON);
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

constraint wrap_c {
    (burst_type == WRAP) -> (burst_len inside {1,3,7,15});
    (burst_type == WRAP) -> (addr % (2**burst_size) == 0);
}

constraint soft_c {
    // soft burst_type == INCR;
    soft burst_size <= 3;   // 4 bytes by default 
    soft addr % (2**burst_size) == 0;    // Aligned transfer
    // 2**burst_size <= `DATA_BUS_WIDTH/8;
    // foreach(strbQ[i]) {
    //     (burst_size == 0) -> ( $onehot(strbq[i]) );
    //     (burst_size == 1) -> ( strbQ[i] inside {8'b0000_0011,8'b0000_1100,8'b0011_0000,8'b1100_0000} );
    //     (burst_size == 2) -> ( strbQ[i] inside {8'b0000_1111,8'b1111_0000} );
    //     (burst_size == 3) -> ( strbQ[i] inside {8'b1111_1111} );
    // }
}

function void calculate_wrap_range();

    bit [31:0] tx_size;
    bit [31:0] offset;

    tx_size = (burst_len + 1) * (2**burst_size);
    offset = (addr % tx_size);

    wrap_lower_addr = addr - offset;
    wrap_upper_addr = wrap_lower_addr + tx_size - 1;

    `uvm_info("AXI_TX WRAP CALC", $sformatf(" addr = %h", addr), UVM_MEDIUM);
    `uvm_info("AXI_TX WRAP CALC", $sformatf(" wrap_lower_addr = %h ", wrap_lower_addr), UVM_MEDIUM);
    `uvm_info("AXI_TX WRAP CALC", $sformatf(" wrap_upper_addr = %h ", wrap_upper_addr), UVM_MEDIUM);

endfunction

function void check_wrap();
    if(addr >= wrap_upper_addr) begin
        addr = wrap_lower_addr;
    end
endfunction

function void post_randomize();
    if(wr_rd == 0) begin
        axi_common::total_beats += burst_len+1;
    end
endfunction

endclass //