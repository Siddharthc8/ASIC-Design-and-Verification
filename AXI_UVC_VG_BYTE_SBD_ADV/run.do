vlog top.sv \
+incdir+/home/bhaskar2101/src \
+define+UVM_NO_DPI

vsim -novopt -suppress 12110 top \
+UVM_TEST_NAME=axi_wr_rd_test \
+UVM_VERBOSITY=UVM_FULL 

add wave -position insertpoint sim:/top/pif/*