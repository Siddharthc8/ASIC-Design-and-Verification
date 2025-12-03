// Code your design here
`define DEPTH 16
`define WIDTH 16

module async_fifo(
	wr_clk_i, rd_clk_i, rst_i, wr_en_i, wdata_i, rd_en_i, rdata_o, full_o, empty_o, wr_error_o, rd_error_o
);
	//depth of fifo=16 loc, width of each data=8 bit
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
	reg[3:0]wr_ptr,rd_ptr;
	reg[3:0]wr_ptr_gray,rd_ptr_gray;
	reg[3:0]wr_ptr_rd_clk,rd_ptr_wr_clk;
	reg wr_toggle_f,rd_toggle_f;
	reg wr_toggle_f_rd_clk,rd_toggle_f_wr_clk;
	//fifo memory structure
  reg[WIDTH-1:0]fifo[DEPTH-1:0];
	//loop variable
	integer i;
	
	//everytime there is a posedge of input clock, we will check for
	//values of rst, wr_nd_en to proceed with corresponding functionality
	//active high reset : reset the fifo when rst signal is high
	always@(posedge wr_clk_i)begin
		if(rst_i==1)begin
			//reset output ports and internal regs
			rdata_o <=0;
			full_o <=0;
			empty_o <=0;
			wr_error_o <=0;
			rd_error_o <=0;
			wr_ptr <=0;
			rd_ptr <=0;
			wr_ptr_gray <=0;
			rd_ptr_gray <=0;
			wr_ptr_rd_clk <=0;
			rd_ptr_wr_clk <=0;
			wr_toggle_f <=0;
			rd_toggle_f <=0;
			wr_toggle_f_rd_clk <=0;
			rd_toggle_f_wr_clk <=0;
			for(i=0;i<16;i=i+1)
				fifo[i] <=0;
		end
		else begin
			wr_error_o <=0;
			//normal operation
			if(wr_en_i==1)begin
				//is full flag high?
				if(full_o==1)begin
					//error raised
					wr_error_o <=1;
				end
				else begin
					//write operation
					fifo[wr_ptr]<=wdata_i;
                  if(wr_ptr==DEPTH-1)begin
						wr_ptr<=0;
						wr_toggle_f<=~wr_toggle_f;
					end
					else begin
						wr_ptr<=wr_ptr+1;
					end
				end
			end
			//wr_ptr_gray<=gray_conv(wr_ptr);
			wr_ptr_gray<={wr_ptr[3],wr_ptr[3:1]^wr_ptr[2:0]};
		end
	end


	always@(posedge rd_clk_i)begin
		if(rst_i==0)begin
			rd_error_o<=0;
			if(rd_en_i==1)begin
				//is empty flag high?
				if(empty_o==1)begin
					//error raised
					rd_error_o <=1;
				end
				else begin
					//read operation
					rdata_o<=fifo[rd_ptr];
					if(rd_ptr==DEPTH-1)begin
						rd_ptr<=0;
						rd_toggle_f<=~rd_toggle_f;
					end
					else begin
						rd_ptr<=rd_ptr+1;
					end
				end
			end
			//rd_ptr_gray<=gray_conv(rd_ptr);
			rd_ptr_gray<={rd_ptr[3],rd_ptr[3:1]^rd_ptr[2:0]};
		end
	end
	always@(posedge wr_clk_i)begin
		//single stage synchronizer
		rd_ptr_wr_clk<=rd_ptr_gray;
		rd_toggle_f_wr_clk<=rd_toggle_f;
	end
	always@(posedge rd_clk_i)begin
		//single stage synchronizer
		wr_ptr_rd_clk<=wr_ptr_gray;
		wr_toggle_f_rd_clk<=wr_toggle_f;
	end
	
	always@(*)begin
		full_o=0;
		if(wr_ptr_gray==rd_ptr_wr_clk)begin
			if(wr_toggle_f!=rd_toggle_f_wr_clk)	full_o=1;
		end
		empty_o=0;
		if(wr_ptr_rd_clk==rd_ptr_gray)begin
			if(wr_toggle_f_rd_clk==rd_toggle_f)	empty_o=1;
		end
	end
	
endmodule