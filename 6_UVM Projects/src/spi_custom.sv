`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2024 06:12:16 PM
// Design Name: 
// Module Name: spi_custom
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


module spi_custom(             // MASTER

 input wr,clk,rst,ready,op_done,
    input [7:0] addr, din,
    output [7:0] dout,
    output reg cs, mosi,
    input miso,
    output reg done, err
    );
    
////////////////////////////////
reg [16:0] din_reg;  //// <- data 0:7 -> <- addr 0 : 7 -> <- op: wr / rd ->
reg [7:0] dout_reg;
 
integer count = 0;
 
typedef enum bit [2:0] {idle = 0, load = 1, check_op = 2, send_data = 3, read_data1 = 4, read_data2 = 5, error = 6, check_ready = 7} state_type;
state_type state = idle; 
 
/////////////////cs logic   
always@(posedge clk)
begin
  if(rst)
           begin
           state <= idle;
           count <= 0;
           cs <= 1'b1;
           mosi <= 1'b0; 
           err <= 1'b0;
           done <= 1'b0;
           end
 else 
   begin
      case(state)
            idle: begin
                cs    <= 1'b1;
                mosi  <= 1'b0;
                state <= load;
                err <= 1'b0;
                done <= 1'b0;
            end
            
            load: begin
                din_reg <= {din, addr, wr};
                state   <= check_op;
            end
 
            check_op: begin
                if(wr == 1'b1 && addr < 32)
                 begin
                    cs <= 1'b0;
                    state <= send_data;
                 end
                else if (wr == 1'b0 && addr < 32)
                 begin
                    state <= read_data1;
                    cs <= 1'b0;
                 end
                else begin
                    state <= error;
                    cs <= 1'b1;
                 end
            end
 
 
            send_data : 
            begin
                if(count <= 16)
                 begin
                    count <= count + 1;
                    mosi  <= din_reg[count];
                    state = send_data;
                 end
                else
                  begin
                     cs    <= 1'b1;
                     mosi  <= 1'b0;
                     if(op_done) 
                           begin
                               count <= 0;
                               done  <= 1'b1;
                               state <= idle;
                            end
                      else
                           begin
                           state <= send_data;
                           end
                  end
            end
 
            read_data1: begin
                if(count <= 8)
                 begin
                    count <= count + 1;
                    mosi  <= din_reg[count];
                    state <= read_data1;
                 end
                else
                  begin
                    count <= 0;
                    cs    <= 1'b1;
                    state <= check_ready;
                  end
            end
   
            check_ready : begin
                if(ready)
                      state <= read_data2;
                else
                      state <= check_ready;
                      
            end
 
            read_data2:begin
                if(count <= 7)
                     begin
                        count <= count + 1;
                        dout_reg[count]  <=  miso;
                        state = read_data2;
                     end
                else
                      begin
                        count <= 0;
                        done <= 1'b1;
                        state <= idle;
                      end
            end
            
            error : begin
                err   <= 1'b1;
                state <= idle;
                done  <= 1'b1;
            end
            
           default: begin
              state <= idle;
              count <= 0;
           end
            
      endcase
   end 
end 
 
 
assign dout = dout_reg;
endmodule
////////////////////////////////////////////////////
 
/////////////////spi memory
 
module spi_mem(
input clk, rst, cs, miso,
output reg ready, mosi, op_done
);
 
reg [7:0] mem [31:0] = '{default:0};
integer count = 0;
reg [15:0] datain;
reg [7:0]  dataout;
 
typedef enum bit [2:0] {idle = 0, detect = 1, store = 2, send_addr = 3, send_data = 4} state_type;
state_type state = idle;
 
always@(posedge clk)
begin
      if(rst) 
          begin
             state <= idle;
             count <= 0;
             mosi  <= 0;
             ready <= 0;
             op_done <= 0;
             
          end
     else
         begin
                case(state)
                  idle: begin
                    count <= 0;
                    mosi  <= 0;
                    ready <= 0;
                    op_done <= 0;
                    datain <= 0;
                  
                     if(!cs)
                       state <= detect;
                     else
                       state <= idle;
                  end
                  
                    
                  detect: begin 
                      if(miso)
                        state <= store; ///write 
                      else
                        state <= send_addr;   ///read
                   end
                   
                    
                   store: begin
                      if(count <= 15) begin
                        datain[count]     <= miso;
                        count             <= count + 1;
                        state             <= store;
                      end
                      else
                        begin
                         mem[datain[7:0]]  <= datain[15:8];
                         state <= idle;
                         count <= 0;
                         op_done <= 1'b1;
                        end
                    end
                    
                    send_addr: begin
                      if(count <= 7) begin
                       count <= count + 1;
                       datain[count] <= miso;
                       state <= send_addr;
                       end
                       else begin
                       count <= 0;
                       state <= send_data;
                       ready <= 1'b1;
                       dataout <= mem[datain];
                       end
                    end
                       
                    send_data: begin
                       ready <= 1'b0;
                       if(count < 8) 
                       begin
                        count <= count + 1;
                        mosi  <= dataout[count]; 
                        state <= send_data;
                       end 
                       else
                         begin
                         count <= 0;
                         state <= idle;
                         op_done <= 1'b1;
                         end     
                    end   
                    
                    default : state <= idle;
                    
                 endcase
          end
      end
endmodule
 
////////////////////////////////////////////////////////////
 
 
 
 
//////////////////
module spi_custom_top(
    input wr,clk,rst,
    input [7:0] addr, din,
    output [7:0] dout,
    output done, err
);
wire csreg, mosireg, misoreg, readyreg, opdonereg;
 
spi_custom intf (wr, clk, rst, readyreg, opdonereg, addr, din, dout, csreg, mosireg, misoreg, done, err);
spi_mem  mem_inst (clk, rst, csreg, mosireg, readyreg, misoreg, opdonereg);
 
endmodule
 
 
 
 
 
 
 
 
//////////////////////////////////////////////
 
interface spi_c;
  
    logic wr,clk,rst;
    logic [7:0] addr, din;
    logic [7:0] dout;
    logic done, err;
  
endinterface
