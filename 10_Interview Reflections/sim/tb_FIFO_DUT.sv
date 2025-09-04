`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2025 09:43:54 PM
// Design Name: 
// Module Name: tb_FIFO_DUT
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
                          
`include "uvm_macros.svh"
import uvm_pkg::*;

 module tb_FIFO_DUT();

//////////////////////////////////////////////////////////////////////////////////
//                          CONFIG CLASS
//////////////////////////////////////////////////////////////////////////////////

class fifo_config extends uvm_object;
`uvm_object_utils(fifo_config)

    virtual fifo_if fifo_vif;
    
    function new(string path = "fifo_config");
        super.new(path);
    endfunction


endclass
    
//////////////////////////////////////////////////////////////////////////////////
//                          TRANSACTION CLASS
//////////////////////////////////////////////////////////////////////////////////

class fifo_transaction extends uvm_sequence_item;
`uvm_object_utils(fifo_transaction)

    rand logic wr_en, rd_en, rst_n;
    rand logic [ fifo_vif.FIFO_WIDTH-1:0] data_in;
    logic [fifo_vif.FIFO_WIDTH-1:0] data_out, data_out_ref;
    logic wr_ack, wr_ack_ref;
    logic full, empty, almost_full, almost_empty, overflow, underflow;
    logic full_ref, empty_ref, almost_full_ref, almost_empty_ref, underflow_ref, overflow_ref;
    
    function new(string path = "fifo_transaction");
        super.new(path);
    endfunction
    
    // To print all the signals
    function string convert2string();
        return $sformatf("%s wr_en = 0b%0b , rd_en = 0b%0b , rst_n = 0b%0b , data_in = 0b%0b , data_out = 0b%0b , full = 0b%0b , empty = 0b%0b , almostfull = 0b%0b , almostempty = 0b%0b , wr_ack = 0b%0b , overflow = 0b%0b , underflow = 0b%0b , full_ref = 0b%0b , empty_ref = 0b%0b , almostfull_ref = 0b%0b  , almostempty_ref = 0b%0b , wr_ack_ref = 0b%0b , overflow_ref = 0b%0b , underflow_ref = 0b%0b ", super.convert2string(),wr_en , rd_en , rst_n , data_in , data_out , full , empty , almost_full , almost_empty , wr_ack , overflow , underflow ,full_ref, empty_ref, almost_full_ref, almost_empty_ref, wr_ack_ref, overflow_ref, underflow_ref);
    endfunction
    
    // to print only the inputs/stimulus
    function string convert2string_stimulus();
        return $sformatf("wr_en = 0b%0b , rd_en = 0b%0b , rst_n = 0b%0b , data_in = 0b%0b ", wr_en , rd_en , rst_n , data_in);
    endfunction
    
//    function void pre_randomize();
//        // Example: Set rst_n to 1 to ensure reset is deasserted
//        rst_n = 1;
//        // Optionally disable randomization for specific fields
//        rst_n.rand_mode(0); // Disable randomization for rst_n
//        // Set a specific value for data_in for debugging
//        // data_in = 16'hA5A5; // Uncomment to set a fixed value
//        // data_in.rand_mode(0); // Disable randomization for data_in
//    endfunction
    
    // CONSTRAINTS
    
    constraint reset_c {
        rst_n dist{ 0:/2, 1:/98 };
    }
    
    constraint write_c {
        wr_en dist { 0:/30, 1:/70 };
    }
    
    constraint read_c {
        rd_en dist { 0:/30, 1:/70 };
    }
    
    constraint write_only { rst_n == 1; wr_en == 1; rd_en == 0; }
    
    constraint read_only { rst_n == 1; wr_en == 0; rd_en == 1; }
    
    
endclass

//////////////////////////////////////////////////////////////////////////////////
//                          SEQUENCES CLASS
//////////////////////////////////////////////////////////////////////////////////

class fifo_reset_seq extends uvm_sequence#(fifo_transaction);
`uvm_object_utils(fifo_reset_seq)
    
    function new(string path = "fifo_reset_seq");
    super.new(path);
    endfunction
    
    virtual task body();
        
        fifo_transaction fifo_tr;
        
        repeat(50) begin
            
            fifo_tr = fifo_transaction::type_id::create("fifo_tr");
            
            start_item(fifo_tr);
            
            fifo_tr.rst_n = 0;
            fifo_tr.data_in = 0;
            fifo_tr.wr_en = 0;
            fifo_tr.rd_en = 0;
            
            finish_item(fifo_tr);
        
        end
    
    endtask
    
endclass

class fifo_write_seq extends uvm_sequence#(fifo_transaction);
`uvm_object_utils(fifo_write_seq)
    
    function new(string path = "fifo_write_seq");
    super.new(path);
    endfunction
    
    virtual task body();
        
        fifo_transaction fifo_tr;
        
        repeat(500) begin
            
            fifo_tr = fifo_transaction::type_id::create("fifo_tr");
            
            start_item(fifo_tr);
            
            fifo_tr.constraint_mode(0);                   // Turn of all constraints
            fifo_tr.write_only.constraint_mode(1);             // Turn on only write constraint
            assert(fifo_tr.randomize()) else $display("Randomization failed");                           // Assert Randomization       
            
            finish_item(fifo_tr);
        
        end
    
    endtask
    
endclass


class fifo_read_seq extends uvm_sequence#(fifo_transaction);
`uvm_object_utils(fifo_read_seq)

    function new(string path = "fifo_read_seq");
        super.new(path);
    endfunction
    
    virtual task body();
        
        fifo_transaction fifo_tr;
        
        repeat(500) begin
            
            fifo_tr = fifo_transaction::type_id::create("fifo_tr");
            
            start_item(fifo_tr);
            
            fifo_tr.constraint_mode(0);              // Turn of all constraints           
            fifo_tr.read_only.constraint_mode(1);         // Turn on only write constraint
            fifo_tr.data_in.rand_mode(0);                     // Turn off data_in randomization
            assert(fifo_tr.randomize());                          // Assert Randomization     
            
            finish_item(fifo_tr);
            
        end
    
    endtask


endclass


class fifo_read_write_seq extends uvm_sequence#(fifo_transaction);
`uvm_object_utils(fifo_read_write_seq)

    function new(string path = "fifo_read_write_seq");
        super.new(path);
    endfunction
    
    virtual task body();
        
        fifo_transaction fifo_tr;
        
        repeat(500) begin
        
        fifo_tr = fifo_transaction::type_id::create("fifo_tr");
        
        start_item(fifo_tr);
        
        fifo_tr.constraint_mode(1);
        fifo_tr.data_in.rand_mode(1);
        fifo_tr.read_only.constraint_mode(0);
        fifo_tr.write_only.constraint_mode(0);
        assert(fifo_tr.randomize());
        
        finish_item(fifo_tr);
        
        end
        
    endtask
    
endclass

//////////////////////////////////////////////////////////////////////////////////
//                          SEQUENCER CLASS
//////////////////////////////////////////////////////////////////////////////////

class fifo_sequencer extends uvm_sequencer #(fifo_transaction);
        `uvm_component_utils(fifo_sequencer)

        function new(string name = "fifo_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction
endclass

//////////////////////////////////////////////////////////////////////////////////
//                         DRIVER CLASS
//////////////////////////////////////////////////////////////////////////////////

class fifo_driver extends uvm_driver#(fifo_transaction);
`uvm_component_utils(fifo_driver)
    
    virtual fifo_if fifo_vif;
    fifo_transaction fifo_tr_drv;
    
    function new(string path = "fifo_driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        fifo_tr_drv = fifo_transaction::type_id::create("fifo_tr_drv");              // My usual way
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "fifo_vif", fifo_vif)) begin
            `uvm_error("DRV", "Unable to access interface"); 
        end
        else
            `uvm_info("DRV", "Interface retrieved successfully", UVM_LOW);
    endfunction
    
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        
        forever begin
            
//            fifo_tr_drv = fifo_transaction::type_id::create("fifo_tr_drv");
            
            // Initialize all the input signal to zero to avoid x insitialization
            
            fifo_vif.rst_n   <= 0;            
            fifo_vif.data_in <= 0;
            fifo_vif.wr_en   <= 0;
            fifo_vif.rd_en   <= 0;
            
            // End of input intialization to zero
            
            seq_item_port.get_next_item(fifo_tr_drv);
            `uvm_info("DRV", $sformatf("Driving rst_n=%b, wr_en=%b, rd_en=%b, data_in=%h", fifo_vif.rst_n, fifo_vif.wr_en, fifo_vif.rd_en, fifo_vif.data_in), UVM_LOW);
            fifo_vif.rst_n <= fifo_tr_drv.rst_n;
            fifo_vif.wr_en <= fifo_tr_drv.wr_en;
            fifo_vif.rd_en <= fifo_tr_drv.rd_en;
            fifo_vif.data_in <= fifo_tr_drv.data_in;
            
            @(negedge fifo_vif.clk);
            
            fifo_tr_drv.data_out = fifo_vif.data_out;
            fifo_tr_drv.wr_ack = fifo_vif.wr_ack;
            fifo_tr_drv.full = fifo_vif.full;
            fifo_tr_drv.empty = fifo_vif.empty;
            fifo_tr_drv.almost_full = fifo_vif.almost_full;
            fifo_tr_drv.almost_empty = fifo_vif.almost_empty;
            fifo_tr_drv.overflow = fifo_vif.overflow;
            fifo_tr_drv.underflow = fifo_vif.underflow;
            // ref signals
            fifo_tr_drv.data_out_ref = fifo_vif.data_out_ref;
            fifo_tr_drv.wr_ack_ref = fifo_vif.wr_ack_ref;
            fifo_tr_drv.full_ref = fifo_vif.full_ref;
            fifo_tr_drv.empty_ref = fifo_vif.empty_ref;
            fifo_tr_drv.almost_full_ref = fifo_vif.almost_full_ref;
            fifo_tr_drv.almost_empty_ref = fifo_vif.almost_empty_ref;
            fifo_tr_drv.overflow_ref = fifo_vif.overflow_ref;
            fifo_tr_drv.underflow_ref = fifo_vif.underflow_ref;
            
            seq_item_port.item_done();
            
            `uvm_info("drv_run_phase", fifo_tr_drv.convert2string_stimulus(), UVM_HIGH);
        end
        
    endtask

endclass

//////////////////////////////////////////////////////////////////////////////////
//                          MONITOR CLASS
//////////////////////////////////////////////////////////////////////////////////

class fifo_monitor extends uvm_monitor;
`uvm_component_utils(fifo_monitor)

    fifo_transaction fifo_tr_mon;
    virtual fifo_if fifo_vif;
    uvm_analysis_port #(fifo_transaction) send;
    
    function new(string path = "fifo_monitor", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
//        fifo_tr_mon = fifo_transaction::type_id::create("fifo_tr_mon");                 // My usual way
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "fifo_vif", fifo_vif)) begin
            `uvm_error("MON", "Unable to access interface");
        end
        else
            `uvm_info("DRV", "Interface retrieved successfully", UVM_LOW);
            
    endfunction
    
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            
            fifo_tr_mon = fifo_transaction::type_id::create("fifo_tr_mon");
            
            @(negedge fifo_vif.clk);
            
            // Inputs
            fifo_tr_mon.rst_n = fifo_vif.rst_n;
            fifo_tr_mon.wr_en = fifo_vif.wr_en;
            fifo_tr_mon.rd_en = fifo_vif.rd_en;
            fifo_tr_mon.data_in = fifo_vif.data_in;
            
            // dut outputs
            fifo_tr_mon.data_out = fifo_vif.data_out;
            fifo_tr_mon.wr_ack = fifo_vif.wr_ack;
            fifo_tr_mon.full = fifo_vif.full;
            fifo_tr_mon.empty = fifo_vif.empty;
            fifo_tr_mon.almost_full = fifo_vif.almost_full;
            fifo_tr_mon.almost_empty = fifo_vif.almost_empty;
            fifo_tr_mon.overflow = fifo_vif.overflow;
            fifo_tr_mon.underflow = fifo_vif.underflow;
            
            // golden dut outputs
            fifo_tr_mon.data_out_ref = fifo_vif.data_out_ref;
            fifo_tr_mon.wr_ack_ref = fifo_vif.wr_ack_ref;
            fifo_tr_mon.full_ref = fifo_vif.full_ref;
            fifo_tr_mon.empty_ref = fifo_vif.empty_ref;
            fifo_tr_mon.almost_full_ref = fifo_vif.almost_full_ref;
            fifo_tr_mon.almost_empty_ref = fifo_vif.almost_empty_ref;
            fifo_tr_mon.overflow_ref = fifo_vif.overflow_ref;
            fifo_tr_mon.underflow_ref = fifo_vif.underflow_ref;
            
            send.write(fifo_tr_mon);
            
            `uvm_info("MON", fifo_tr_mon.convert2string(), UVM_HIGH);
        end
        
    endtask

endclass

//////////////////////////////////////////////////////////////////////////////////
//                          AGENT CLASS
//////////////////////////////////////////////////////////////////////////////////

class fifo_agent extends uvm_agent;
`uvm_component_utils(fifo_agent)
    
//    fifo_config cfg;
    fifo_sequencer sqr;
    fifo_driver drv;
    fifo_monitor mon;
    uvm_analysis_port#(fifo_transaction) agent_ap;
    
//    uvm_sequencer#(fifo_transaction) sqr;

    function new(string path = "fifo_agent", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
//        if(!uvm_config_db#(virtual fifo_if)::get(this,"", "cfg",cfg))
//            `uvm_fatal("Agent","No interface linked");            
//        cfg = fifo_config::type_id::create("cfg");
        sqr = fifo_sequencer::type_id::create("sqr", this);
        drv = fifo_driver::type_id::create("drv", this);
        mon = fifo_monitor::type_id::create("mon", this);
        agent_ap = new("agent_ap", this);
    endfunction
    
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);    
        
//        drv.fifo_vif = cfg.fifo_vif;
//        mon.fifo_vif = cfg.fifo_vif;
        drv.seq_item_port.connect(sqr.seq_item_export);
        mon.send.connect(agent_ap);
        
    endfunction
    
endclass

//////////////////////////////////////////////////////////////////////////////////
//                          SCOREBOARD CLASS
//////////////////////////////////////////////////////////////////////////////////

class fifo_scoreboard extends uvm_component;
`uvm_component_utils(fifo_scoreboard)
    
    fifo_transaction fifo_tr;
    uvm_analysis_export#(fifo_transaction) sco_export;
    uvm_tlm_analysis_fifo#(fifo_transaction) sco_fifo;
    
    int error_count = 0;
    int correct_count = 0;

    function new(string path = "fifo_scoreboard", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sco_export = new("sco_export", this);
        sco_fifo = new("sco_fifo", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sco_export.connect(sco_fifo.analysis_export);
    endfunction
    
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            
            sco_fifo.get(fifo_tr);
            
            if (fifo_tr.data_out_ref !== fifo_tr.data_out || fifo_tr.full_ref !== fifo_tr.full || fifo_tr.empty_ref !== fifo_tr.empty || fifo_tr.almost_full_ref !== fifo_tr.almost_full || fifo_tr.almost_empty_ref !== fifo_tr.almost_empty || fifo_tr.wr_ack_ref !== fifo_tr.wr_ack || fifo_tr.overflow_ref !== fifo_tr.overflow || fifo_tr.underflow_ref !== fifo_tr.underflow) begin
                `uvm_error("run_phase", $sformatf("Comparsion Failed , Transaction received by the DUT:%s" , fifo_tr.convert2string()));
                error_count++;
            end
            else begin
                `uvm_info("run_phase", $sformatf("Correct out: %s", fifo_tr.convert2string()), UVM_HIGH);
                correct_count++;
            end
            
        end
            
    endtask : run_phase
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase" , $sformatf("Total Successful transaction: %0d" , correct_count) , UVM_MEDIUM);
        `uvm_info("report_phase" , $sformatf("Total Failed transaction: %0d" , error_count) , UVM_MEDIUM);       
    endfunction
    
endclass

//////////////////////////////////////////////////////////////////////////////////
//                          COVERAGE CLASS
//////////////////////////////////////////////////////////////////////////////////

class fifo_coverage extends uvm_component;
`uvm_object_utils(fifo_coverage)
    
    fifo_transaction fifo_tr;
    uvm_analysis_export#(fifo_transaction) cov_export;
    uvm_tlm_analysis_fifo#(fifo_transaction) cov_fifo;
    
    covergroup cg;
    
    coverpoint fifo_tr.wr_en{
        bins wr_en_high = {1'b1};
        bins wr_en_low = {1'b0};
    }
    
    coverpoint fifo_tr.rd_en{
        bins rd_en_high = {1'b1};
        bins rd_en_low = {1'b0};
    }
    
    coverpoint fifo_tr.full{
        bins full_high = {1'b1};
        bins full_low = {1'b0};
    }
    
    coverpoint fifo_tr.empty{
        bins empty_high = {1'b1};
        bins empty_low = {1'b0};
    }
    
    coverpoint fifo_tr.almost_full{
        bins almost_full_high = {1'b1};
        bins almost_full_low = {1'b0};
    }
    
    coverpoint fifo_tr.almost_empty{
        bins almost_empty_high = {1'b1};
        bins almost_empty_low = {1'b0};
    }
    
    coverpoint fifo_tr.overflow{
        bins overflow_high = {1'b1};
        bins overflow_low = {1'b0};
    }
    
    coverpoint fifo_tr.underflow{
        bins underflow_high = {1'b1};
        bins underflow_low = {1'b0};
    }
    
    cross fifo_tr.wr_en, fifo_tr.full;
    cross fifo_tr.wr_en, fifo_tr.almost_full;
    cross fifo_tr.rd_en, fifo_tr.empty;
    cross fifo_tr.rd_en, fifo_tr.almost_empty;
    
    endgroup
    
    function new(string path = "fifo_coverage", uvm_component parent = null);
        super.new(path, parent);
        cg = new();
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
//        cg = new();                          // Cannot be isntantiated here 
        cov_export = new("cov_export", this);
        cov_fifo = new("cov_fifo", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cov_fifo.get(fifo_tr);
            cg.sample();
        end
    endtask
    
    
    

endclass


//////////////////////////////////////////////////////////////////////////////////
//                          ENVIRONMENT CLASS
//////////////////////////////////////////////////////////////////////////////////

class fifo_env extends uvm_env;
`uvm_component_utils(fifo_env)
    
    fifo_agent agent;
    fifo_coverage cov;
    fifo_scoreboard sco;
//    uvm_analysis_port#(fifo_transaction) env_ap;     // I believe this is not needed
    
    function new(string path = "fifo_env", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = fifo_agent::type_id::create("agent", this);
        cov = fifo_coverage::type_id::create("cov", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.agent_ap.connect(sco.sco_export);
        agent.agent_ap.connect(cov.cov_export);
    endfunction 
    

endclass

//////////////////////////////////////////////////////////////////////////////////
//                          TEST CLASS
//////////////////////////////////////////////////////////////////////////////////

class fifo_test extends uvm_component;
`uvm_component_utils(fifo_test)
    
    virtual fifo_if fifo_vif;
    fifo_config cfg;
    fifo_env env;
    
    fifo_reset_seq seq_rst;
    fifo_write_seq seq_write;
    fifo_read_seq seq_read;
    fifo_read_write_seq seq_wr_rd;
    
    
    function new(string path = "fifo_test", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        cfg = fifo_config::type_id::create("cfg", this);
        env = fifo_env::type_id::create("env", this);
        seq_rst = fifo_reset_seq::type_id::create("seq_rst", this);
        seq_write = fifo_write_seq::type_id::create("seq_write", this);
        seq_read = fifo_read_seq::type_id::create("seq_read", this);
        seq_wr_rd = fifo_read_write_seq::type_id::create("seq_wr_rd", this);
        
//        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "fifo_vif", cfg.fifo_vif))  // cfg.
//            `uvm_fatal("Test","Test no vif");
            
        uvm_config_db#(fifo_config)::set(this, "*", "cfg", cfg);
        
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        phase.raise_objection(this);
//------------------------------------------------------------------------------        
        `uvm_info("run_phase", "reset asserted", UVM_LOW)
            seq_rst.start(env.agent.sqr);
        `uvm_info("run_phase", "reset deasserted", UVM_LOW)
        #10;
//------------------------------------------------------------------------------
        `uvm_info("run_phase", "stimulus generation write started", UVM_LOW)
            seq_write.start(env.agent.sqr);
        `uvm_info("run_phase", "stimulus generation write ended", UVM_LOW)
//        #10;
//------------------------------------------------------------------------------
        `uvm_info("run_phase", "stimulus generation read started", UVM_LOW)
        seq_read.start(env.agent.sqr);
        `uvm_info("run_phase", "stimulus generation read ended", UVM_LOW)
//        #10;
//------------------------------------------------------------------------------
        `uvm_info("run_phase", "stimulus generation write_read started", UVM_LOW)
        seq_wr_rd.start(env.agent.sqr);
        `uvm_info("run_phase", "stimulus generation write_read ended", UVM_LOW)
//        #10;
//------------------------------------------------------------------------------
        `uvm_info("fifo_test", "Running FIFO Test", UVM_MEDIUM);
//------------------------------------------------------------------------------        
        phase.drop_objection(this);
    endtask
    
    
    
endclass

//////////////////////////////////////////////////////////////////////////////////
//                          TOP CLASS
//////////////////////////////////////////////////////////////////////////////////

    bit clk;
    
    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end
    
    fifo_if fifo_vif(clk);
    FIFO_DUT DUT(fifo_vif);
    fifo_reference_model DUT_gold(fifo_vif);
    bind FIFO_DUT fifo_assert fifo_assert_dut(fifo_vif);
    
    initial begin
        uvm_config_db#(virtual fifo_if)::set(null, "*", "fifo_vif", fifo_vif);
        run_test("fifo_test");
    end


endmodule
