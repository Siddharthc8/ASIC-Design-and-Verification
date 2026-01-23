`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2025 04:32:03 PM
// Design Name: 
// Module Name: fifo_assert
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


module fifo_assert(fifo_if.DUT fifo_vif);

    // wr_ack whenever wr_en is high and !full
    property wr_ack;
    @(posedge fifo_vif.clk) disable iff(!fifo_vif.rst_n) (fifo_vif.wr_en && !fifo_vif.full) |=> fifo_vif.wr_ack;
    endproperty
    
    as1:assert property (wr_ack);
    co1:cover property (wr_ack);
    
    // Overflow when full
    property overflow;
    @(posedge fifo_vif.clk) disable iff(!fifo_vif.rst_n) (fifo_vif.wr_en && fifo_vif.full) |=> fifo_vif.overflow;
    endproperty
    
    as2:assert property (overflow);
    co2:cover property (overflow);
    
    // Underflow when rd_en and empty
    property underflow;
    @(posedge fifo_vif.clk) disable iff(!fifo_vif.rst_n) (fifo_vif.rd_en && fifo_vif.empty) |=> fifo_vif.underflow;
    endproperty
    
    as3:assert property (underflow);
    co3:cover property (underflow);
    
    // wr_en and !full and the DUT.count should go up by 1
    property count_up;
    @(posedge fifo_vif.clk) disable iff (!fifo_vif.rst_n) (fifo_vif.wr_en && !fifo_vif.rd_en && !fifo_vif.full) |=> DUT.count == $past(DUT.count) + 4'b0001;
    endproperty
    
    as4:assert property (count_up);
    co4:cover property (count_up);
    
    property count_down;
    @(posedge fifo_vif.clk) disable iff (!fifo_vif.rst_n) (!fifo_vif.wr_en && fifo_vif.rd_en && !fifo_vif.empty) |=> DUT.count == $past(DUT.count) - 4'b0001;
    endproperty
    
    as5:assert property (count_down);
    co5:cover property (count_down);
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Reset Check
    always_comb begin
        if(!fifo_vif.rst_n) begin
           a_reset:assert final(fifo_vif.data_out == 0 && fifo_vif.overflow == 0 && fifo_vif.underflow == 0 && fifo_vif.wr_ack == 0 );
           a_cover:cover (fifo_vif.data_out == 0 && fifo_vif.overflow == 0 && fifo_vif.underflow == 0 && fifo_vif.wr_ack == 0 );
        end
    end
    
    //////////////////////////////////////////////////////////////////////////////////////////////////

    // Full check
    always_comb begin
        if(fifo_vif.rst_n && DUT.count == fifo_vif.FIFO_DEPTH) begin
            as6: assert final(fifo_vif.full == 1);
            co6: cover property(fifo_vif.full == 1);
        end
    end
    
    // Empty check
    always_comb begin
        if(fifo_vif.rst_n && DUT.count == 0) begin
            as7: assert final(fifo_vif.empty == 1);
            co7: cover property(fifo_vif.empty == 1);
        end
    end
    
    // Almost Full check
    always_comb begin
        if(fifo_vif.rst_n && DUT.count == fifo_vif.FIFO_DEPTH-1) begin
            as8: assert final(fifo_vif.almost_full == 1);
            co8: cover property(fifo_vif.almost_full == 1);
        end
    end
    
    // Almost Empty check
    always_comb begin
        if(fifo_vif.rst_n && DUT.count == 1) begin
            as9: assert final(fifo_vif.almost_empty == 1);
            co9: cover property(fifo_vif.almost_empty == 1);
        end
    end
    
    
endmodule
