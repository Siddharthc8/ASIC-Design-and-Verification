`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/21/2025 01:33:44 PM
// Design Name: 
// Module Name: tb_vcs_run_file
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


module tb_vcs_run_file();

/*

vcs -full64 -sverilog -debug_access+all -kdb\
    +incdir+/home/tools/synopsys/SYNOPSYS_INSTALL_2023/vcs/U-2023.03-SP2-1/etc/uvm-1.2/src/\
    +define+UVM_NO_DPI\
<filename.sv>
./simv
#run -all

*/

endmodule
