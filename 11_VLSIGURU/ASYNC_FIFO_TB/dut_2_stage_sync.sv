// CORRECTED Design with 2-Stage CDC Synchronizers
`define DEPTH 16
`define WIDTH 16

module async_fifo(
	wr_clk_i, rd_clk_i, rst_i, wr_en_i, wdata_i, rd_en_i, rdata_o, full_o, empty_o, wr_error_o, rd_error_o
);
	//depth of fifo=16 loc, width of each data=16 bit
    parameter DEPTH = `DEPTH, WIDTH = `WIDTH;
  
	input wr_clk_i;
	input rd_clk_i;
	input rst_i;
	input wr_en_i;
  	input[WIDTH-1:0] wdata_i;
	input rd_en_i;
  	output reg[WIDTH-1:0] rdata_o;
	output reg full_o;
	output reg empty_o;
	output reg wr_error_o;
	output reg rd_error_o;
	
	//declaration of internal registers and memories
	reg[3:0] wr_ptr, rd_ptr;
	reg[3:0] wr_ptr_gray, rd_ptr_gray;
	
	// ████████████████████████████████████████████████████████████████
	// ██ CHANGED: Added 2-stage synchronizers (NEW SIGNALS)           ██
	// ████████████████████████████████████████████████████████████████
	reg[3:0] wr_ptr_rd_clk_sync1, wr_ptr_rd_clk_sync2;  // ← NEW: wr_ptr synchronized to read clock (2 stages)
	reg[3:0] rd_ptr_wr_clk_sync1, rd_ptr_wr_clk_sync2;  // ← NEW: rd_ptr synchronized to write clock (2 stages)
	
	reg wr_toggle_f, rd_toggle_f;
	
	// ████████████████████████████████████████████████████████████████
	// ██ CHANGED: Added 2-stage synchronizers for toggle bits (NEW)   ██
	// ████████████████████████████████████████████████████████████████
	reg wr_toggle_f_rd_clk_sync1, wr_toggle_f_rd_clk_sync2;  // ← NEW: toggle bit sync to read clock
	reg rd_toggle_f_wr_clk_sync1, rd_toggle_f_wr_clk_sync2;  // ← NEW: toggle bit sync to write clock
	
	//fifo memory structure
  	reg[WIDTH-1:0] fifo[DEPTH-1:0];
	//loop variable
	integer i;
	
	//everytime there is a posedge of input clock, we will check for
	//values of rst, wr_en to proceed with corresponding functionality
	//active high reset : reset the fifo when rst signal is high
	always@(posedge wr_clk_i) begin
		if(rst_i==1) begin
			//reset output ports and internal regs
			rdata_o <= 0;
			full_o <= 0;
			empty_o <= 0;
			wr_error_o <= 0;
			rd_error_o <= 0;
			wr_ptr <= 0;
			rd_ptr <= 0;
			wr_ptr_gray <= 0;
			rd_ptr_gray <= 0;
			
			// ████████████████████████████████████████████████████████████████
			// ██ CHANGED: Reset all CDC synchronizer stages (NEW)            ██
			// ████████████████████████████████████████████████████████████████
			wr_toggle_f_rd_clk_sync1 <= 0;
			wr_toggle_f_rd_clk_sync2 <= 0;
			rd_toggle_f_wr_clk_sync1 <= 0;
			rd_toggle_f_wr_clk_sync2 <= 0;
			
			wr_ptr_rd_clk_sync1 <= 0;
			wr_ptr_rd_clk_sync2 <= 0;
			rd_ptr_wr_clk_sync1 <= 0;
			rd_ptr_wr_clk_sync2 <= 0;
			
			wr_toggle_f <= 0;
			rd_toggle_f <= 0;
			for(i=0; i<16; i=i+1)
				fifo[i] <= 0;
		end
		else begin
			wr_error_o <= 0;
			//normal operation
			if(wr_en_i == 1) begin
				//is full flag high?
				if(full_o == 1) begin
					//error raised
					wr_error_o <= 1;
				end
				else begin
					//write operation
					fifo[wr_ptr] <= wdata_i;
                  			if(wr_ptr == DEPTH-1) begin
						wr_ptr <= 0;
						wr_toggle_f <= ~wr_toggle_f;
					end
					else begin
						wr_ptr <= wr_ptr + 1;
					end
				end
			end
			//convert to gray code
			wr_ptr_gray <= {wr_ptr[3], wr_ptr[3:1]^wr_ptr[2:0]};
		end
	end


	always@(posedge rd_clk_i) begin
		if(rst_i == 0) begin
			rd_error_o <= 0;
			if(rd_en_i == 1) begin
				//is empty flag high?
				if(empty_o == 1) begin
					//error raised
					rd_error_o <= 1;
				end
				else begin
					//read operation
					rdata_o <= fifo[rd_ptr];
					if(rd_ptr == DEPTH-1) begin
						rd_ptr <= 0;
						rd_toggle_f <= ~rd_toggle_f;
					end
					else begin
						rd_ptr <= rd_ptr + 1;
					end
				end
			end
			//convert to gray code
			rd_ptr_gray <= {rd_ptr[3], rd_ptr[3:1]^rd_ptr[2:0]};
		end
	end

	// ████████████████████████████████████████████████████████████████
	// ██ CHANGED: NEW 2-STAGE CDC SYNCHRONIZER FOR WRITE CLOCK DOMAIN ██
	// ████████████████████████████████████████████████████████████████
	// Synchronize read-domain pointers to write clock
	always@(posedge wr_clk_i) begin
		if(rst_i == 1) begin
			rd_ptr_wr_clk_sync1 <= 0;
			rd_ptr_wr_clk_sync2 <= 0;
			rd_toggle_f_wr_clk_sync1 <= 0;
			rd_toggle_f_wr_clk_sync2 <= 0;
		end
		else begin
			// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
			// ░░ STAGE 1: Capture potentially metastable input from   ░░
			// ░░          read clock domain (rd_ptr_gray)             ░░
			// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
			rd_ptr_wr_clk_sync1 <= rd_ptr_gray;           // ← Metastable input
			rd_toggle_f_wr_clk_sync1 <= rd_toggle_f;      // ← Metastable input
			
			// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
			// ░░ STAGE 2: Output stable synchronized value             ░░
			// ░░          (delays by 1 write clock cycle)             ░░
			// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
			rd_ptr_wr_clk_sync2 <= rd_ptr_wr_clk_sync1;   // ← Stable output
			rd_toggle_f_wr_clk_sync2 <= rd_toggle_f_wr_clk_sync1;  // ← Stable output
		end
	end

	// ████████████████████████████████████████████████████████████████
	// ██ CHANGED: NEW 2-STAGE CDC SYNCHRONIZER FOR READ CLOCK DOMAIN  ██
	// ████████████████████████████████████████████████████████████████
	// Synchronize write-domain pointers to read clock
	always@(posedge rd_clk_i) begin
		if(rst_i == 1) begin
			wr_ptr_rd_clk_sync1 <= 0;
			wr_ptr_rd_clk_sync2 <= 0;
			wr_toggle_f_rd_clk_sync1 <= 0;
			wr_toggle_f_rd_clk_sync2 <= 0;
		end
		else begin
			// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
			// ░░ STAGE 1: Capture potentially metastable input from   ░░
			// ░░          write clock domain (wr_ptr_gray)            ░░
			// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
			wr_ptr_rd_clk_sync1 <= wr_ptr_gray;           // ← Metastable input
			wr_toggle_f_rd_clk_sync1 <= wr_toggle_f;      // ← Metastable input
			
			// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
			// ░░ STAGE 2: Output stable synchronized value             ░░
			// ░░          (delays by 1 read clock cycle)              ░░
			// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
			wr_ptr_rd_clk_sync2 <= wr_ptr_rd_clk_sync1;   // ← Stable output
			wr_toggle_f_rd_clk_sync2 <= wr_toggle_f_rd_clk_sync1;  // ← Stable output
		end
	end
	
	// ████████████████████████████████████████████████████████████████
	// ██ CHANGED: FULL/EMPTY FLAGS NOW USE STAGE 2 SYNC OUTPUTS        ██
	// ████████████████████████████████████████████████████████████████
	always@(*) begin
		// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
		// ░░ FULL FLAG COMPUTATION (in write clock domain)         ░░
		// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
		full_o = 0;
		if(wr_ptr_gray == rd_ptr_wr_clk_sync2) begin      // ← CHANGED: Uses SYNC2 (stable)
			if(wr_toggle_f != rd_toggle_f_wr_clk_sync2)  // ← CHANGED: Uses SYNC2 (stable)
				full_o = 1;
		end
		
		// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
		// ░░ EMPTY FLAG COMPUTATION (in read clock domain)        ░░
		// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
		empty_o = 0;
		if(wr_ptr_rd_clk_sync2 == rd_ptr_gray) begin      // ← CHANGED: Uses SYNC2 (stable)
			if(wr_toggle_f_rd_clk_sync2 == rd_toggle_f)  // ← CHANGED: Uses SYNC2 (stable)
				empty_o = 1;
		end
	end
	
endmodule