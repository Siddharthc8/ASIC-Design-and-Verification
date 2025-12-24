#vcs -sverilog -full64 -debug_access+all -kdb +incdir+../../src +define+UVM_NO_DPI top.sv
#./simv +UVM_TIMEOUT=5000 -l sim.log &

vcs -sverilog -full64 +incdir+../../src +define+UVM_NO_DPI top.sv \
+incdir+../hdd2/home/siddharthsid/Sid/AXI_UVC_BYTE_SBD \
-debug_access+all -kdb \
-ntbs_opts uvm-1.2 \
+define+UVM_NO_DPI

./simv +UVM_VERBOSITY=UVM_FULL +UVM_TESTNAME="axi_wr_rd_test" -seed=14589 -l sim.log &
