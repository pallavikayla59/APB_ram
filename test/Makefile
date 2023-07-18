SIM ?= icarus
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES += $(PWD)/../hdl/dut.sv
VERILOG_SOURCES += $(PWD)/wrappers/dut_test.sv

dut:
	rm -rf sim_build
	$(MAKE) sim MODULE=dut_test TOPLEVEL=dut_test
include $(shell cocotb-config --makefiles)/Makefile.sim
