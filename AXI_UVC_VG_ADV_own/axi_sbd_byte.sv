class axi_sbd extends uvm_subscriber#(axi_tx);      // Changed to subscriber
`uvm_component_utils(axi_sbd)

    axi_tx m_tx;
    axi_tx s_tx;
    axi_tx tx;
    byte mem[*];
    bit [`DATA_BUS_WIDTH-1:0] mem_data;
    int lane;
    int lane_offset;
    bit [`ADDR_BUS_WIDTH-1:0] addr;

    `NEW_COMP

    function void write(axi_tx t);

        tx = new t;
        addr = tx.addr;

        if(tx.wr_rd == 1) begin                         // Only writing
            foreach(tx.dataQ[i]) begin
                
                `uvm_info(get_type_name(), $sformatf(" %d Writing at addr = %h, data = %h",i, addr, tx.dataQ[i]), UVM_MEDIUM);
                lane_offset = addr % (`DATA_BUS_WIDTH/8);
                for (int j = 0; j < 2**tx.burst_size; j++) begin
                    lane = lane_offset + j;
                    if (tx.strbQ[i][lane]) begin
                        mem[addr + j] = tx.dataQ[i][lane*8 +: 8];
                    end
                end
                addr += 2**tx.burst_size;
                if(tx.burst_type == WRAP) begin
                    if(addr > tx.wrap_upper_addr) begin
                        addr = tx.wrap_lower_addr;
                    end
                end
            end

        end
        else begin                                      // Comparing only during read

            addr = tx.addr;

            foreach(tx.dataQ[i]) begin
                
                lane_offset = addr % (`DATA_BUS_WIDTH/8);
                mem_data = '0;
                for(int k = 0; k < 2**tx.burst_size; k++) begin
                    lane = lane_offset + k;
                    mem_data[lane*8 +: 8] = mem[addr + k];
                end

                // `uvm_info(get_type_name(), $sformatf("Read Beat %d: addr=%h, expected=%h, read=%h, match=%b", i, addr, mem_data, tx.dataQ[i], (mem_data == tx.dataQ[i])), UVM_MEDIUM);

                if( mem_data == tx.dataQ[i]) begin
                    `uvm_info("TX COMPARE", $sformatf("Read Beat %0d: addr=%h, expected=%h, read=%h, match=%b", i, addr, mem_data, tx.dataQ[i], 1'b1), UVM_MEDIUM);
                    // `uvm_info("TX COMPARE", $sformatf(" Read data MATCHES at ADDR = %h, data = %h", addr, mem_data), UVM_MEDIUM);
                    axi_common::num_matches++;
                end
            
                else begin
                    `uvm_error("TX COMPARE", $sformatf("Read Beat %0d: addr=%h, expected=%h, read=%h, match=%b", i, addr, mem_data, tx.dataQ[i], 1'b0));
                    axi_common::num_mismatches++;
                end

                addr += 2**tx.burst_size;
                if(tx.burst_type == WRAP) begin
                    if(addr > tx.wrap_upper_addr) begin
                        addr = tx.wrap_lower_addr;
                    end
                end
                    
            end
        end

    endfunction

    

    // Run task not required as the data is being compared in write_m



endclass //