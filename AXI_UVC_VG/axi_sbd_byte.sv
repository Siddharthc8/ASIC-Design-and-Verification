// Decalrations for analysis ports
`uvm_analysis_imp_decl(_m)
`uvm_analysis_imp_decl(_s)
// Creates user-defined TLM classes and then create write functions with _m and _s

class axi_sbd extends uvm_scoreboard;
`uvm_component_utils(axi_sbd)

    uvm_analysis_imp_m #(axi_tx, axi_sbd) imp_m;
    uvm_analysis_imp_s #(axi_tx, axi_sbd) imp_s;

    axi_tx m_tx;
    axi_tx s_tx;

    byte mem[*];

    `NEW_COMP

    function void build();
        imp_m = new("imp_m", this);
        imp_s = new("imp_s", this);
    endfunction

    function void write_m(axi_tx tx);

        if(tx.wr_rd == 1) begin                         // Only writing
            foreach(tx.dataQ[i]) begin
                    mem[tx.addr] = tx.dataQ[i][7:0];
                    mem[tx.addr+1] = tx.dataQ[i][15:8];
                    mem[tx.addr+2] = tx.dataQ[i][23:16];
                    mem[tx.addr+3] = tx.dataQ[i][31:24];
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
                    `uvm_error("TX COMPARE", $sformatf("Read data matches with write data"));
                    axi_common::num_mismatches++;
                end

                tx.addr += 4;
                    
            end
        end

    endfunction

    function void write_s(axi_tx tx);

    endfunction

    // Run task not required as the data is being compared in write_m

    endtask


endclass