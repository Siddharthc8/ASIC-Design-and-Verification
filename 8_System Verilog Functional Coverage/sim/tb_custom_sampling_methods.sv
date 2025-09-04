`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2025 12:32:14 PM
// Design Name: 
// Module Name: tb_custom_sampling_methods
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


module tb_custom_sampling_methods();

  reg rd,wr,en;
  
  reg [1:0] din;
  integer i = 0;
  
  typedef enum {write, read, NOP,error} opstate;
  opstate o1,o2;
  
  function opstate detect_state (input rd, wr, en);   // Using function to return a value which will be the input another function
    if(en == 0)
       return NOP;
    else if (en == 1 && wr == 1 && rd == 0)
       return write;
    else if (en == 1 && rd == 1 && wr == 0)
        return read;
    else 
       return error;  
  endfunction
 
  function bit [1:0] decode_state (input opstate oin);      // Data-type is the enum type returned by another function
    if(oin == NOP )
      return 2'b00;
    else if (oin == write)
      return 2'b01;
    else if (oin == read)
      return 2'b10;
    else if (oin == error)
       return 2'b11; 
  endfunction
 
  
  function check_cover (input rd , wr,en);      // Calling the main two functions inside another one with arguments
    o1 = detect_state(rd,wr,en);            // Takes the arguments from the arguments of the enclosing fn and returns a value
    din = decode_state (o1);            // The returned value from previous fn is used as argument and returns a another new value
    ci.sample(o1);                  // Then we sample that value which is a covergroup decalred using "with function sample" method
  endfunction
  
  
  covergroup c with function sample (input opstate cin);         
    option.per_instance = 1;
    coverpoint cin;
    
  endgroup
 
  c ci;
 
 
 // Basically calling two functions and a covergroup with function sample method in another function
 // Then the main function enclosing all is called in the initial block 
 
 
  initial begin
     ci = new();   // NOTE : arguments for with function sample is mentioned only during sample decalration(mentioned in the check_cover function)
    
    
    for (i = 0; i <40; i++) begin
      wr = $urandom();
      rd = $urandom();
      en = $urandom();
      check_cover(rd,wr,en);
      #10;
    end
    
    
  end
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #400;
    $finish();
  end

 
endmodule