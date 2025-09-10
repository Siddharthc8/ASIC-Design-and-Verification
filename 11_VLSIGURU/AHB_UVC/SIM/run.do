vlog +incdir+/<path> top.sv
vsim -novopt top -sv_lib /<dpi_path> +UVM_TESTNAME=ahb_wr_rd_test -l run.log +UVM_TIMEOUT=5000 +UVM_VERBOSITY=UVM_MEDIUM +count=3
do wave.do
run -all
