TEST=apb_wr_rd_test

# To compile the testbench --> make compile TEST=<test_name>
compile:
	vcs -sverilog -f build.flist -ntb_opts uvm-1.2 -cm line+tgl+cond -full64 -debug_all +UVM_TESTNAME=$(TEST)
	cd ./out && rm -rf build_$(TEST)
	cd ./out && mkdir build_$(TEST)
	mv csrc simv.daidir simv.vdb simv vc_hdrs.h ./out/build_$(TEST)


# To run simulation --> make sim TEST=<test_name>
sim:
	cd ./out/build_$(TEST) && ./simv -cm line+tgl+cond +UVM_TESTNAME=$(TEST) > build_$(TEST).log


run: compile sim


# To open waveform
gui:
	cd ./out/build_$(TEST) && dve -vpd waveform.vpd


# Code coverage
code_covg:
	urg -report ./out/code_coverage_report -dir ./out/build_*/*.vdb


# Functional coverage report
func_covg:
	urg -report ./out/functional_coverage_report -dir ./out/build_*/*.vdb


coverage: code_covg func_covg


# Clean
clean:
	cd ./out && rm -rf build_$(TEST)
