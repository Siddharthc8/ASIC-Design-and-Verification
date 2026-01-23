`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

// I2C Transaction Class
class i2c_transaction extends uvm_sequence_item;
    rand bit [6:0] address;      // 7-bit I2C address
    rand bit rw;                 // Read (1) or Write (0)
    rand bit [7:0] data [];      // Data bytes
    rand bit ack;                // Acknowledgment (0 = ACK, 1 = NACK)

    `uvm_object_utils_begin(i2c_transaction)
        `uvm_field_int(address, UVM_ALL_ON)
        `uvm_field_int(rw, UVM_ALL_ON)
        `uvm_field_array_int(data, UVM_ALL_ON)
        `uvm_field_int(ack, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "i2c_transaction");
        super.new(name);
    endfunction

    constraint addr_c { address inside {[0:127]}; }
    constraint data_size_c { data.size() inside {[1:4]}; }
endclass

// I2C Interface
interface i2c_if;
    logic scl, sda; // Bidirectional signals
    logic scl_out, sda_out; // Driver outputs
    logic scl_en, sda_en; // Enable signals for tri-state

    // Pull-up resistors (simplified)
    assign scl = scl_en ? scl_out : 1'bz;
    assign sda = sda_en ? sda_out : 1'bz;

    clocking cb @(posedge scl);
        input sda;
    endclocking

    // Checker 1: Start Condition
    property start_condition;
        @(posedge sda or negedge sda) disable iff (!scl)
        (sda == 1) ##1 (sda == 0 && scl == 1);
    endproperty
    assert_start: assert property(start_condition)
        else `uvm_error("I2C_START_ERR", "Start condition failed: SDA did not transition from high to low while SCL high");

    // Checker 2: Acknowledgment
    logic [3:0] bit_count;
    initial bit_count = 0;

    always @(posedge scl) begin
        bit_count <= (bit_count == 9) ? 0 : bit_count + 1;
    end

    property ack_condition;
        @(posedge scl) disable iff (bit_count != 9)
        (bit_count == 9) |-> (sda == 0);
    endproperty
    assert_ack: assert property(ack_condition)
        else `uvm_error("I2C_ACK_ERR", "ACK failed: SDA not low on 9th SCL pulse");
endinterface

// I2C Driver
class i2c_driver extends uvm_driver #(i2c_transaction);
    `uvm_component_utils(i2c_driver)
    virtual i2c_if vif;
    uvm_analysis_port #(i2c_transaction) drv_analysis_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        drv_analysis_port = new("drv_analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual i2c_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRV_NO_VIF", "Virtual interface not found")
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        vif.scl_en = 1;
        vif.sda_en = 1;
        vif.scl_out = 1;
        vif.sda_out = 1;
        forever begin
            i2c_transaction txn;
            seq_item_port.get_next_item(txn);
            drive_transaction(txn);
            drv_analysis_port.write(txn);
            seq_item_port.item_done();
        end
    endtask

    task drive_transaction(i2c_transaction txn);
        // Start condition
        @(posedge vif.scl_out);
        vif.sda_out = 0;
        @(negedge vif.scl_out);

        // Drive address and R/W bit
        for (int i = 7; i >= 0; i--) begin
            vif.sda_out = (i == 0) ? txn.rw : txn.address[i-1];
            @(negedge vif.scl_out);
            @(posedge vif.scl_out);
        end

        // ACK phase (release SDA)
        vif.sda_en = 0;
        @(negedge vif.scl_out);
        @(posedge vif.scl_out);
        txn.ack = vif.sda;
        vif.sda_en = 1;

        // Drive data bytes
        foreach (txn.data[i]) begin
            for (int j = 7; j >= 0; j--) begin
                vif.sda_out = txn.data[i][j];
                @(negedge vif.scl_out);
                @(posedge vif.scl_out);
            end
            vif.sda_en = 0;
            @(negedge vif.scl_out);
            @(posedge vif.scl_out);
            txn.ack = vif.sda;
            vif.sda_en = 1;
        end

        // Stop condition
        vif.sda_out = 0;
        @(posedge vif.scl_out);
        vif.sda_out = 1;
        @(negedge vif.scl_out);

        `uvm_info("DRV_TXN", $sformatf("Driven txn: addr=0x%0h, rw=%0b, data=%p, ack=%0b", 
                                      txn.address, txn.rw, txn.data, txn.ack), UVM_MEDIUM)
    endtask
endclass

// I2C Monitor
class i2c_monitor extends uvm_monitor;
    `uvm_component_utils(i2c_monitor)
    virtual i2c_if vif;
    uvm_analysis_port #(i2c_transaction) mon_analysis_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        mon_analysis_port = new("mon_analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual i2c_if)::get(this, "", "vif", vif))
            `uvm_fatal("MON_NO_VIF", "Virtual interface not found")
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            i2c_transaction txn;
            @(vif.cb);
            collect_transaction(txn);
        end
    endtask

    task collect_transaction(output i2c_transaction txn);
        bit [7:0] addr_rw;
        bit [7:0] data_bytes[$];
        bit ack_bit;

        wait(vif.sda == 1 && vif.scl == 1);
        @(negedge vif.sda) if (vif.scl == 1) begin
            `uvm_info("MON_START", "Detected start condition", UVM_HIGH)
        end else begin
            return;
        end

        addr_rw = '0;
        for (int i = 7; i >= 0; i--) begin
            @(vif.cb);
            addr_rw[i] = vif.sda;
        end

        @(vif.cb);
        ack_bit = vif.sda;

        data_bytes.delete();
        while (1) begin
            bit [7:0] data_byte = '0;
            for (int i = 7; i >= 0; i--) begin
                @(vif.cb);
                data_byte[i] = vif.sda;
            end
            @(vif.cb);
            data_bytes.push_back(data_byte);
            ack_bit = vif.sda;

            @(vif.scl);
            if (vif.sda == 0 && vif.scl == 1) begin
                @(posedge vif.sda);
                if (vif.scl == 1) begin
                    `uvm_info("MON_STOP", "Detected stop condition", UVM_HIGH)
                    break;
                end
            end else if (vif.sda == 1 && vif.scl == 1) begin
                @(negedge vif.sda);
                if (vif.scl == 1) begin
                    `uvm_info("MON_REP_START", "Detected repeated start", UVM_HIGH)
                    break;
                end
            end
        end

        txn = i2c_transaction::type_id::create("txn");
        txn.address = addr_rw[7:1];
        txn.rw = addr_rw[0];
        txn.data = data_bytes;
        txn.ack = ack_bit;
        mon_analysis_port.write(txn);
        `uvm_info("MON_TXN", $sformatf("Collected txn: addr=0x%0h, rw=%0b, data=%p, ack=%0b", 
                                      txn.address, txn.rw, txn.data, txn.ack), UVM_MEDIUM)
    endtask
endclass

// I2C Agent
class i2c_agent extends uvm_agent;
    `uvm_component_utils(i2c_agent)
    uvm_sequencer #(i2c_transaction) sequencer;
    i2c_driver driver;
    i2c_monitor monitor;
    uvm_analysis_port #(i2c_transaction) agent_analysis_port;
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        agent_analysis_port = new("agent_analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = i2c_monitor::type_id::create("monitor", this);
        if (is_active == UVM_ACTIVE) begin
            sequencer = uvm_sequencer#(i2c_transaction)::type_id::create("sequencer", this);
            driver = i2c_driver::type_id::create("driver", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
        monitor.mon_analysis_port.connect(agent_analysis_port);
    endfunction
endclass

// I2C Reference Model
class i2c_ref_model extends uvm_component;
    `uvm_component_utils(i2c_ref_model)
    uvm_analysis_port #(i2c_transaction) ref_analysis_port;
    uvm_analysis_imp #(i2c_transaction, i2c_ref_model) ref_analysis_imp;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ref_analysis_port = new("ref_analysis_port", this);
        ref_analysis_imp = new("ref_analysis_imp", this);
    endfunction

    function void write(i2c_transaction txn);
        i2c_transaction exp_txn;
        exp_txn = i2c_transaction::type_id::create("exp_txn");
        exp_txn.address = txn.address;
        exp_txn.rw = txn.rw;
        exp_txn.data = txn.data;
        exp_txn.ack = 0; // Simplified: assume ACK
        ref_analysis_port.write(exp_txn);
        `uvm_info("REF_MODEL", $sformatf("Generated expected txn: addr=0x%0h, rw=%0b, data=%p, ack=%0b", 
                                        exp_txn.address, exp_txn.rw, exp_txn.data, exp_txn.ack), UVM_MEDIUM)
    endfunction
endclass

// I2C Scoreboard
class i2c_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(i2c_scoreboard)
    uvm_analysis_imp #(i2c_transaction, i2c_scoreboard) mon_analysis_imp;
    uvm_analysis_imp #(i2c_transaction, i2c_scoreboard) ref_analysis_imp;
    i2c_transaction exp_queue[$];
    i2c_transaction act_queue[$];

    function new(string name, uvm_component parent);
        super.new(name, parent);
        mon_analysis_imp = new("mon_analysis_imp", this);
        ref_analysis_imp = new("ref_analysis_imp", this);
    endfunction

    function void write_ref(i2c_transaction txn);
        exp_queue.push_back(txn);
        compare_transactions();
    endfunction

    function void write(i2c_transaction txn);
        act_queue.push_back(txn);
        compare_transactions();
    endfunction

    function void compare_transactions();
        i2c_transaction exp_txn, act_txn;
        if (exp_queue.size() > 0 && act_queue.size() > 0) begin
            exp_txn = exp_queue.pop_front();
            act_txn = act_queue.pop_front();
            if (exp_txn.address != act_txn.address) begin
                `uvm_error("SB_ADDR_MISMATCH", $sformatf("Address mismatch: Expected=0x%0h, Actual=0x%0h", 
                                                         exp_txn.address, act_txn.address))
            end
            if (exp_txn.rw != act_txn.rw) begin
                `uvm_error("SB_RW_MISMATCH", $sformatf("R/W mismatch: Expected=%0b, Actual=%0b", 
                                                       exp_txn.rw, act_txn.rw))
            end
            if (exp_txn.data != act_txn.data) begin
                `uvm_error("SB_DATA_MISMATCH", $sformatf("Data mismatch: Expected=%p, Actual=%p", 
                                                         exp_txn.data, act_txn.data))
            end
            if (exp_txn.ack != act_txn.ack) begin
                `uvm_error("SB_ACK_MISMATCH", $sformatf("ACK mismatch: Expected=%0b, Actual=%0b", 
                                                        exp_txn.ack, act_txn.ack))
            end
            if (exp_txn.address == act_txn.address &&
                exp_txn.rw == act_txn.rw &&
                exp_txn.data == act_txn.data &&
                exp_txn.ack == act_txn.ack) begin
                `uvm_info("SB_MATCH", "Transaction matched successfully!", UVM_MEDIUM)
            end
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        if (exp_queue.size() > 0 || act_queue.size() > 0) begin
            `uvm_warning("SB_PENDING", $sformatf("Uncompared transactions: Expected=%0d, Actual=%0d", 
                                                 exp_queue.size(), act_queue.size()))
        end
    endfunction
endclass

// I2C Sequence
class i2c_sequence extends uvm_sequence #(i2c_transaction);
    `uvm_object_utils(i2c_sequence)

    function new(string name = "i2c_sequence");
        super.new(name);
    endfunction

    task body();
        repeat(5) begin
            i2c_transaction txn;
            txn = i2c_transaction::type_id::create("txn");
            start_item(txn);
            if (!txn.randomize()) `uvm_fatal("SEQ_RAND_FAIL", "Randomization failed")
            finish_item(txn);
        end
    endtask
endclass

// I2C Environment
class i2c_env extends uvm_env;
    `uvm_component_utils(i2c_env)
    i2c_agent agent;
    i2c_ref_model ref_model;
    i2c_scoreboard scoreboard;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = i2c_agent::type_id::create("agent", this);
        ref_model = i2c_ref_model::type_id::create("ref_model", this);
        scoreboard = i2c_scoreboard::type_id::create("scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.agent_analysis_port.connect(scoreboard.mon_analysis_imp);
        if (agent.is_active == UVM_ACTIVE) begin
            agent.driver.drv_analysis_port.connect(ref_model.ref_analysis_imp);
        end
        ref_model.ref_analysis_port.connect(scoreboard.ref_analysis_imp);
    endfunction
endclass

// I2C Test
class i2c_test extends uvm_test;
    `uvm_component_utils(i2c_test)
    i2c_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = i2c_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        begin
            i2c_sequence seq;
            seq = i2c_sequence::type_id::create("seq");
            seq.start(env.agent.sequencer);
        end
        #100ns; // Ensure completion
        phase.drop_objection(this);
    endtask
endclass

// Placeholder DUT (I2C Master Stub)
module i2c_master (inout scl, sda);
    reg sda_out;
    assign sda = sda_out;

    initial sda_out = 1'bz;

    always @(negedge sda) begin
        if (scl == 1) begin // Start condition
            @(negedge scl);
            repeat(8) @(posedge scl); // Skip address
            sda_out = 0; // ACK
            @(negedge scl);
            sda_out = 1'bz;
            while (1) begin
                repeat(8) @(posedge scl); // Skip data
                sda_out = 0; // ACK
                @(negedge scl);
                sda_out = 1'bz;
                @(posedge scl);
                if (sda == 0 && scl == 1) begin
                    @(posedge sda);
                    if (scl == 1) break; // Stop condition
                end
            end
        end
    end
endmodule

// Top-Level Module
module tb_top;
    logic scl, sda;
    i2c_if i2c_if_inst();
    i2c_master dut(.scl(scl), .sda(sda));

    // Connect interface to DUT
    assign scl = i2c_if_inst.scl;
    assign sda = i2c_if_inst.sda;

    initial begin
        uvm_config_db#(virtual i2c_if)::set(null, "uvm_test_top", "vif", i2c_if_inst);
        run_test("i2c_test");
    end
endmodule