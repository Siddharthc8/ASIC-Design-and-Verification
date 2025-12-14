`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2025 08:36:45 AM
// Design Name: 
// Module Name: tb_UVM_makefile_commands
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


module tb_UVM_makefile_commands();

/*

///////////////////////////////////   MY run.sh file   /////////////////////////////////////

# vlogan -sverilog design.sv test.sv   ---> can pass this one too for parsing 

vcs -full64 -debug_access+all -kdb\
    +incdir+/home/tools/synopsys/SYNOPSYS_INSTALL_2023/vcs/U-2023.03-SP2-1/etc/uvm-1.2/src/\
    +define+UVM_NO_DPI\
    
tb_phases_build_order.sv -| <log_file_name>.log
./simv
#run -all


////////////////////////////    One of instructor's        /////////////////////////////////////////

vlog top.sv                                                       ---> File to elaborate
 
set fp [open "test_list.txt" r] # fp means file pointer           ---> Opening a file and setting it to fp
while { gets $fp testname] >= 0 } {                               ---> Checking if the value of the file is not null
	puts $testname      #Optional just prints the test_name       ---> Just printing the file name 
	vsim top +UVM_TESTNAME=$testname                              ---> Simulating using the file name
	run -all                                                      ---> run -all commands to execute all the above commands
}


# test_list.txt contains all the test_names

/////////////////////////////   Instructor used on questa changed to VCS ///////////////////////////////////////////////

vlog +define+UVM_NO_DPI +incdir+/hdds/home/home/siddharthsid/src apb_tb_top.sv   ---> The vlog command for 
set testname apb_err_wr_rd_test
variable time [format "%s" [clock format [clock seconds] -format %Y%m%d_%H%M ] ]
set log_f "$test_name\$time\.log"
vsim top -sv_lib /home/tools/synopsys/<more to it> +UVM_TESTNME=%testname -l $log_f +UVM_TIMEOUT=1000 +UVM_VERBOSITY=UVM_MEDIUM -supress 12110      # "-sv_lib" is added when you remove DPI
run -all

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////





*/


endmodule
