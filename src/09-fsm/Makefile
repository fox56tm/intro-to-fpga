TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)
export PYTHONPATH := $(PWD)/1-3_exercises/tests:$(PYTHONPATH)

ifeq ($(TOPLEVEL_LANG),verilog)
    VERILOG_SOURCES = $(PWD)/1-3_exercises/tests/codec_top.sv
    VERILOG_SOURCES += $(PWD)/1-3_exercises/encoder.sv
    VERILOG_SOURCES += $(PWD)/1-3_exercises/decoder.sv
else
    $(error A valid value (verilog) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG))
endif

TOPLEVEL := codec_top
MODULE   := codec_test

include $(shell cocotb-config --makefiles)/Makefile.sim
