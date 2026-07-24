TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)


ifeq ($(TOPLEVEL_LANG),verilog)
    VERILOG_SOURCES = $(PWD)/../../src/image_conv.sv
    VERILOG_SOURCES += $(PWD)/../../../../05-types/4_exercise/scalar_product.sv
    VERILOG_SOURCES += $(PWD)/../../src/windowed_bytes.sv
    VERILOG_SOURCES += $(PWD)/../../../../05-types/3_exercise/float_mult_byte_modified.sv
    VERILOG_SOURCES += $(PWD)/../../src/conv1d_bytes.sv
    VERILOG_SOURCES += $(PWD)/../../src/conv1d_parallel_m.sv
    VERILOG_SOURCES += $(PWD)/../../src/in_line_buffer.sv
else
    $(error A valid value (verilog) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG))
endif

TOPLEVEL := image_conv
MODULE   := image_conv_test

include $(shell cocotb-config --makefiles)/Makefile.sim
