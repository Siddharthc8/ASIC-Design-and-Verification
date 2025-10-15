module tb_TLM_ports;

/*

uvm_*_port   : uvm_blocking_put_port, uvm_blocking_get_port, uvm_analysis_port
uvm_*_imp    : uvm_blocking_put_imp,  uvm_blocking_get_imp,  uvm_analysis_imp
uvm_*_export : uvm_put_export,        uvm_get_export,        uvm_analysis_export
uvm_*_fifo   : uvm_tlm_fifo


While making the connections always connect from port -> implementation port
Eg) class.port.connect(class.export);


*/

// --------------------------------------------------------------------------------------- //

// UVM_BLOCKING_PUT_PORT

class producer extends uvm_component;
`uvm_component_utils(producer)

uvm_blocking_put_port#(transaction) put_port;

function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    put_port = new("put_port", this);

endfunction


task run_phase(uvm_phase phase);

    transaction tx;
    repeat(5) begin
        
        tx = tx::type_id::create("tx");
        tx.randomize();
        put_port.put(tx);

    end

endtask

endclass


class consumer extends uvm_component;
`uvm_component_utils(consumer)


uvm_blocking_put_imp#(transaction, this) put_export;

function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    put_export = new("put_imp", this);

endfunction

endclass

// put task
task put(transaction tx);
    
    tx.print();
        
endtask

endmodule


class top;

    producer prod;
    consumer cons;

    function build_phase(uvm_phase phase);
        super.build_phase(phase);

        prod = producer::type_id::create("prod");
        cons = consumer::type_id::create("cons");

    endfunction


    function connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        prod.put_port.connect(cons.put_export);

    endfunction

endclass

// ----------------------------------------------------------------------------------------- //

// UVM_BLOCKING_GET_PORT

class producer extends uvm_component;
`uvm_component_utils(producer)

uvm_blocking_get_imp#(transaction, this) get_export;

function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    get_export = new("get_imp", this);

endfunction

// get task
task get(transaction tx);

    tx.print();

endtask

endclass


class consumer extends uvm_component;
`uvm_component_utils(consumer)


uvm_blocking_get_port#(transaction) get_port;


function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    get_port = new("get_port", this);

endfunction



task run_phase(uvm_phase phase);

    transaction tx;
    repeat(5) begin
        
        tx = tx::type_id::create("tx");
        tx.randomize();
        put_port.put(tx);

    end

endtask

endclass



class top;

    producer prod;
    consumer cons;

    function build_phase(uvm_phase phase);
        super.build_phase(phase);

        prod = producer::type_id::create("prod");
        cons = consumer::type_id::create("cons");

    endfunction


    function connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        cons.get_port.connect(prod.get_export);

    endfunction

endclass


// ----------------------------------------------------------------------------------------- //

// UVM_ANALYSIS_PORT

class producer extends uvm_component;
`uvm_component_utils(producer)

uvm_analysis_port#(transaction) analysis_port;

function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    analysis_port = new("get_imp", this);

endfunction

task get(transaction tx);

    tx.print();

endtask

task run_phase(uvm_phase phase);

    transaction tx;
    repeat(5) begin
        
        tx = tx::type_id::create("tx");
        tx.randomize();
        analysis_port.send(tx);

    end

endtask

endclass


class consumer extends uvm_component;
`uvm_component_utils(consumer)


uvm_analysis_imp#(transaction, this) analysis_export;


function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    analysis_export = new("get_port", this);

endfunction

function write(transaction tx);
    
    tx.print();

endtask


endclass


class top;

    producer prod;
    consumer cons;

    function build_phase(uvm_phase phase);
        super.build_phase(phase);

        prod = producer::type_id::create("prod");
        cons = consumer::type_id::create("cons");

    endfunction


    function connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        prod.analysis_port.connect(cons.analysis_export);

    endfunction

endclass


