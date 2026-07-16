IVERILOG ?= iverilog
VVP ?= vvp
FLAGS = -g2012

.PHONY: all clean

all: | build
	$(IVERILOG) $(FLAGS) -o build/test1.out 1_exercise/*.sv && $(VVP) build/test1.out

build:
	mkdir -p build

clean:
	rm -rf build
