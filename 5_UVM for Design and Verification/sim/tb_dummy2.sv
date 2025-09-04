`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2025 09:53:02 AM
// Design Name: 
// Module Name: tb_dummy2
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

module tb_dummy2();

class config_dff extends uvm_object;
`uvm_object_utils(config_dff)
   
   uvm_active_passive_enum   agent_type  =  UVM_ACTIVE;
   
   function new(string path = "config_dff");
   super.new(path);
   endfunction

endclass

//-----------------------------------------
                                                                        
typedef enum logic [1:0] {rstdut_t, add_t, mul_t} oper_type;                  //     | ------------>         Dynamic Array                                                    
                                                                //     |    {  insert(index, value): Inserts an element at the specified index. 
class transaction extends uvm_sequence_item;                    //     |    {  delete(index): Deletes an element at the specified index.        
//`uvm_object_utils(transaction)  --------------------------->> //     |    {  delete(): Deletes all elements in the array.                               
                                                                //     |    {  size(): Returns the number of elements in the array.                       
    function new(string path = "transaction");                  //     |    ----------------------------------------------------------------------------------          
    super.new(path);                                            //     | ------------>              Queue                                                         
    endfunction                                                 //     |    {  push_front(value): Inserts an element at the front of the array.
                                                                //     |    {  push_back(value): Inserts an element at the end of the array.                     
    rand logic rst;                                         //  OR  // |    {  pop_front(): Removes and returns the first element of the array.                  
    rand logic [3:0] a;      // Input randomized                //     |    {  pop_back(): Removes and returns the last element of the array.
    rand logic [3:0] b;      // Input randomized                //     |
    logic [7:0] out;           // Output not randomized         //     |    ----------------------------------------------------------------------------------- 
    logic add_flag, mul_flag;  // Flag for transaction start    //     | ------------>           Associative array                                               
    string str = "UVM";      // String type                     //     |    {  exists(index): Checks if an element with the specified index exists in the array. 
    real deci = 12.34;       // "real" is Floating Point        //     |    {  delete(index): Deletes an element with the specified index.                       
    rand oper_type oper;     // Enum type randomized            //     |    {  delete(): Deletes all elements in the array.                                      
    //    Array types      ------------------------------------------>>|    {  size(): Returns the number of elements in the array.                              
    int arr1[3] = {1,2,3};   // Static array                    //     |    {  first(var index): Assigns the first index to the specified variable.              
    int arr2[];              // Dynamic array                   //     |    {  last(var index): Assigns the last index to the specified variable.                
    int arr3[$];             // Queue                           //     |    {  next(var index): Assigns the next index to the specified variable.                
    int arr4[int];           // Associative array               //     |    {  prev(var index): Assigns the previous index to the specified variable.            
                                                                //     ------------------------------------------------------------------------------------------
                                                                //     
                                                                //             ----------------------------------------------------------------------             
    `uvm_object_utils_begin(transaction)  // <------------------//             //             Field Macros Options                                                
     `uvm_field_int(a, UVM_DEFAULT);                            //             // UVM_ALL_ON	    Set all operations on     
     `uvm_field_int(b, UVM_DEFAULT);                                           // UVM_DEFAULT 	[Default] Enables all operations.                             
     `uvm_field_int(add_flag, UVM_DEFAULT);                                    // UVM_NOCOPY	    Do not copy this field                                      
     `uvm_field_int(out, UVM_DEFAULT);                                         // UVM_NOCOMPARE	Do not compare this field
     `uvm_field_int(add_flag, UVM_DEFAULT);                                    // UVM_NOPRINT	    Do not print this field                                    
     `uvm_field_int(mul_flag, UVM_DEFAULT);                                    // UVM_NOPACK	    Do not pack/unpack this field                                     
     `uvm_field_string(str,UVM_DEFAULT);                                       // UVM_REFERENCE	For object types, operate on handles only (like no deep copy)          
     `uvm_field_real(deci, UVM_DEFAULT);                                       //                  OR'ed Options                                                           
     `uvm_field_enum(oper_type, oper, UVM_DEFAULT);  // enum_type, enum_var    // Or'ed with above options to print in a particular format                          
     //   Arrays                                                               // UVM_BIN, UVM_DEC, UVM_UNSIGNED, UVM_OCT, UVM_HEX, UVM_STRING, UVM_TIME             
     `uvm_field_sarray_int(arr1, UVM_DEFAULT );       // Static array               
     `uvm_field_array_int(arr2, UVM_DEFAULT);        // Dynamic array               
     `uvm_field_queue_int(arr3, UVM_DEFAULT);        // Queue                       
     `uvm_field_aa_int_int(arr4, UVM_DEFAULT);       // Associative array                                      
     `uvm_object_utils_end                                                                                                                                                          
//                                                                             ------------------------------------------------------------------------------------ 
           //      Reporting Macros Options                                //            Reporting Macros Options                                                 
      task reporting_macros();            //   Verbosity                     // UVM_NO_ACTION - no action                                                         
      `uvm_info("DRV", "Informational Message", UVM_NONE);                   // UVM_DISPLAY - displays on the console                                             
      `uvm_warning("DRV", "Potential Error");                                // UVM_LOG - Reprts to the file for the severity,ID pair                             
      `uvm_error("DRV", "Real Error");                                       // UVM_COUNT - Counts the number of occurance                                        
      `uvm_error("DRV", "Second Real Error");                                // UVM_EXIT - Terminates the simulation                                              
      endtask                                                                // UVM_CALL_HOOK - Callback to report jook mathods                                   
                                                                             // UVM_STOP - #stops and puts the simulaton in interactive mode                      
   // Verbosity is like Restriction                                          // UVM_RM_RECORD - Sends the reprt to the recorder              
   //   UVM_LOW, UVM_MEDIUM, UVM_HIGH                                                                                                                                            
                                                                                          

endclass

class sequence_add extends uvm_sequence#(transaction);                 // SEQUENCE 1
`uvm_object_utils(sequence_add)
    
    function new(string path = "sequence_add", uvm_component parent = null);      
    super.new(path, parent);                                                    
    endfunction     
    
    // Declarations
    transaction tr;                                                            
    
    // NOTE :   Sequence can only have  PRE_BODY, BODY, POST_BODY    
                                                                            
    virtual task body();                                                        
        repeat(10) begin   
            
            // Type 1                                                 
            `uvm_do(tr)     // Creates new object of tranascton as well     
                
               // OR  
                                             
            // Type 2                               
            tr = transaction::type_id::create("tr");                            
            start_item(tr);
            assert(tr.randomize());    
            tr.op = add_t;                                         
            finish_item(tr);
            
               // OR                    
            
            // Type 3                                           
            tr = transaction::type_id::create("tr");
            wait_for_grant();                                                   
            assert(tr.randomize());
            tr.op = add_t;
            send_request(tr);        // Argument present here  
            wait_for_item_done();                                        
        end
    endtask
    
endclass

class sequence_mul extends uvm_sequence#(transaction);                 // SEQUENCE 2  same as SEQ1 for example
`uvm_object_utils(sequence_mul)
    
    function new(string path = "sequence_mul", uvm_component parent = null);      
    super.new(path, parent);                                                    
    endfunction     
    
    // Declarations
    transaction tr;                                                            
    
    // NOTE :   Sequence can only have  PRE_BODY, BODY, POST_BODY    
                                                                            
    virtual task body();                                                        
        repeat(10) begin   
            
            // Type 1                                                 
            `uvm_do(tr)     // Creates new object of tranascton as well     
                
               // OR  
                                             
            // Type 2                               
            tr = transaction::type_id::create("tr");                            
            start_item(tr);
            assert(tr.randomize());
            tr.op = mul_t;                                             
            finish_item(tr);
            
               // OR                    
            
            // Type 3                                           
            tr = transaction::type_id::create("tr");
            wait_for_grant();                                                   
            assert(tr.randomize());
            tr.op = mul_t; 
            send_request(tr);        // Argument present here  
            wait_for_item_done();                                        
        end
    endtask
    
endclass

class driver extends uvm_driver#(transaction);
`uvm_component_utils(driver)

    function new(string path = "driver", uvm_component_parent = null);
    super.new(path, parent);
    endfunction
    
    // Declarations
    transaction tr;
    virtual template_if tif;
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        tr = transaction::type_id::create("tr");
        
        //                                           (access, "scope_restriction", ""id", type)
        if ( !uvm_config_db#(virtual template_if)::get(this, "", "tif", tif) )    // Context + Instance name + Key + Value                                            
        `uvm_error("DRV", "Unable to access interface");                // When you set context to "null" all the classes have access to this variable or data 
    endfunction
    
    
    // Reset DUT
    task reset_dut();
    
        tif.rst <= 1'b1;      // Non-blocking to interaface 
        tif.a <= 0;
        tif.b <= 0;
        // Output variable cannot be assigned a value
        repeat(3) @(posedge clk);
        tif.rst <= 1'b0;
        `uvm_info("DRV", $sformatf("Reset Done : %d", rst), UVM_NONE);
        
    endtask
    
    
    task task_add();
        
        `uvm_info("DRV", $sformatf("This is task_1 with a = %d", a), UVM_NONE);
        tif.rst <= 0;
        tif.a <=  tr.a;
        tif.b <= tr.b;
        @(posedge tif.done);
    
    endtask
    
    task task_mul();
        
        `uvm_info("DRV", $sformatf("This is task_1 with a = %d", a), UVM_NONE);
        tif.rst <= 0;
        tif.a <=  1;
        @(posedge tif.done);
    
    endtask
    
    // RUN Phase 
    virtual task run_phase(uvm_phase phase);
        
        reset_dut();
        
        forever begin
            
            seq_item_port.get_next_item(tr);
                
                if(tr.op == rstdut_t)
                begin
                   reset_dut(); 
                end
                
                else if(tr.op == add_t)
                begin
                   task_add(); 
                end
                
                else if(tr.op == mul_t)
                begin
                   task_mul(); 
                end
                
                else
                begin
                   reset_dut(); 
                end
                
            seq_item_port.item_done();
            
        end
        
    endtask
    
endclass


class monitor extends uvm_monitor;
`uvm_component_utils(monitor)

    transaction tr;
    uvm_analysis_port#(transaction) send;   // Considered like uvm_component with two args but new() method only to create object
    virtual template_if tif;
    
    function new(string path = "monitor", uvm_component parent = null);
    super.new(path, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        tr = transaction::type_id::create("tr");
        send = new("send", this);                // More like instantiation with "name" and parent
        
        if( !uvm_config_db#(virtual template_if)::get(this, "", "tif", tif) )
        `uvm_error("MON", "Unable to access interface");  
    endfunction
    
    
    task sample_add();
        
        @(posedge tif.done);
        tr.a = tif.a;
        tr.b = tif.b;
        tr.out = tif.out;
        
    endtask
    
    task sample_mul();
        
        @(posedge tif.done);
        tr.a = tif.a;
        tr.b = tif.b;
        tr.out = tif.out;
        
    endtask
    
    virtual task run_phase(uvm_phase phase);
    
        forever begin
            
            sample_add();
    
        end
        
    endtask
    
endclass


endmodule





  


























