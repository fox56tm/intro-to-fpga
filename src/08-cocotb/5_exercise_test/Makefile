TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)


ifeq ($(TOPLEVEL_LANG),verilog)
    VERILOG_SOURCES = $(PWD)/../../07-bus/5_exercise/conv1d.sv
else
    $(error A valid value (verilog) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG))
endif

TOPLEVEL := conv1d
MODULE   := conv1d_test

include $(shell cocotb-config --makefiles)/Makefile.sim
