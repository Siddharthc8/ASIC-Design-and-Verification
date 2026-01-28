/*
    This problem is to solve the problem in the pdf TLM port, export, import practoce.pdf in the same directory
    The directions are also mentioned there
*/


module tb_TLM_port_connection_practice;

class ahb_tr extends uvm_sequence_item;

    rand bit [32-1:0] addr;
    rand bit [32-1:0] dataQ[$];
    rand bit wr_rd;
    rand bit [2:0] size;    // no of byter per transfer
    rand bit [2:0] burst; 
    rand bit [3:0] len;       // For incr case only, knob
    bit [1:0] resp;
    rand bit aligned_f;  // knob
    rand bit [3:0] prot;
    rand bit lock;
    int tx_size;
    bit [31:0] wrap_upper_addr, wrap_lower_addr;

    function new(string name = "ahb_tr");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(ahb_tr)
    
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_queue_int(dataQ, UVM_ALL_ON)
    `uvm_field_int(wr_rd, UVM_ALL_ON)
    `uvm_field_int(size, UVM_ALL_ON)
    `uvm_field_int(burst, UVM_ALL_ON)
    `uvm_field_int(len, UVM_ALL_ON)
    `uvm_field_int(resp, UVM_ALL_ON)
    `uvm_field_int(aligned_f, UVM_ALL_ON)
    `uvm_field_int(prot, UVM_ALL_ON)
    `uvm_field_int(lock, UVM_ALL_ON)
    `uvm_field_int(tx_size, UVM_ALL_ON)
    `uvm_field_int(wrap_upper_addr, UVM_ALL_ON)
    `uvm_field_int(wrap_lower_addr, UVM_ALL_ON)

    `uvm_object_utils_end


endclass

class axi_tr extends uvm_sequence_item;

    rand bit [32-1:0] addr;
    rand bit [32-1:0] dataQ[$];
    rand bit wr_rd;
    rand bit [2:0] size;    // no of byter per transfer
    rand bit [2:0] burst; 
    rand bit [3:0] len;       // For incr case only, knob
    bit [1:0] resp;
    rand bit aligned_f;  // knob
    rand bit [3:0] prot;
    rand bit lock;
    int tx_size;
    bit [31:0] wrap_upper_addr, wrap_lower_addr;

    function new(string name = "axi_tr");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(axi_tr)
    
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_queue_int(dataQ, UVM_ALL_ON)
    `uvm_field_int(wr_rd, UVM_ALL_ON)
    `uvm_field_int(size, UVM_ALL_ON)
    `uvm_field_int(burst, UVM_ALL_ON)
    `uvm_field_int(len, UVM_ALL_ON)
    `uvm_field_int(resp, UVM_ALL_ON)
    `uvm_field_int(aligned_f, UVM_ALL_ON)
    `uvm_field_int(prot, UVM_ALL_ON)
    `uvm_field_int(lock, UVM_ALL_ON)
    `uvm_field_int(tx_size, UVM_ALL_ON)
    `uvm_field_int(wrap_upper_addr, UVM_ALL_ON)
    `uvm_field_int(wrap_lower_addr, UVM_ALL_ON)

    `uvm_object_utils_end


endclass

class stimulus_generator extends uvm_component;
`uvm_component_utils(stimulus_generator)

    ahb_tr tr;
    uvm_blocking_put_port#(ahb_tr) put_port;

    function new(string path = "stimulus_generator", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        put_port = new("put_port", this);          // Put_port building

    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        repeat(5) begin
            tr = ahb_tr::type_id::create("tr");
            assert(tr.randomize());
            put_port.put(tr);
            tr.print();                  // This is the starting point of the item flow. START
        end
    endtask


endclass

class converter extends uvm_component;
`uvm_component_utils(converter)

    ahb_tr tr_h;
    axi_tr tr_a;
    uvm_blocking_get_port#(ahb_tr) get_port;
    uvm_blocking_put_port#(axi_tr) put_port;

    function new(string path = "converter", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        get_port = new("get_port", this);          // Get_port building
        put_port = new("put_port", this);          // Put_port building
    endfunction


    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            tr_h = ahb_tr::type_id::create("tr_h");
            get_port.get(tr_h);
            // Do the conversion for eg)
            tr_a = axi_tr::type_id::create("tr_a");
            tr_a.addr = tr_h.addr + 4;
            tr_a.dataQ = tr_h.dataQ;
            tr_a.wr_rd = tr_h.wr_rd;
            tr_a.size = tr_h.size;
            tr_a.burst = tr_h.burst;
            tr_a.len = tr_h.len;
            put_port.put(tr_a);

        end
    endtask

endclass

class producer extends uvm_component;
`uvm_component_utils(producer)

    stimulus_generator stim_gen;
    uvm_tlm_fifo#(ahb_tr) fifo;
    converter conv;
    // axi_tr tr;

    uvm_blocking_put_port#(axi_tr) put_port;  // The output from converter is axi converted from ahb

    function new(string path = "producer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        stim_gen = stimulus_generator::type_id::create("stim_gen", this);
        fifo = new("fifo", this);
        conv = converter::type_id::create("conv", this);

        put_port = new("put_port", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        stim_gen.put_port.connect(fifo.put_export);
        conv.get_port.connect(fifo.get_export);
        conv.put_port.connect(put_port);            // for port to port connection -> subcomponent.port.connect(port)
    endfunction


endclass

class driver extends uvm_component;
`uvm_component_utils(driver)

    axi_tr tr_a;

    uvm_blocking_get_port#(axi_tr) get_port;

    function new(string path = "driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        get_port = new("get_port", this);
    endfunction


    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            tr_a = axi_tr::type_id::create("tr_a");
            get_port.get(tr_a);
            // Do the conversion for eg)
            tr_a.print();                      // This is the ending point of the item flow. END

        end
    endtask

endclass

class consumer extends uvm_component;
`uvm_component_utils(consumer)

    driver drv;
    uvm_tlm_fifo#(axi_tr) fifo;
    // axi_tr tr_a;

    uvm_blocking_put_export#(axi_tr) put_export;

    function new(string path = "producer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        fifo = new("fifo", this);
        drv = driver::type_id::create("drv", this);
        put_export = new("put_export", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        put_export.connect(fifo.put_export);         // for export to export connection -> export.connect(subcomponent.export)
        drv.get_port.connect(fifo.get_export);
    endfunction


endclass




class test extends uvm_test;
`uvm_component_utils(test)

    uvm_table_printer printer;     // UVM Table printer
    producer prod;
    consumer cons;

    function new(string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        prod = producer::type_id::create("prod", this);
        cons = consumer::type_id::create("cons", this);
        printer = new();
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        prod.put_port.connect(cons.put_export);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info(get_type_name(), $sformatf("Printing the test topology: \n%s", this.sprint(printer)), UVM_LOW);
    endfunction

endclass


initial begin
    run_test("test");
end

endmodule