class axi_base_seq extends uvm_sequence#(axi_tx);
`uvm_object_utils(axi_base_seq)

    uvm_phase phase;
    axi_tx txQ[$];
    axi_tx tx;

    `NEW_OBJ

    task pre_body();
        phase = get_starting_phase();
      if(phase != null) begin
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 100);
      end
    endtask

    task post_body();
        if(phase != null)
            phase.drop_objection(this);
    endtask


endclass


class axi_n_wr_n_rd_seq extends axi_base_seq;
`uvm_object_utils(axi_n_wr_n_rd_seq)

    int count;

    `NEW_OBJ
    
    task body();
        uvm_config_db#(int)::get(null, "", "COUNT", count);
        // Write txs
        repeat(count) begin
            // `uvm_do_with(req, {req.wr_rd == 1; req.burst_type == axi_common::burst_type;})
            `uvm_do_with(req, {req.wr_rd == 1;})
            tx = new req;
            txQ.push_back(tx);
        end

        // Read txs just copying from the write to keep them alike
        repeat(count) begin
            if(txQ.size() > 0) begin
                tx = txQ.pop_front();
                `uvm_do_with(req, {
                        req.wr_rd == 0;                      // 0 = READ
                        req.addr == tx.addr;                 // Same address
                        req.burst_len == tx.burst_len;       // Same burst length
                        req.burst_size == tx.burst_size;     // Same burst size
                        req.burst_type == tx.burst_type;     // Same burst type
                })
            end
        end

    endtask

endclass ///