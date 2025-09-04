`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2025 03:21:24 PM
// Design Name: 
// Module Name: FIFO_DUT
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


module FIFO_DUT(fifo_if.DUT fifo_vif); // Use of modports
    
    localparam max_fifo_addr = $clog2(fifo_vif.FIFO_DEPTH);  // For eg: If it is 8 converts to 3 whoch is used for counts
    // Trivia 1 : What data_type is max_fifo_addr ?    Scroll to the bottom for answer
    
    // ACTUAL MEMORY
    reg [fifo_vif.FIFO_WIDTH-1:0] mem [fifo_vif.FIFO_DEPTH-1:0]; // reg [fifo_vif.FIFO_WIDTH-1:0] mem [fifo_vif.FIFO_DEPTH];    also supported
         //     data length                   addr length
         
    reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
    reg [max_fifo_addr:0] count;
    
    
    // WRITE - always block
    always @(posedge fifo_vif.clk or negedge fifo_vif.rst_n) begin
        
        if(!fifo_vif.rst_n) begin
            wr_ptr <= 0;
            fifo_vif.wr_ack <= 0;
            fifo_vif.overflow <= 0;  // BUG 1 : Reset all outputs to 0 in write operation
            for(int i =0; i < fifo_vif.FIFO_DEPTH; i++) begin
                mem[i] <=  0;                                  // BUG 
            end
        end
        
        else if(fifo_vif.wr_en && count < fifo_vif.FIFO_DEPTH) begin  
            mem[wr_ptr] <= fifo_vif.data_in;
            fifo_vif.wr_ack <= 1;
            wr_ptr <= wr_ptr + 1;
        end
        
        else begin
            fifo_vif.wr_ack <= 0;
            if(fifo_vif.full && fifo_vif.wr_en) 
                fifo_vif.overflow <= 1;
            else 
                fifo_vif.overflow <= 0;
            
        end
    
    end
    
    
    // READ - always block
    always @(posedge fifo_vif.clk or negedge fifo_vif.rst_n) begin
        
        if(!fifo_vif.rst_n) begin
            rd_ptr <= 0;           // BUG 2 : Reset all outputs to 0 in read operation
            fifo_vif.underflow <= 0;
            fifo_vif.data_out <= 0;
        end
        
        else if (fifo_vif.rd_en && count != 0) begin
            fifo_vif.data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
        
        else begin
            fifo_vif.underflow <= 0;
            if (fifo_vif.rd_en && count == 0)
                fifo_vif.underflow <= 1;  // BUG 3 : Underflow is sequential not combinational
            else
                fifo_vif.underflow <= 0;
        end
    
    end
    
    // count - always block
    always @(posedge fifo_vif.clk or negedge fifo_vif.rst_n) begin
        
        if(!fifo_vif.rst_n) begin
            count <= 0;           // Reset all outputs to 0 in read operation
        end
        
        else begin
            if ( {fifo_vif.wr_en, fifo_vif.rd_en} == 2'b10 && !fifo_vif.full ) 
                count <= count + 1;
            else if ( {fifo_vif.wr_en, fifo_vif.rd_en} == 2'b01 && !fifo_vif.empty )
                count <= count - 1;
            else if ( {fifo_vif.wr_en, fifo_vif.rd_en} == 2'b11 && fifo_vif.full ) // BUG 4 : Cover all cases of Full
                count <= count - 1;
            else if ( {fifo_vif.wr_en, fifo_vif.rd_en} == 2'b11 && fifo_vif.empty )  // BUG 5 : Cover all csaes for empty
                count <= count + 1;
            else if ({fifo_vif.wr_en, fifo_vif.rd_en} == 2'b11 && !fifo_vif.full && !fifo_vif.empty)
                count <= count;
            else 
                count <= count;
        end
        
    end
    
    
    assign fifo_vif.full = (count == fifo_vif.FIFO_DEPTH ) ? 1 : 0;
    assign fifo_vif.empty = (count == 0) ? 1 : 0;
    
    assign fifo_vif.almost_full = (count == fifo_vif.FIFO_DEPTH -1 ) ? 1 : 0;
    assign fifo_vif.almost_empty = (count == 1) ? 1 : 0;
    
endmodule


module fifo_reference_model(fifo_if.DUT_gold fifo_vif);
    
    int count;
    bit[fifo_vif.FIFO_WIDTH-1:0] mem_ref[$];
    
    // write block
    always @(posedge fifo_vif.clk or negedge fifo_vif.rst_n) begin
        if(!fifo_vif.rst_n) begin
            fifo_vif.wr_ack_ref <= 0;
            fifo_vif.overflow_ref <= 0;
            mem_ref.delete();
        end
        else if ( fifo_vif.wr_en && count < fifo_vif.FIFO_DEPTH) begin
            mem_ref.push_back(fifo_vif.data_in);
            fifo_vif.wr_ack_ref <= 1;
        end
        else begin
            fifo_vif.wr_ack_ref <= 0;
            if(fifo_vif.wr_en && count == fifo_vif.FIFO_DEPTH) 
                fifo_vif.overflow_ref <= 1;
            else 
                fifo_vif.overflow_ref = 0;
        end
    end
    
    // read block
    always @(posedge fifo_vif.clk or negedge fifo_vif.rst_n) begin
    
        if(!fifo_vif.rst_n) begin
            fifo_vif.data_out_ref <= 0;
            fifo_vif.underflow_ref <= 0;
        end
        
        else if( fifo_vif.rd_en && count != 0 ) begin
            fifo_vif.data_out_ref <= mem_ref.pop_front();
        end            
        
        else begin
            if( fifo_vif.rd_en && count == 0 ) 
                fifo_vif.underflow_ref <= 1;
            else 
                fifo_vif.underflow_ref <= 0;
        end
        
    end
    
    
    // count block
    always @(posedge fifo_vif.clk or negedge fifo_vif.rst_n) begin
        
        if(!fifo_vif.rst_n) begin
            count <= 0;
        end
        
        else begin
            if( {fifo_vif.wr_en, fifo_vif.rd_en} == 2'b10 && !fifo_vif.full_ref)
                count <= count + 1;
            else if( {fifo_vif.wr_en, fifo_vif.rd_en} == 2'b01 && !fifo_vif.empty_ref)
                count <= count - 1;
            else if( {fifo_vif.wr_en, fifo_vif.rd_en} == 2'b11 && fifo_vif.full_ref)
                count <= count - 1;
            else if( {fifo_vif.wr_en, fifo_vif.rd_en} == 2'b11 && fifo_vif.empty_ref)
                count <= count + 1;
            else if ({fifo_vif.wr_en, fifo_vif.rd_en} == 2'b11 && !fifo_vif.full_ref && !fifo_vif.empty_ref)
                count <= count;
            else 
                count <= count;
        end
    
    end
    
    assign fifo_vif.full_ref = (count == fifo_vif.FIFO_DEPTH) ? 1 : 0;
    assign fifo_vif.empty_ref = (count == 0) ? 1 : 0;
    assign fifo_vif.almost_full_ref = (count == fifo_vif.FIFO_DEPTH-1) ? 1 : 0;
    assign fifo_vif.almost_empty_ref = (count == 1) ? 1 : 0;
endmodule

///           INTERFACE            ////
interface fifo_if (input logic clk);

    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
//    logic rst_n = 1;
    
    // Actual DUT signals
    logic rst_n;           // Shared by golden model
    logic wr_en, rd_en;    // Shared by golden model
    logic full, empty;
    logic almost_full, almost_empty;
    logic overflow, underflow;
    logic wr_ack;
    
    // Golden model signals
    logic full_ref, empty_ref;
    logic almost_full_ref, almost_empty_ref;
    logic overflow_ref, underflow_ref;
    logic wr_ack_ref;
    
    // DATA signals 
    logic [FIFO_WIDTH-1:0] data_in, data_out;   // data_in is common for DUT and DUT gold
    logic [FIFO_WIDTH-1:0] data_out_ref;
    
    // Modport for DUT
    modport DUT(
        input clk, rst_n, 
        input data_in, wr_en, rd_en,
        output full, empty, almost_full, almost_empty, overflow, underflow, wr_ack,  // flags
        output data_out   // data
    );
    
    modport DUT_gold(
        input clk, rst_n,
        input data_in, wr_en, rd_en,
        output full_ref, empty_ref, almost_full_ref, almost_empty_ref, overflow_ref, underflow_ref, wr_ack_ref,  // flags
        output data_out_ref   // data
    );

endinterface


// Trivia 1 ans = data_type infered from argument passed inside $clog(). In our case it is -> unsigned int

