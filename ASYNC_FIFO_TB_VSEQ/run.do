#compilation
vlog +incdir+/hdd2/home/siddharth/src top_tb.sv

set testname async_fifo_base_test
variable time      [ format "%s" [clock format [clock seconds] -format %m%d_%H%M] ]
set log_f "$testname\_$time\.log"

#elaboration
vsim -novopt -supress 12100 top -sv_lib /home/tools/mentor/MENTOR_SOURCE/QUESTA/questasim/uvm-1.2/linux_x86_64/uvm_dpi -l $log_f +UVM_TEST_NAME=$testname

#do wave.do

#simulation

run -all
