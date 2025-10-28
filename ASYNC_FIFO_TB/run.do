#compilation
vlog +incdir+/hdd2/home/siddharth/src top_tb.sv

#elaboration
vsim -novopt -supress 12100 top -sv_lib /home/tools/mentor/MENTOR_SOURCE/QUESTA/questasim/uvm-1.2/linux_x86_64/uvm_dpi

#do wave.do

#simulation

run -all
