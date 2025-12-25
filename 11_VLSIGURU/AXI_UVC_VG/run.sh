vcs -sverilog -full64 -debug_access+all -kdb +incdir+../../src +define+UVM_NP_DPI top.sv
./simv +UVM_TIMEOUT=5000 -l sim.log &