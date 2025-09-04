`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_example();

class obj extends uvm_object;
//    `uvm_object_utils(obj)
    
    rand bit [3:0] data;
    bit [3:0] a = 4;
    string b = "HI";
    real c = 12.34;

    function new(string path = "obj");
        super.new(path);
    endfunction
    
    `uvm_object_utils_begin(obj)
    `uvm_field_int(data, UVM_DEFAULT);
    `uvm_object_utils_end  
    
//    virtual function void do_print(uvm_printer printer);
//        super.do_print(printer);
//        printer.print_field_int("a :", a, $bits(a), UVM_DEC);
//        printer.print_string("b :", b);
//        printer.print_real("c", c);
//    endfunction
    
endclass

class obj_mod extends obj;
    
    rand bit ack;
    
    function new(string path = "obj_mod");
        super.new(path);
    endfunction
    
    `uvm_object_utils_begin(obj_mod)
    `uvm_field_int(ack, UVM_DEFAULT);    
    `uvm_object_utils_end
    
endclass

class comp extends uvm_component;
    `uvm_component_utils(comp)
    
    obj o;
    
    function new(string path = "comp", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    task run();
        o = obj::type_id::create("o");
        o.randomize();
        o.print();
    endtask
        
endclass
/////// MAIN MODULE /////////

    comp c;
    
    initial begin
        c.set_type_override_by_type(obj::get_type, obj_mod::get_type);
        c = comp::type_id::create("comp", null);
        c.run();
    end
    

endmodule