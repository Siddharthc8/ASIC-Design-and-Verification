class axi_sbd extends uvm_subscriber#(axi_tx);      // Changed to subscriber
`uvm_component_utils(axi_sbd)

    axi_tx m_tx;
    axi_tx s_tx;
    axi_tx tx;
    byte mem[*];

    `NEW_COMP

    function void write(axi_tx t);

        tx = new t;

        if(tx.wr_rd == 1) begin                         // Only writing
            foreach(tx.dataQ[i]) begin
                    mem[tx.addr]     =   tx.dataQ[i][7:0];
                    mem[tx.addr+1]   =   tx.dataQ[i][15:8];
                    mem[tx.addr+2]   =   tx.dataQ[i][23:16];
                    mem[tx.addr+3]   =   tx.dataQ[i][31:24];

                    tx.addr += 4;
            end
        end
        else begin                                      // Comparing only during read
            foreach(tx.dataQ[i]) begin                  
                if( mem[tx.addr] == tx.dataQ[i][7:0] && mem[tx.addr+1] == tx.dataQ[i][15:8] && mem[tx.addr+2] == tx.dataQ[i][23:16] && mem[tx.addr+3] == tx.dataQ[i][31:24]) begin
                    `uvm_info("TX COMPARE", $sformatf("Read data matches with write data"), UVM_MEDIUM);
                    axi_common::num_matches++;
                end
                else begin
                `uvm_error("TX COMPARE", $sformatf("Read data DOES NOT matches with write data, MEM_data = %h, Read_data = %h", {mem[tx.addr+3], mem[tx.addr+2], mem[tx.addr+1], mem[tx.addr]}, tx.dataQ[i]));
                    axi_common::num_mismatches++;
                end

                tx.addr += 4;
                    
            end
        end

    endfunction


    // Run task not required as the data is being compared in write_m



endclass //