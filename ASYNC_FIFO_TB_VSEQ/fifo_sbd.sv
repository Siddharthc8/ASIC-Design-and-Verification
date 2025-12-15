`uvm_analysis_imp_decl(_write)
`uvm_analysis_imp_decl(_read)
// 1.Defines a class uvm_analysis_imp_write 
// 2.Defines a method called write_write 


class fifo_sbd extends uvm_scoreboard;
`uvm_component_utils(fifo_sbd)

uvm_analysis_imp_write#(write_tx, fifo_sbd) imp_write;
uvm_analysis_imp_read#(read_tx, fifo_sbd) imp_read;

write_tx write_txQ[$];
read_tx read_txQ[$];
write_tx write_tx_i;
read_tx read_tx_i;

`NEW_COMP

function void build_phase(uvm_phase phase);
super.build_phase(phase);
imp_write = new("imp_write", this);
imp_read = new("imp_read", this); 
endfunction

function void write_write(write_tx tx);
  if(tx.full != 1) begin
  	$display("%0t : WRITING INTO QUEUE Storing %d into write_txQ", $time, tx.data);
    write_txQ.push_back(tx);
  end
  
endfunction

function void write_read(read_tx tx);
  
  if(tx.empty != 1) begin
  	$display("%0t : STORING QUEUE Storing %d into read_txQ", $time, tx.data);
    read_txQ.push_back(tx);
  end
  
endfunction


task run_phase(uvm_phase phase);
forever begin
    wait ( write_txQ.size() > 0 && read_txQ.size() > 0 );
    write_tx_i = write_txQ.pop_front();
    read_tx_i = read_txQ.pop_front();

    if(write_tx_i.data == read_tx_i.data) begin
        async_fifo_common::num_matches++;
    end
    else begin
        async_fifo_common::num_mismatches++;
        `uvm_info(get_type_name(), "----------------->There is a mismatch", UVM_MEDIUM);
    end

end
endtask

endclass