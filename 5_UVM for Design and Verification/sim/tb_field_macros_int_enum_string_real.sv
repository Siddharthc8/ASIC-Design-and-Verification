`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

/*

Reference: https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.1c/html/index.html

    Syntax for invoking FIELD MACROS
        `uvm_object/component_utils_begin(current_class)
        `uvm_field_int(NAME, FIELD_MACRO_ACTION)   // ACTION can be OR'ed to mention representation 
        `uvm_field_object
        `uvm_object/component_utils_begin

FIELD MACROS or CORE METHODS   
 
            UVM_ALL_ON	    Set all operations on (default).
            UVM_DEFAULT	    Use the default flag settings.
            UVM_NOCOPY	    Do not copy this field.
            UVM_NOCOMPARE	Do not compare this field.
            UVM_NOPRINT	    Do not print this field.
            UVM_NOPACK	    Do not pack or unpack this field.
            UVM_REFERENCE	For object types, operate only on the handle (e.g. no deep copy)
            UVM_PHYSICAL	Treat as a physical field.  Use physical setting in policy class for this field.
            UVM_ABSTRACT	Treat as an abstract field.  Use the abstract setting in the policy class for this field.
            UVM_READONLY	Do not allow setting of this field from the set_*_local methods or during <apply_config_settings> operation.

REPRESENTATION

A radix for printing and recording can be specified by OR�ing one of the following constants in the FLAG argument

            UVM_BIN	        Print / record the field in binary (base-2).
            UVM_DEC	        Print / record the field in decimal (base-10).
            UVM_UNSIGNED	Print / record the field in unsigned decimal (base-10).
            UVM_OCT	        Print / record the field in octal (base-8).
            UVM_HEX	        Print / record the field in hexidecimal (base-16).
            UVM_STRING	    Print / record the field in string format.
            UVM_TIME	    Print / record the field in time format.
            
 FIELD MACROS METHODS
            
            Print
            Record
            Copy
            Clone
            Compare
            Create
            Clone
            Pack + Unpack

*/

`include "uvm_macros.svh"
import uvm_pkg::*;
 
module tb_field_macros_int_enum_string_real();
 
class obj extends uvm_object;
//  `uvm_object_utils(obj)     // BEGIN_END factory registering should be used to use field macros |
  typedef enum bit [1:0] {s0 , s1, s2, s3} state_type;                                       //    |
  rand state_type state;                                                                     //    |
                                                                                             //    |
  bit [2:0] a = 5;                                                                           //    |
  real temp = 12.34;                                                                         //    |
  string str = "UVM";                                                                        //    |
                                                                                             //    |
  function new(string path = "obj");                                                         //    |
    super.new(path);                                                                         //    |
  endfunction                                                                                //    |
                                                                                             //    |
                                                                                             //    |
  `uvm_object_utils_begin(obj)//                   <------------------------------------------------ 
  `uvm_field_int(a, UVM_NOPRINT | UVM_BIN);        // The REPRESENTATION is OR'ed with the action 
  `uvm_field_enum(state_type, state, UVM_DEFAULT);
  `uvm_field_string(str,UVM_DEFAULT);
  `uvm_field_real(temp, UVM_DEFAULT);
  `uvm_object_utils_end
 
  
endclass
 
  obj o;
  
  initial begin
    int i;
      for(i=0;i<3;i++)
      begin
        o = new("obj");
        o.randomize();
        o.print(uvm_default_table_printer);  // Print can only be used on FIELD MACROS and the way the output should eb displayed can be mentioned(TABLE, TREE,)
        #5;
      end                                             
  end
  
endmodule
