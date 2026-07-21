TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)


ifeq ($(TOPLEVEL_LANG),verilog)
    VERILOG_SOURCES = $(PWD)/../../07-bus/2_exercise/pipe_adder.sv
else
    $(error A valid value (verilog) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG))
endif

TOPLEVEL := pipe_adder
MODULE   := pipe_adder_test

include $(shell cocotb-config --makefiles)/Makefile.sim
