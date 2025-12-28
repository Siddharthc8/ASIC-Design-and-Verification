class axi_sbd extends uvm_subscriber#(axi_tx);      // Changed to subscriber
`uvm_component_utils(axi_sbd)

    axi_tx m_tx;
    axi_tx s_tx;
    axi_tx tx;
    byte mem[*];
    bit [`DATA_BUS_WIDTH-1:0] mem_data;
    int all_pass;
    int lane;
    int lane_offset;

    `NEW_COMP

    function void write(axi_tx t);

        tx = new t;
        

        if(tx.wr_rd == 1) begin                         // Only writing
            foreach(tx.dataQ[i]) begin
                // for(int j = 0; j < 2**tx.burst_size; j++) begin
                //     if(tx.strbQ[i][j])
                //         mem[tx.addr + j]    =   tx.dataQ[i][j*8 +: 8];
                //     else
                //         mem[tx.addr + j] = '0;
                // end
                
                // foreach(tx.strbQ[i][j]) begin
                //     if(tx.strbQ[i][j]) begin
                //         mem[tx.addr] = tx.dataQ[i][j*8 +: 8];
                //         tx.addr ++;
                //     end
                // end
                `uvm_info(get_type_name(), $sformatf(" %d Writing at addr = %h, data = %h",i, tx.addr, tx.dataQ[i]), UVM_MEDIUM);
                lane_offset = tx.addr % `STRB_WIDTH;
                for (int j = 0; j < 2**tx.burst_size; j++) begin
                        lane = lane_offset + j;
                        if (tx.strbQ[i][lane]) begin
                            mem[tx.addr + j] = tx.dataQ[i][lane*8 +: 8];
                        end
                    end
                tx.addr += 2**tx.burst_size;
                tx.check_wrap(); 
            end

        end
        else begin                                      // Comparing only during read
            foreach(tx.dataQ[i]) begin
                
                lane_offset = tx.addr % `STRB_WIDTH;
                mem_data = '0;
                for(int k = 0; k < 2**tx.burst_size; k++) begin
                    lane = lane_offset + k;
                    mem_data[lane*8 +: 8] = mem[tx.addr + k];
                end

                if( mem_data != tx.dataQ[i]) begin
                    `uvm_error("TX COMPARE", $sformatf("Read data DOES NOT matches with write data, ADDR = %h , MEM_data = %h, Read_data = %h", tx.addr, mem_data, tx.dataQ[i]));
                    axi_common::num_mismatches++;
                end
            
                if(all_pass) begin
                    `uvm_info("TX COMPARE", $sformatf("Read data matches with write data, ADDR = %h , MEM_data = %h, Read_data = %h", tx.addr, mem_data, tx.dataQ[i]), UVM_MEDIUM);
                    axi_common::num_matches++;
                end

                // all_pass = 1;
                // for(int j = 0; j < 2**tx.burst_size; j++) begin                  
                //     if( mem[tx.addr+j] != tx.dataQ[i][j*8+:8]) begin
                //         `uvm_error("TX COMPARE", $sformatf("Read data DOES NOT matches with write data, ADDR = %h , MEM_data = %h, Read_data = %h", tx.addr, mem_data, tx.dataQ[i]));
                //         axi_common::num_mismatches++;
                //         all_pass = 0;
                //     end
                // end
                // if(all_pass) begin
                //     `uvm_info("TX COMPARE", $sformatf("Read data matches with write data, ADDR = %h , MEM_data = %h, Read_data = %h", tx.addr, mem_data, tx.dataQ[i]), UVM_MEDIUM);
                //     axi_common::num_matches++;
                // end

                tx.addr += 2**tx.burst_size;
                tx.check_wrap();
                    
            end
        end

    endfunction

    

    // Run task not required as the data is being compared in write_m



endclass //