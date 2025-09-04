`timescale 1ns / 1ps




module dac(input clk,
    input [11:0] din,
    input start,
    output reg mosi, cs
);
  
    typedef enum {idle = 0, init = 1, send = 3, data_gen = 2, cont= 4} state_type;
    state_type state;
 
    reg [31:0] setup = 32'h08000001;
    reg [31:0] dac_data = 32'h00000000;
    integer count = 0;
 
    always@(posedge clk)
    begin
        case(state)
      
        idle: 
        begin
            cs <= 1'b1;
            mosi <= 1'b0;
         
            if(start)
                state <= init;
            else
                state <= idle;
        end
     
        init:
        begin
            if(count < 32) 
            begin
                count <= count + 1;
                mosi <= setup[31 - count];
                cs <= 1'b0;
                state <= init;
            end
            
            else 
            begin
                cs <= 1'b1;
                count <= 0;
                state <= data_gen;
            end
     
        end
     
        data_gen: 
        begin
            dac_data <= {12'h030,din,8'h00};
            state <= send;
        end
         
        send: 
        begin
            if(count < 32) 
            begin
                count <= count + 1;
                mosi <= dac_data[31 - count];
                cs <= 1'b0;
                state <= send;
            end
            else 
            begin
                cs <= 1'b1;
                count <= 0;
                state <= cont;
            end
        end
         
        cont: 
        begin
            if(start)
                state <= data_gen;
            else
                state <= idle;
        end
     
        endcase
    end
endmodule