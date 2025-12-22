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
    axi_tx mtxQ[$];
    axi_tx stxQ[$];

    `NEW_COMP

    function void build();
        imp_m = new("imp_m", this);
        imp_s = new("imp_s", this);
    endfunction

    function void write_m(axi_tx tx);
        mtxQ.push_back(tx);
    endfunction

    function void write_s(axi_tx tx);
        stxQ.push_back(tx);
    endfunction

    task run();

    forever begin
        wait(mtxQ.size() > 0 && mtxQ.size() > 0);
        m_tx = mtxQ.pop_front();
        s_tx = stxQ.pop_front();
        if(m_tx.compare(s_tx)) begin
            `uvm_info("TX Compare", "Compare passed", UVM_MEDIUM);
            axi_common::num_matches++;
        end
        else begin
            `uvm_error("TX Compare", "Compare failed");
            axi_common::num_mismatches++;
        end        
    end

    endtask


endclass