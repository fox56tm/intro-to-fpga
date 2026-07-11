IVERILOG ?= iverilog
VVP ?= vvp
FLAGS = -g2012

.PHONY: all clean

all: | build
	$(IVERILOG) $(FLAGS) -o build/test1.out 1_exercise/*.sv mux_2to1.sv && $(VVP) build/test1.out
	$(IVERILOG) $(FLAGS) -o build/test2.out 2_exercise/*.sv mux_2to1.sv && $(VVP) build/test2.out
	$(IVERILOG) $(FLAGS) -o build/test4.out 4_exercise/*.sv mux_2to1.sv && $(VVP) build/test4.out

build:
	mkdir -p build

clean:
	rm -rf build
