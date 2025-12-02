module tb_config_db_in_inheritance();

/* WHOLE IDEA of the problem
    // BASE -> CHILD1 -> CHILD2
    // When we config_db in CHILD1 and CHILD2 then CHILD1 config_db is esecuted eventhough we expect CHILD2 config db
*/ 

//                  BASE TEST
class async_fifo_base_test extends uvm_test;
`uvm_component_utils(async_fifo_base_test)

async_fifo_env env;

`NEW_COMP

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
    env = async_fifo_env::type_id::create("env", this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
endfunction

endclass


//              CHILD1 OF BASE TEST
class fifo_wr_rd_test extends async_fifo_base_test;
`uvm_component_utils(fifo_wr_rd_test)

    `NEW_COMP


    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      
      uvm_config_db#(int)::set(null, "*", "WRITE_COUNT", `DEPTH);    // This takes precendence over the CHILD2 class
      
      uvm_config_db#(int)::set(null, "*", "READ_COUNT", `DEPTH);     // This takes precendence over the CHILD2 class
      
      $display("Value of wr and rd count %d, %d", `DEPTH, `DEPTH);
      
      `uvm_info(get_type_name(), $sformatf("Scope %s", get_full_name()), UVM_MEDIUM);
      
    endfunction

    task run_phase(uvm_phase phase);
        write_seq write_seq_i;
        read_seq read_seq_i;
        write_seq_i = write_seq::type_id::create("write_seq_i");
        read_seq_i = read_seq::type_id::create("read_seq_i");

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
            write_seq_i.start(env.write_agent_i.sqr);
            read_seq_i.start(env.read_agent_i.sqr);
        phase.drop_objection(this);
    endtask

endclass


//          CHILD2 CLASS extends from CHILD1
class fifo_write_error_test extends fifo_wr_rd_test;
`uvm_component_utils(fifo_write_error_test)

    `NEW_COMP
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      
      uvm_config_db#(int)::set(this, "*", "WRITE_COUNT", `DEPTH+1);    

      uvm_config_db#(int)::set(this, "*", "READ_COUNT", 0);        
      
      $display("Value of wr and rd count %d, %d", `DEPTH+1, 0);  
      
      `uvm_info(get_type_name(), $sformatf("Scope %s", get_full_name()), UVM_MEDIUM);
      
    endfunction

    // No run_phase we shall extend it from wr_rd test
    // To turn off the write/read seq we can set their respective count value to 0 in config_db

endclass


endmodule