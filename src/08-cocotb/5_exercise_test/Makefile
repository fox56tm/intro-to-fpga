TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)


ifeq ($(TOPLEVEL_LANG),verilog)
    VERILOG_SOURCES = $(PWD)/../../07-bus/5_exercise/conv1d.sv
    VERILOG_SOURCES += $(PWD)/../../05-types/4_exercise/scalar_product.sv
    VERILOG_SOURCES += $(PWD)/../../07-bus/4_exercise/windowed.sv
    VERILOG_SOURCES += $(PWD)/../../05-types/3_exercise/float_mult_byte_modified.sv
else
    $(error A valid value (verilog) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG))
endif

TOPLEVEL := conv1d
MODULE   := conv1d_test

include $(shell cocotb-config --makefiles)/Makefile.sim
