`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2025 10:11:40 AM
// Design Name: 
// Module Name: tb_VLSI_GURU_APB_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`include"uvm_macros.svh"
import uvm_pkg::*;

module tb_VLSI_GURU_APB_TB();

`define NEW_OBJ \
function new(input string name = "");\
    super.new(name);\
endfunction

`define NEW_COMP \
function new(input string name = "", input uvm_component parent = null);\
    super.new(name, parent);\
endfunction



class apb_tx extends uvm_sequence_item;

    `NEW_OBJ
    
    rand bit wr_rd;
    rand int addr;
    
//    constraint cons{ 
//                     addr inside {[0:20]};
//                   }
    

endclass

 
class apb_base_seq extends uvm_sequence#(apb_tx);      // ONLY contains pre and post body to maintain the phase raise nd drop and drain time
`uvm_object_utils(apb_base_seq) 

    `NEW_OBJ
    
    uvm_phase phase;
    
    task pre_body();
        phase = get_starting_phase();               // Built in function to get the starting phase
        if(phase != null) begin
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 200);
        end
    endtask
    
    task post_body();
        if(phase != null) begin
            phase.drop_objection(this);
        end
    endtask
    
endclass

// Single read and write
class apb_wr_rd_seq extends apb_base_seq#(apb_tx);
`uvm_object_utils(apb_wr_rd_seq)
    
    apb_tx tx;
    
    `NEW_OBJ
    
    task body;
        `uvm_do_with(req, {req.wr_rd == 1;});
        tx = new req;                       // creating a copy of this req object to tx
        `uvm_do_with( req, { req.wr_rd == 0; req.addr == tx.addr; } );
    endtask
        

endclass


// Multiple stimuli write 10 stim and read from same addr
class apb_n_wr_n_rd_seq extends apb_base_seq#(apb_tx);
`uvm_object_utils(apb_n_wr_n_rd_seq)
    
    apb_tx tx, txQ[$];
    
    `NEW_OBJ
    
    task body;
        uvm_resource_db#(int)::get_by_name("GLOBAL","count",10, this);
        repeat(count) begin
            `uvm_do_with(req, {req.wr_rd == 1;});
            tx = new req;                       // creating a copy of this req object to tx
            txQ.push_back(tx);     // Push the entore item
            
        end
        repeat(count) begin
            tx = txQ.pop_front();    // Pop the entire item 
            `uvm_do_with( req, { req.wr_rd == 0; req.addr == tx.addr; } ); // Just match with the sub field
        end
    endtask
        
endclass


class apb_n_wr_rd_seq extends apb_base_seq#(apb_tx);
`uvm_object_utils(apb_n_wr_rd_seq)
    
    int tx;
    abb_wr_rd_seq seq;
    
    `NEW_OBJ
    
    task body;
        uvm_resource_db#(int)::get_by_name("GLOBAL","count",10, this);
        repeat(count) begin
            `uvm_do(seq);
        end
    endtask
        
endclass


class apb_driver extends uvm_driver#(apb_tx);
`uvm_component_utils(apb_driver)
    
    apb_tx tx;
    virtual apb_interface vif;
    
    `NEW_COMP
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tx = apb_tx::type_id::create("tx");
        if(!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif))
            `uvm_error("DRV", "Unable to get the interface");
            
    endfunction 

endclass


class apb_agent extends apb_agent;
`uvm_component_utils(apb_agent)

    `NEW_COMP

endclass

class apb_env extends uvm_env;
`uvm_component_utils(apb_env)

    `NEW_COMP

endclass

class apb_base_test extends uvm_test;
`uvm_component_utils(apb_base_test)

    apb_env env;
    
    `NEW_COMP
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = apb_env::type_id::create("env", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
    
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

endclass

class apb_wr_rd_test extends apb_base_test;
`uvm_component_utils(apb_wr_rd_test)
    
    apb_wr_rd_seq seq;
    
    `NEW_COMP
    
    function void build_phase(uvm_phase phase); // Build phase is required to se the default sequence for the test run
        super.build_phase(phase);
        
    endfunction
    
    task run_phase(uvm_phase phase);
    super.run_phase(phase);
        seq = apb_wr_rd_seq::type_id::create("seq", this);
        seq.start(env.agent.sqr);
    endtask

endclass


class apb_n_wr_n_rd_test extends apb_base_test;
`uvm_component_utils(apb_n_wr_n_rd_test)
    
    apb_wr_rd_seq seq;
    
    `NEW_COMP
    
    function void build_phase(uvm_phase phase); // Required to just for inheriting the constructor of build_phase find out why
        super.build_phase(phase);
        // Setting a default sequence using uvm_object_wrapper set teh scope as it is and the seq with get_type() function
        uvm_config_db#(uvm_object_wrapper)::set(this, "env.agent.sqr.run_phase", "default_sequence", apb_n_wr_rd_seq::get_type());
        // When we set default sequence it becomes the starting_phase in the seq pre body function anf the raise and drop on=bjection is handled by sequence base class
        // else the usual way in the test
    endfunction
    
    task run_phase(uvm_phase phase);
    super.run_phase(phase);
        uvm_resource_db#(int)::set("GLOBAL","count",5, this);  // This has to be done before the seq creation ie the next line command
        seq = apb_wr_rd_seq::type_id::create("seq", this);
        seq.start(env.agent.sqr);
    endtask

endclass

class apb_n_wr_n_rd_build_test extends apb_base_test;
`uvm_component_utils(apb_n_wr_n_rd_build_test)
    
    apb_n_wr_rd_seq seq;
    
    `NEW_COMP
    
    function void build_phase(uvm_phase phase); // Required to just for inheriting the constructor of build_phase find out why
        super.build_phase(phase);
        // Setting a default sequence using uvm_object_wrapper set teh scope as it is and the seq with get_type() function
        uvm_config_db#(uvm_object_wrapper)::set(this, "env.agent.sqr.run_phase", "default_sequence", apb_n_wr_rd_seq::get_type());
        // When we set default sequence it becomes the starting_phase in the seq pre body function anf the raise and drop on=bjection is handled by sequence base class
        // else the usual way in the test
    endfunction
    
    task run_phase(uvm_phase phase);
    super.run_phase(phase);
        uvm_resource_db#(int)::set("GLOBAL","count",5, this);  // This has to be done before the seq creation ie the next line command
        seq = apb_wr_rd_seq::type_id::create("seq", this);
        seq.start(env.agent.sqr);
    endtask

endclass

//////////////////////   MAIN MODULE   //////////////////////////

    initial begin
        run_test("apb_n_wr_rd_test");
    end
    
    initial begin
        $dumpfile("dumpfile.vcd");
        $dumpvars();
    end

endmodule